module Admin::Controllers::Meeting
  module Article
    module Table
      class New
        include Admin::Action
        expose :article

        def initialize(article_repo: ArticleRepository.new,
                       authenticator: AdminAuthenticator.new)
          @article_repo = article_repo
          @authenticator = authenticator
        end

        def call(params)
          @article = @article_repo.find(params[:article_id])
        end
      end
    end
  end
end
