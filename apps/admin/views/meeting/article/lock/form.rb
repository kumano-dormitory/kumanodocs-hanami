module Admin::Views::Meeting::Article::Lock
  module Form
    def form
      form_for :author, routes.meeting_article_lock_path(meeting_id: params[:meeting_id], article_id: params[:article_id]) do
        password_field :password

        submit '編集開始'
      end
    end
  end
end
