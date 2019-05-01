module Admin::Controllers::Meeting
  class Download
    include Admin::Action
    expose :tex_str

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_articles(params[:id])
      @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
      @tex_str = Admin::Views::Meeting::Download.render(format: :tex, meeting: @meeting, articles: @articles)
      # write_file(temp, @tex)
      # run_command(ptex2pdf -u -l, temp)
      # self.format = :pdf
      # unsafe_send_file Pathname.new("/path/to/pdf")
      self.format = :txt
    end
  end
end
