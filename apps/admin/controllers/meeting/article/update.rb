module Admin::Controllers::Meeting
  module Article
    class Update
      include Admin::Action
      expose :meetings, :categories, :recent_articles, :article_refs_selected

      params do
        required(:article).schema do
          required(:meeting_id).filled(:int?)
          required(:categories) { array? { min_size?(1) & each { int? } } }
          required(:title).filled(:str?)
          required(:author).schema do
            required(:name).filled(:str?)
          end
          required(:format).filled(:bool?)
          required(:body).filled(:str?)
          optional(:vote_content).maybe(:str?)
          optional(:same_refs_selected) { array? { each { int? } } }
          optional(:other_refs_selected) { array? { each { int? } } }
        end
        required(:id).filled(:int?)
      end

      def initialize(meeting_repo: MeetingRepository.new,
                     article_repo: ArticleRepository.new,
                     category_repo: CategoryRepository.new,
                     author_repo: AuthorRepository.new,
                     article_reference_repo: ArticleReferenceRepository.new,
                     admin_history_repo: AdminHistoryRepository.new)
        @meeting_repo = meeting_repo
        @article_repo = article_repo
        @category_repo = category_repo
        @author_repo = author_repo
        @article_reference_repo = article_reference_repo
        @admin_history_repo = admin_history_repo
        @notifications = {}
      end

      def call(params)
        if params.valid?
          article = @article_repo.find_with_relations(params[:id], minimum: true)

          categories = params[:article][:categories].map { |id| @category_repo.find(id) }
          # 採決項目の設定
          category_params = categories.map { |category|
            if category.require_content && category.name == '採決'
              { category_id: category.id, extra_content: params[:article][:vote_content] }
            else
              { category_id: category.id, extra_content: nil }
            end
          }
          article_params = params[:article].to_h.merge(
            format: (params[:article][:format] ? 1 : 0)
          )
          @article_repo.update_categories(article, category_params)
          @author_repo.update(article.author_id, params[:article][:author])
          article_ret = @article_repo.update(article.id, article_params)
          @article_reference_repo.update_refs(article.id, params[:article][:same_refs_selected], params[:article][:other_refs_selected])
          @admin_history_repo.add(:article_update, gen_history_json(article, article_ret, category_params, params))
          flash[:notifications] = {success: {status: "Success:", message: "正常に議案が編集されました"}}
          redirect_to routes.meeting_article_path(meeting_id: article.meeting_id, id: article.id)
        else
          @meetings = @meeting_repo.desc_by_date
          @categories = @category_repo.all
          @recent_articles = @article_repo.of_recent(months: 6, past_meeting_only: false, with_relations: true)
          @article_refs_selected = {
            same: params[:article][:same_refs_selected], other: params[:article][:other_refs_selected]
          }
          @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
          self.status = 422
        end
      end

      def gen_history_json(article_before, article_after, category_params, params)
        JSON.pretty_generate({
          action:"article_update",
          payload: {
            article_before: article_before.to_h.merge({
              meeting: article_before.meeting.to_h,
              author: article_before.author.to_h.slice(:name),
              categories: article_before.categories.map(&:to_h)
            }),
            article_after: article_after.to_h.merge({
              author: params[:article][:author],
              categories: category_params,
              article_references: {same: params[:article][:same_refs_selected], other: params[:article][:other_refs_selected]}
            })
          }
        })
      end

      def notifications
        @notifications
      end
    end
  end
end
