module Web::Controllers::Comment
  class Edit
    include Web::Action
    expose :meeting, :block_id, :comment_datas

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:meeting_id])
      @block_id = params[:block_id]
      @comment_datas = @meeting.articles.map do |article|
        comment = @comment_repo.find(article.id, params[:block_id])
        { article_id: article.id, comment: comment&.body }
      end
    end
  end
end
