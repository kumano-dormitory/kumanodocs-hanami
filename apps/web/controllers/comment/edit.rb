# ====
# 議事録の投稿画面表示アクション
# ====
# ブロック会議議事録の投稿画面を表示する
# = 主な処理
# - 既に議事録が投稿されている場合には、投稿済みの議事録を入力フォームに含める

module Web::Controllers::Comment
  class Edit
    include Web::Action
    expose :meeting, :block_id, :comment_datas, :vote_result_datas

    def initialize(meeting_repo: MeetingRepository.new,
                   comment_repo: CommentRepository.new,
                   vote_result_repo: VoteResultRepository.new,
                   authenticator: JwtAuthenticator.new)
      @meeting_repo = meeting_repo
      @comment_repo = comment_repo
      @vote_result_repo = vote_result_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:meeting_id])
      @block_id = params[:block_id]
      @comment_datas = @meeting.articles.map do |article|
        comment = @comment_repo.find(article.id, params[:block_id])
        { article_id: article.id, comment: comment&.body }
      end
      @vote_result_datas = @meeting.articles.map do |article|
        if article.categories.find_index { |category| category.require_content && category.name == '採決' }
          data = @vote_result_repo.find(article.id, params[:block_id])
          { article_id: article.id, vote_result: data&.to_h }
        else
          { article_id: article.id, vote_result: nil }
        end
      end

      # 議事録の編集が可能な時間か判定
      if !during_meeting?(meeting: @meeting)
        @notifications = {caution: {status: "注意:", message: "ブロック会議の開催中ではないため、議事録を投稿できない可能性があります"}}
      end
    end

    def notifications
      @notifications
    end
  end
end
