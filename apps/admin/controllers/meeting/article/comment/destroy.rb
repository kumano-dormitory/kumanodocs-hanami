module Admin::Controllers::Meeting
  module Article
    module Comment
      class Destroy
        include Admin::Action
        expose :article, :block, :comment

        params do
          required(:article_id).filled(:int?)
          required(:block_id).filled(:int?)
          required(:comment).schema do
            required(:confirm_delete).filled(:bool?)
          end
        end

        def initialize(article_repo: ArticleRepository.new,
                       block_repo: BlockRepository.new,
                       comment_repo: CommentRepository.new,
                       admin_history_repo: AdminHistoryRepository.new)
          @article_repo = article_repo
          @block_repo = block_repo
          @comment_repo = comment_repo
          @admin_history_repo = admin_history_repo
          @notifications = {}
        end

        def call(params)
          @article = @article_repo.find_with_relations(params[:article_id], minimum: true)
          @block = @block_repo.find(params[:block_id])
          @comment = @comment_repo.find(params[:article_id], params[:block_id])
          if params.valid? && params[:comment][:confirm_delete]
            if @comment
              @comment_repo.delete(@comment.id)
              @admin_history_repo.add(:comment_destroy, gen_history_json(@article, @block, @comment))
              flash[:notifications] = {success: {status: 'Success', message: '正常に議事録が削除されました'}}
              redirect_to routes.meeting_article_path(meeting_id: @article.meeting_id, id: @article.id)
            else
              @notifications = {error: {status: 'Error', message: '議事録が存在しないため削除できません'}}
            end
          else
            if @comment
              @notifications = {caution: {status: '注意', message: '削除の確認チェックにチェックを入れてから削除を行ってください'}}
            else
              @notifications = {error: {status: 'Error', message: '議事録が存在しないため削除できません'}}
            end
          end
        end

        def gen_history_json(article, block, comment)
          JSON.pretty_generate({
            action:"comment_destroy",
            payload:{
              article: article.to_h.slice(:id, :title).merge({meeting: article.meeting.to_h.slice(:id, :date), author: {name: article.author.name}}),
              block: block.to_h.slice(:id, :name),
              comment: comment.to_h
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
