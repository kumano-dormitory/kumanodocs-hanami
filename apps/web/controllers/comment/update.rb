module Web::Controllers::Comment
  class Update
    include Web::Action

    params do
      required(:meeting).schema do
        required(:articles) { array? }
      end
      required(:meeting_id).filled(:int?)
      required(:block_id).filled(:int?)
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
    end

    def call(params)
      if params.valid?
        update_datas = []
        params[:meeting][:articles].each do |data|
          props = {article_id: data['article_id'], block_id: params[:block_id], body: data['comment']}
          comment = @comment_repo.find(props[:article_id], props[:block_id])
          if comment.nil?
            # 議事録が存在しなければ新規作成する。
            @comment_repo.create(props)
          else
            update_datas << props.merge(id: comment.id)
          end
        end
        @comment_repo.update_list(update_datas) unless update_datas.empty?
        redirect_to routes.root_path
      else
        @meetings = @meeting_repo.find_with_articles(id: params[:meeting_id])
        @block_id = params[:block_id]
        @comment_datas = @meeting.articles.map do |article|
          comment = @comment_repo.find(article.id, params[:block_id])
          { article_id: article.id, comment: comment&.body }
        end
        self.status = 422
      end
    end
  end
end
