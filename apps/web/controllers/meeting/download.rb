require 'fileutils'
require 'digest/md5'

module Web::Controllers::Meeting
  class Download
    include Web::Action
    expose :meetings, :tex_str

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   comment_repo: CommentRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @comment_repo = comment_repo
      @authenticator = authenticator
    end

    def call(params)
      if params.valid?
        # ブロック会議が指定されているのでPDFを返す
        @meeting = @meeting_repo.find_with_articles(params[:id])

        @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
        past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
        @past_comments = @comment_repo.by_meeting(past_meeting.id)
                                      .group_by{|comment| comment[:article_id]}
        @tex_str = Web::Views::Meeting::Download.render(
          format: :tex, meeting: @meeting, articles: @articles, past_comments: @past_comments
        )
        digest = Digest::MD5.hexdigest(@tex_str)
        tmp_filename = "kumanodocs_meeting_#{@meeting.id}"
        tmp_folderpath = "/tmp/kumanodocs/meeting#{@meeting.id}/a#{digest}/"

        unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
          FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
          open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
            f.puts(@tex_str)
          end
          halt 500 unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
          halt 500 unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
        end

        self.format = :pdf
        self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_meeting_#{@meeting.date}.pdf\""})
        unsafe_send_file Pathname.new("#{tmp_folderpath}#{tmp_filename}.pdf")
      else
        # ブロック会議を指定する画面を表示する
        @meetings = @meeting_repo.desc_by_date(limit: 20)
      end
    end

    def navigation
      @navigation = {download: true}
    end
  end
end
