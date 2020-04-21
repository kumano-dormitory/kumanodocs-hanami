module Admin::Controllers::Docs
  class UpdateOrder
    include Admin::Action
    expose :documents

    params Class.new(Hanami::Action::Params) {
      predicate(:int_values?, message: 'is not int values'){ |current|
        !current['number'].nil? && !current['document_id'].nil? &&
          current['number'].match(/\d+|/) && current['document_id'].match(/\d+|/)
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
        required(:document).schema do
          required(:order) { unique_array? { each { int_values? }}}
        end
      end
    }

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: AdminAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      if params.valid?
        docs_order = params[:document][:order]
        docs_order.each do |i|
          if i['number'] == ""
            i['number'] = nil
          end
        end

        @document_repo.update_number(docs_order)
        redirect_to routes.docs_path
      else
        @documents = @document_repo.order_by_number
        @notifications = {error: {status: "Error:", message: "指定された順序に不備があります. もう一度確認してください"}}
        self.status = 422
        self.headers.merge!({
          'Content-Security-Policy' => "form-action 'self'; frame-ancestors 'self'; base-uri 'self'; default-src 'none'; manifest-src 'self'; script-src 'self' https://ajax.googleapis.com/ajax/libs/jquery/ https://ajax.googleapis.com/ajax/libs/jqueryui/; connect-src 'self'; img-src 'self' https: data:; style-src 'self' 'unsafe-inline' https:; font-src 'self'; object-src 'none'; plugin-types application/pdf; child-src 'self'; frame-src 'self'; media-src 'self'"
        })
      end
    end

    def notifications
      @notifications
    end
  end
end
