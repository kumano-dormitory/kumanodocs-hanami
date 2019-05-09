require 'hanami/validations'

module Admin::Controllers::ArticleNumber
  class Update
    include Admin::Action
    expose :meeting, :for_download

    params Class.new(Hanami::Action::Params) {
      predicate(:int_values?, message: 'is not int values'){ |current|
        !current['number'].nil? && !current['article_id'].nil? &&
          current['number'].match(/\d+|/) && current['article_id'].match(/\d+|/)
      }
      predicate(:unique_array?, message: 'is not unique'){ |current|
        return false unless current.instance_of?(Array)

        numbers = current.map{ |item|
          if item['number'].nil? || item['number'].eql?("")
            0
          else
            item['number'].to_i
          end
        }.select{ |item| item.positive? } # select greater than 0
        max = numbers.count
        numbers.sort == (1..max).to_a
      }

      validations do
        required(:meeting).schema do
          required(:articles) { unique_array? { each { int_values? }}}
        end
        required(:id).filled(:int?)
        optional(:download).filled(:bool?)
      end
    }

    def initialize(meeting_repo: MeetingRepository.new,
                   article_repo: ArticleRepository.new)
      @meeting_repo = meeting_repo
      @article_repo = article_repo
      @notifications = {}
    end

    def call(params)
      if params.valid?
        articles_number = params[:meeting][:articles]
        # 空の値をnilに変換する
        articles_number.each do |item|
          if item['number'] == ""
            item['number'] = nil
          end
        end

        @article_repo.update_number(params[:id], articles_number)

        if params[:download]
          # 印刷用PDFダウンロードページからの遷移
          redirect_to (routes.download_meeting_path(id: params[:id]) + "?articles=true")
        else
          # 議案順序の変更のみ
          flash[:notifications] = {success: {status: "Success:", message: "正常に議案順序が保存されました"}}
          redirect_to routes.meeting_path(id: params[:id])
        end
      else
        @for_download = params[:download] || false
        @meeting = @meeting_repo.find_with_articles(params[:id])
        @notifications = {error: {status: "Error:", message: "指定された順序に不備があります. もう一度確認してください"}}
        self.status = 422
      end
    end

    def notifications
      @notifications
    end

    def navigation
      @navigation = {pdf: @for_download}
    end
  end
end
