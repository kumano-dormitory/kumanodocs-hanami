module Admin::Controllers::Docs
  class Update
    include Admin::Action
    expose :document

    params do
      required(:id).filled(:int?)
      required(:document).schema do
        required(:title).filled(:str?)
        required(:user_id).filled(:str?)
        required(:type) { filled? & int? & gteq?(0) & lt?(3) }
        optional(:body).maybe(:str?)
        optional(:data) { none? | filled? }
        optional(:url).maybe(:str?)
      end
    end

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: AdminAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      document = @document_repo.find_with_relations(params[:id])
      user = document.user
      if !user.nil? && user.authority == 1
        if params.valid?
          props = {
            title: params[:document][:title],
            type: params[:document][:type]
          }
          case params[:document][:type]
          when 0 then
            props.merge!({body: params[:document][:body]})
          when 1 then
            props.merge!({body: params[:document][:data][:filename]})
            folder_path = "./docs/id#{document.id}/"
            FileUtils.mkdir_p(folder_path) unless FileTest.exist?(folder_path)
            FileUtils.mv(params[:document][:data][:tempfile], "#{folder_path}#{params[:document][:data][:filename]}")
          when 2 then
            props.merge!({body: params[:document][:url]})
          else
            halt 422
          end
          @document_repo.update(document.id, props)
          redirect_to routes.doc_path(id: document.id)
        else
          self.status = 422
          @notifications = {error: {status: "Error:", message: "入力された項目に不備があり保存できません. もう一度確認してください"}}
          @document = Document.new(
            id: params[:id],
            title: params[:document][:title],
            user: user,
            user_id: user.id,
            type: params[:document][:type],
            body: params[:document][:body]
          )
        end
      else
        redirect_to routes.docs_path
      end
    end

    def notifications
      @notifications
    end
  end
end
