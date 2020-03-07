module Web::Controllers::Docs
  class Update
    include Web::Action
    expose :document

    params do
      required(:id).filled(:int?)
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
      redirect_to routes.new_login_docs_path unless session[:user_id]

      user = @user_repo.find(session[:user_id])
      document = @document_repo.find(params[:id])
      if !user.nil? && user.authority == 1 && user.id == document&.user_id
        if params.valid?
          props = {title: params[:document][:title], type: params[:document][:type], body: params[:document][:body]}
          @document_repo.update(document.id, props)
          redirect_to routes.editor_menu_documents_path
        else
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
        redirect_to routes.new_login_docs_path
      end
    end

    def notifications
      @notifications
    end
  end
end
