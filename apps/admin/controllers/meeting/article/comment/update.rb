module Admin::Controllers::Meeting
  module Article
    module Comment
      class Update
        include Admin::Action
        expose :article, :block, :comment, :vote_result

        params do
          required(:article_id).filled(:int?)
          required(:block_id).filled(:int?)
          required(:comment).schema do
            required(:body).filled(:str?)
            optional(:agree) { filled? & int? & gteq?(0) }
            optional(:disagree) { filled? & int? & gteq?(0) }
            optional(:onhold) { filled? & int? & gteq?(0) }
          end
        end

        def initialize(article_repo: ArticleRepository.new,
                       block_repo: BlockRepository.new,
                       comment_repo: CommentRepository.new,
                       vote_result_repo: VoteResultRepository.new,
                       admin_history_repo: AdminHistoryRepository.new,
                       authenticator: AdminAuthenticator.new)
          @article_repo = article_repo
          @block_repo = block_repo
          @comment_repo = comment_repo
          @vote_result_repo = vote_result_repo
          @admin_history_repo = admin_history_repo
          @authenticator = authenticator
          @notifications = {}
        end

        def call(params)
          @article = @article_repo.find_with_relations(params[:article_id])
          @block = @block_repo.find(params[:block_id])
          if params.valid?
            props = {
              article_id: params[:article_id],
              block_id: params[:block_id],
              body: params[:comment][:body]
            }
            comment = @comment_repo.find(params[:article_id], params[:block_id])
            if comment.nil?
              # 議事録が存在しない
              @comment_repo.create(props.merge({crypt_password: '1'}))
            else
              # 議事録のupdate
              @comment_repo.update(comment.id, props)
            end

            # 採決結果の保存
            vr_props = {
              article_id: params[:article_id],
              block_id: params[:block_id],
              agree: params[:comment][:agree],
              disagree: params[:comment][:disagree],
              onhold: params[:comment][:onhold]
            }
            if vr_props[:agree] && vr_props[:disagree] && vr_props[:onhold] && \
              @article.categories.find{ |category| category.require_content && category.name == '採決' }

              vote_result = @vote_result_repo.find(params[:article_id], params[:block_id])
              if vote_result.nil?
                @vote_result_repo.create(vr_props.merge({crypt_password: '1'}))
              else
                @vote_result_repo.update(vote_result.id, vr_props)
              end
            end
            @admin_history_repo.add(:comment_update, gen_history_json(@article, @block, comment, props, vote_result, vr_props))
            flash[:notifications] = {success: {status: "Success:", message: "正常に議事録が編集されました"}}
            redirect_to routes.meeting_article_path(meeting_id: 0, id: params[:article_id])
          else
            @comment = @comment_repo.find(params[:article_id], params[:block_id])
            @vote_result = VoteResult.new(params[:comment])
            @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
            self.status = 422
          end
        end

        def gen_history_json(article, block, comment_before, comment_props, vote_result_before, vote_result_props)
          JSON.pretty_generate({
            action: "comment_update",
            payload: {
              article: article.to_h.slice(:id, :title).merge({meeting: article.meeting.to_h.slice(:id, :date), author: {name: article.author.name}}),
              block: block.to_h.slice(:id, :name),
              comment_before: comment_before.to_h,
              comment_after: comment_props,
              vote_result_before: vote_result_before.to_h,
              vote_result_after: vote_result_props
            }
          })
        end

        def notifications
          @notifications
        end
      end
    end
  end
end
