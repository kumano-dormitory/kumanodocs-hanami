module Web::Controllers::Article
  class Index
    include Web::Action
    expose :articles_by_meeting, :save_token

    def initialize(article_repo: ArticleRepository.new,
                   authenticator: JwtAuthenticator.new)
      @article_repo = article_repo
      @authenticator = authenticator
    end

    def call(params)
      @articles_by_meeting = @article_repo.group_by_meeting

      # PWAからログインした場合にtokenをlocalstorageに保存する
      @save_token = !!params[:loggedin]
    end

    def navigation
      @navigation = {articles: true}
    end
  end
end
