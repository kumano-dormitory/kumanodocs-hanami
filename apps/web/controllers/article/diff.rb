module Web::Controllers::Article
  class Diff
    include Web::Action
    expose :article_old, :article_new, :recent_meetings_with_articles

    params do
      required(:diff).schema do
        required(:old_article).filled(:int?)
        required(:new_article).filled(:int?)
      end
    end

    def initialize(article_repo: ArticleRepository.new)
      @article_repo = article_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        @article_old = @article_repo.find_with_relations(params[:diff][:old_article])
        @article_new = @article_repo.find_with_relations(params[:diff][:new_article])
        self.headers.merge!({
          'Content-Security-Policy' => "form-action 'self'; frame-ancestors 'self'; base-uri 'self'; default-src 'none'; manifest-src 'self'; script-src 'self' https://cdnjs.cloudflare.com/ajax/libs/jsdiff/ https://cdnjs.cloudflare.com/ajax/libs/diff2html/; connect-src 'self'; img-src 'self' https: data:; style-src 'self' 'unsafe-inline' https:; font-src 'self'; object-src 'none'; plugin-types application/pdf; child-src 'self'; frame-src 'self'; media-src 'self'"
        })
      else
        @notifications = {caution: {status: '注意:', message: '議案を2つ選択してください'}}
        @recent_meetings_with_articles = @article_repo.group_by_meeting(16, months: 6)
      end
    end

    def notifications
      @notifications
    end
  end
end
