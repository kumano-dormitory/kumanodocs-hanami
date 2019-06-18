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

      def initialize(article_repo: ArticleRepository.new,
                     admin_history_repo: AdminHistoryRepository.new)
        @article_repo = article_repo
        @admin_history_repo = admin_history_repo
      end

      def call(params)
        @article = @article_repo.find_with_relations(params[:id])
        if params.valid?
          @article_repo.delete(params[:id])
          @admin_history_repo.add(:article_destroy, gen_history_json(@article))
          flash[:notifications] = {success: {status: "Success:", message: "正常に議案：#{@article.title}が削除されました"}}
          redirect_to routes.meeting_articles_path(meeting_id: params[:meeting_id])
        end
      end

      def gen_history_json(article)
        JSON.pretty_generate({
          action:"article_destroy",
          payload: {
            article: article.to_h.merge({
              meeting: article.meeting.to_h,
              author: article.author.to_h.slice(:name),
              article_categories: article.article_categories.map(&:to_h),
              categories: article.categories.map(&:to_h),
              comments: article.comments.map(&:to_h),
              tables: article.tables.map(&:to_h),
              vote_results: article.vote_results.map(&:to_h)
            })
          }
        })
      end
    end
  end
end
