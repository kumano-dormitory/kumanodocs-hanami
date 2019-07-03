require 'fileutils'
require 'digest/md5'

module Admin::Controllers::Meeting
  class Download
    include Admin::Action
    expose :meetings, :meeting, :tex_str, :view_type

    params do
      required(:id) { filled? & int? & gt?(0) }
      optional(:articles).filled(:bool?)
      optional(:comments).filled(:bool?)
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new,
                   comment_repo: CommentRepository.new,
                   admin_history_repo: AdminHistoryRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @block_repo = block_repo
      @comment_repo = comment_repo
      @admin_history_repo = admin_history_repo
    end

    def call(params)
      if params.valid?
        @meeting = @meeting_repo.find(params[:id])
        if params[:articles]
          @articles = @article_repo.for_download(@meeting, after_6pm: after_6pm(@meeting))
          past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
          @past_comments = @comment_repo.by_meeting(past_meeting.id)
                                        .group_by{|comment| comment[:article_id]}
          # 出力する議案の印刷フラグをすべてtrueにする
          @article_repo.update_printed(@articles.map{ |article| { id: article.id, printed: true}})
          @admin_history_repo.add(:meeting_download,
            JSON.pretty_generate({action: "meeting_download", payload: {meeting: @meeting.to_h.merge({articles: @articles.map(&:id)})}})
          )
          @tex_str = Admin::Views::Meeting::Download.render(
            format: :tex, meeting: @meeting, articles: @articles, past_comments: @past_comments, type: :articles
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
        elsif params[:comments]
          @meeting = @meeting_repo.find_with_articles(params[:id])
          @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
          @blocks = @block_repo.all
          @tex_str = Admin::Views::Meeting::Download.render(format: :tex, meeting: @meeting, articles: @articles, blocks: @blocks, type: :comments)

          digest = Digest::MD5.hexdigest(@tex_str)
          tmp_filename = "kumanodocs_comments_#{@meeting.id}"
          tmp_folderpath = "/tmp/kumanodocs/comments#{@meeting.id}/a#{digest}/"

          unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
            FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
            open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
              f.puts(@tex_str)
            end
            halt 500 unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
            halt 500 unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
          end

          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "attachment; filename=\"kumanodocs_comments_#{@meeting.date}.pdf\""})
          unsafe_send_file Pathname.new("#{tmp_folderpath}#{tmp_filename}.pdf")
        else
          @view_type = :meeting
        end
      else
        @meetings = @meeting_repo.desc_by_date(limit: 20)
        @view_type = :meetings
      end
    end

    def after_6pm(meeting, now: Time.now)
      date = meeting.date
      meeting_date_6pm = Time.new(date.year, date.mon, date.day, 18,0,0,"+09:00")
      now > meeting_date_6pm
    end

    def navigation
      @navigation = {pdf: true}
    end
  end
end
