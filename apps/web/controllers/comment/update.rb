module Web::Controllers::Comment
  class Update
    include Web::Action
    expose :meeting, :block_id, :comment_datas

    params do
      required(:meeting).schema do
        required(:articles) { array? }
      end
      required(:meeting_id).filled(:int?)
      required(:block_id).filled(:int?)
      required(:comments).schema do
        required(:password).filled(:str?)
      end
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
    end

    def call(params)
      if params.valid?
        create_datas = []
        update_datas = []
        authentication_err = false
        params[:meeting][:articles].each do |data|
          props = {article_id: data['article_id'], block_id: params[:block_id], body: data['comment']}
          comment = @comment_repo.find(props[:article_id], props[:block_id])
          if comment.nil?
            # 議事録が存在しなければ新規作成する。
            create_datas << props.merge(
              crypt_password: Comment.crypt(params[:comments][:password])
            ) unless props[:body].empty?
          else
            if comment.authenticate(params[:comments][:password])
              update_datas << props.merge(id: comment.id)
            else
              authentication_err = true
            end
          end
        end
        if authentication_err
          @meeting = @meeting_repo.find_with_articles(params[:meeting_id])
          @block_id = params[:block_id]
          @comment_datas = @meeting.articles.map do |article|
            comment = @comment_repo.find(article.id, params[:block_id])
            { article_id: article.id, comment: comment&.body }
          end
          self.status = 422
        else
          # 正常終了
          @comment_repo.create_list(create_datas) unless create_datas.empty?
          @comment_repo.update_list(update_datas) unless update_datas.empty?
          redirect_to routes.root_path
        end
      else
        @meeting = @meeting_repo.find_with_articles(params[:meeting_id])
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
