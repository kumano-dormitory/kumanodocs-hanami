module Admin::Controllers::Meeting
  module Article
    class Destroy
      include Admin::Action
      expose :article

      params do
        required(:article).schema do
          required(:confirm).filled(:bool?)
        end
      end

      def initialize(article_repo: ArticleRepository.new)
        @article_repo = article_repo
      end

      def call(params)
        @article = @article_repo.find_with_relations(params[:id])
        if params.valid?
          @article_repo.delete(params[:id])
          flash[:notifications] = {success: {status: "Success:", message: "正常に議案：#{@article.title}が削除されました"}}
          redirect_to routes.meeting_articles_path(meeting_id: params[:meeting_id])
        end
      end
    end
  end
end
