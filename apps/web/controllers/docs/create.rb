module Web::Controllers::Docs
  class Create
    include Web::Action
    expose :user

    params do
      required(:document).schema do
        required(:title).filled(:str?)
        required(:user_id).filled(:str?)
        required(:type) { filled? & int? & gteq?(0) & lt?(3) }
        required(:body).filled(:str?)
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
      @user = @user_repo.find(session[:user_id])
      if !@user.nil? && @user.authority == 1
        if params.valid?
          props = {
            title: params[:document][:title],
            user_id: @user.id,
            type: params[:document][:type],
            body: params[:document][:body]
          }
          document = @document_repo.create(props)
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
