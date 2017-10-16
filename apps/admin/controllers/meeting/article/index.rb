module Admin::Controllers::Meeting
  module Article
    class Index
      include Admin::Action

      def initialize(article_repo: ArticleRepository.new)
        @article_repo = article_repo
      end
      
      def call(params)
      end
    end
  end
end
