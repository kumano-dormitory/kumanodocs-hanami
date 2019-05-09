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
                   comment_repo: CommentRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @block_repo = block_repo
      @comment_repo = comment_repo
    end

    def call(params)
      if params.valid?
        @meeting = @meeting_repo.find_with_articles(params[:id])
        if params[:articles]
          @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
          past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
          @past_comments = @comment_repo.by_meeting(past_meeting.id)
                                        .group_by{|comment| comment[:article_id]}
          # 出力する議案の印刷フラグをすべてtrueにする
          @article_repo.update_status(@articles.map{ |article| { 'article_id' => article.id, 'printed' => true}})
          @tex_str = Admin::Views::Meeting::Download.render(
            format: :tex, meeting: @meeting, articles: @articles, past_comments: @past_comments, type: :articles
          )
          # write_file(temp, @tex)
          # run_command(ptex2pdf -u -l, temp)
          # self.format = :pdf
          # unsafe_send_file Pathname.new("/path/to/pdf")
          self.format = :txt
        elsif params[:comments]
          @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
          @blocks = @block_repo.all
          @tex_str = Admin::Views::Meeting::Download.render(format: :tex, meeting: @meeting, articles: @articles, blocks: @blocks, type: :comments)
          # write_file(temp, @tex)
          # run_command(ptex2pdf -u -l, temp)
          # self.format = :pdf
          # unsafe_send_file Pathname.new("/path/to/pdf")
          self.format = :txt
        else
          @view_type = :meeting
        end
      else
        @meetings = @meeting_repo.desc_by_date(limit: 20)
        @view_type = :meetings
      end
    end

    def navigation
      @navigation = {pdf: true}
    end
  end
end
