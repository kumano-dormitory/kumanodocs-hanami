module Admin::Controllers::Meeting
  module Article
    class Create
      include Admin::Action
      expose :meeting, :categories

      params do
        required(:article).schema do
          required(:meeting_id).filled(:int?)
          required(:categories) { array? { min_size?(1) & each { int? } } }
          required(:checked).filled(:bool?)
          required(:title).filled(:str?)
          required(:author).schema do
            required(:name).filled(:str?)
            required(:password).filled(:str?).confirmation
            required(:password_confirmation).filled(:str?)
          end
          required(:format).filled(:bool?)
          required(:body).filled(:str?)
          optional(:vote_content).maybe(:str?)
        end
        required(:meeting_id).filled(:int?)
      end

      def initialize(meeting_repo: MeetingRepository.new,
                     article_repo: ArticleRepository.new,
                     category_repo: CategoryRepository.new,
                     author_repo: AuthorRepository.new)
        @meeting_repo = meeting_repo
        @article_repo = article_repo
        @category_repo = category_repo
        @author_repo = author_repo
        @notifications = {}
      end

      def call(params)
        if params.valid?
          author_params = params[:article][:author]

          categories = params[:article][:categories].map { |id| @category_repo.find(id) }
          # 採決項目の設定
          category_params = categories.map { |category|
            if category.require_content && category.name == '採決'
              { category_id: category.id, extra_content: params[:article][:vote_content] }
            else
              { category_id: category.id, extra_content: nil }
            end
          }
          article_params = params[:article].except(:author, :categories).merge(
            format: (params[:article][:format] ? 1 : 0)
          )
          article = @article_repo.create_with_related_entities(author_params, category_params, article_params)

          flash[:notifications] = {success: {status: "Success", message: "正常に議案が作成されました"}}
          redirect_to routes.meeting_article_path(meeting_id: article.meeting_id, id: article.id)
        else
          @meeting = @meeting_repo.find(params[:meeting_id])
          @categories = @category_repo.all
          @notifications = {error: {status: "Error:", message: "入力された項目に不備があります. もう一度確認してください"}}
          self.status = 422
        end
      end

      def notifications
        @notifications
      end
    end
  end
end
