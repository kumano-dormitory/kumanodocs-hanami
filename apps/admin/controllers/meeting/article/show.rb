module Admin::Controllers::Meeting
  module Article
    class Show
      include Admin::Action
      expose :article, :blocks, :messages

      def initialize(article_repo: ArticleRepository.new,
                     block_repo: BlockRepository.new,
                     message_repo: MessageRepository.new)
        @article_repo = article_repo
        @block_repo = block_repo
        @message_repo = message_repo
      end

      def call(params)
        @article = @article_repo.find_with_relations(params[:id])
        @blocks = @block_repo.all
        @messages = @message_repo.by_article(@article.id).group_by{|message| message.comment_id}
      end
    end
  end
end
