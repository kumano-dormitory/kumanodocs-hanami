module Web::Controllers::Docs
  class Create
    include Web::Action
    expose :user

    params do
      required(:document).schema do
        required(:title).filled(:str?)
        required(:user_id).filled(:str?)
        required(:type) { filled? & int? & gteq?(0) & lt?(3) }
        optional(:body).maybe(:str?)
        optional(:data) { filled? }
        optional(:url).maybe(:str?)
      end
    end

    def initialize(document_repo: DocumentRepository.new,
                   user_repo: UserRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @user_repo = user_repo
      @authenticator = authenticator
      @notifications = {}
    end

    def call(params)
      redirect_to routes.new_login_docs_path unless session[:user_id]

      @user = @user_repo.find(session[:user_id])
      if !@user.nil? && @user.authority == 1
        if params.valid?
          case params[:document][:type]
          when 0 then
            props = {
              title: params[:document][:title],
              user_id: @user.id,
              type: params[:document][:type],
              body: params[:document][:body]
            }
            document = @document_repo.create(props)
          when 1 then
            props = {
              title: params[:document][:title],
              user_id: @user.id,
              type: params[:document][:type],
              body: params[:document][:data][:filename]
            }
            document = @document_repo.create(props)

            folder_path = "./docs/id#{document.id}/"
            FileUtils.mkdir_p(folder_path) unless FileTest.exist?(folder_path)
            FileUtils.mv(params[:document][:data][:tempfile], "#{folder_path}#{params[:document][:data][:filename]}")
          when 2 then
            props = {
              title: params[:document][:title],
              user_id: @user.id,
              type: params[:document][:type],
              body: params[:document][:url]
            }
            document = @document_repo.create(props)
          else
            halt 422
          end
          redirect_to routes.document_path(document.id)
        else
          @notifications = {error: {status: "Error:", message: "入力された項目に不備があり新規追加できません. もう一度確認してください"}}
        end
      else
        redirect_to routes.new_login_docs_path
      end
    end

    def notifications
      @notifications
    end
  end
end
