module Web::Controllers::Meeting
  class Download
    include Web::Action
    expose :meetings, :tex_str

    params do
      required(:id) { filled? & int? & gt?(0) }
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   comment_repo: CommentRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @comment_repo = comment_repo
    end

    def call(params)
      if params.valid?
        # ブロック会議が指定されているのでPDFを返す
        @meeting = @meeting_repo.find_with_articles(params[:id])

        @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
        past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
        @past_comments = @comment_repo.by_past_meeting(past_meeting.id)
                                      .group_by{|comment| comment[:article_id]}
        @tex_str = Admin::Views::Meeting::Download.render(
          format: :tex, meeting: @meeting, articles: @articles, past_comments: @past_comments, type: :articles
        )
        # write_file(temp, @tex)
        # run_command(ptex2pdf -u -l, temp)
        # self.format = :pdf
        # unsafe_send_file Pathname.new("/path/to/pdf")
        self.format = :txt
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
