module Admin::Controllers::Meeting
  module Article
    class Show
      include Admin::Action
      expose :article, :blocks, :messages, :article_refs

      def initialize(article_repo: ArticleRepository.new,
                     block_repo: BlockRepository.new,
                     message_repo: MessageRepository.new,
                     article_reference_repo: ArticleReferenceRepository.new,
                     authenticator: AdminAuthenticator.new)
        @article_repo = article_repo
        @block_repo = block_repo
        @message_repo = message_repo
        @article_reference_repo = article_reference_repo
        @authenticator = authenticator
      end

      def call(params)
        @article = @article_repo.find_with_relations(params[:id])
        @blocks = @block_repo.all
        @messages = @message_repo.by_article(@article.id).group_by{|message| message.comment_id}
        @article_refs = @article_reference_repo.find_refs(@article.id)
      end
    end
  end
end
