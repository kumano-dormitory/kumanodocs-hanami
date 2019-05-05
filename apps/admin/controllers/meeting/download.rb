module Admin::Controllers::Meeting
  class Download
    include Admin::Action
    expose :meetings, :meeting, :tex_str, :view_type

    params do
      required(:id) { filled? & int? & gt?(0) }
      optional(:articles).filled(:bool?)
      optional(:comments).filled(:bool?)
    end

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new,
                   block_repo: BlockRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @block_repo = block_repo
    end

    def call(params)
      if params.valid?
        @meeting = @meeting_repo.find_with_articles(params[:id])
        if params[:articles]
          @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
          @tex_str = Admin::Views::Meeting::Download.render(format: :tex, meeting: @meeting, articles: @articles, type: :articles)
          # write_file(temp, @tex)
          # run_command(ptex2pdf -u -l, temp)
          # self.format = :pdf
          # unsafe_send_file Pathname.new("/path/to/pdf")
          self.format = :txt
        elsif params[:comments]
          @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
          @blocks = @block_repo.all
          @tex_str = Admin::Views::Meeting::Download.render(format: :tex, meeting: @meeting, articles: @articles, blocks: @blocks, type: :comments)
          # write_file(temp, @tex)
          # run_command(ptex2pdf -u -l, temp)
          # self.format = :pdf
          # unsafe_send_file Pathname.new("/path/to/pdf")
          self.format = :txt
        else
          @view_type = :meeting
        end
      else
        @meetings = @meeting_repo.desc_by_date(limit: 20)
        @view_type = :meetings
      end
    end

    def navigation
      @navigation = {pdf: true}
    end
  end
end
