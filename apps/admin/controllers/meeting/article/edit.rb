module Admin::Controllers::Meeting
  module Article
    class Edit
      include Admin::Action
      expose :meetings, :categories, :article, :recent_articles, :article_refs_selected

      def initialize(article_repo: ArticleRepository.new,
                     meeting_repo: MeetingRepository.new,
                     category_repo: CategoryRepository.new,
                     article_reference_repo: ArticleReferenceRepository.new,
                     authenticator: AdminAuthenticator.new)
        @article_repo = article_repo
        @meeting_repo = meeting_repo
        @category_repo = category_repo
        @article_reference_repo = article_reference_repo
        @authenticator = authenticator
      end

      def call(params)
        @meetings = @meeting_repo.desc_by_date
        @categories = @category_repo.all
        @article = @article_repo.find_with_relations(params[:id])
        @recent_articles = @article_repo.of_recent(months: 6, past_meeting_only: false, with_relations: true)
        @article_refs_selected = @article_reference_repo.find_refs(@article.id, with_relations: false)
          .group_by{|ref| ref.same}.map{ |same,refs|
              { (same ? :same : :other) =>
                refs.map{|ref| (ref.article_old_id == @article.id ? ref.article_new_id : ref.article_old_id)} }
          }.inject(:merge)
      end
    end
  end
end
