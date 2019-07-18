require 'hanami/interactor'

class GeneratePdf
  include Hanami::Interactor
  expose :path

  def initialize(article_repo: ArticleRepository.new,
                 meeting_repo: MeetingRepository.new,
                 comment_repo: CommentRepository.new,
                 admin_history_repo: AdminHistoryRepository.new)
    @article_repo = article_repo
    @meeting_repo = meeting_repo
    @comment_repo = comment_repo
    @admin_history_repo = admin_history_repo
    @path = ""
  end

  def call(specification)

    if specification.type == :admin_articles
      @meeting = @meeting_repo.find(specification.meeting_id)
      @articles = @article_repo.for_download(@meeting, after_6pm: specification.after_6pm)
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
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    elsif specification.type == :admin_comments
      @meeting = @meeting_repo.find_with_articles(specification.meeting_id)
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
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    else
      # option[:for] == :web_articles
      @meeting = @meeting_repo.find_with_articles(specification.meeting_id)

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
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    end
  end
end
