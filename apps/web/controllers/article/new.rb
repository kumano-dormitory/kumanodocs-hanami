module Web::Controllers::Article
  class New
    include Web::Action
    expose :meetings, :next_meeting, :categories, :recent_articles

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   category_repo: CategoryRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @category_repo = category_repo
      @notifications = {}
    end

    def call(_params)
      @categories = @category_repo.all
      @recent_articles = @article_repo.of_recent(months: 3, past_meeting_only: false, with_relations: true)
      if after_deadline?
        # 追加議案の投稿受理期間
        @meetings = [@meeting_repo.find_most_recent]
        @notifications = {caution: {status: "注意：", message: "現在は追加議案の投稿時間です. この議案は資料委員会にはチェックされず、ブロック会議当日まで編集することができます. もし通常議案として投稿できなかった正当な理由がある場合は、資料委員会に相談してください."}}
      else
        # すべての議案の投稿受理期間
        @meetings = @meeting_repo.in_time
        @next_meeting = @meeting_repo.find_most_recent
      end
    end

    def navigation
      @navigation = {new_article: true}
    end

    def notifications
      @notifications
    end
  end
end
