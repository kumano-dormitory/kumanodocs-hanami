# ====
# 資料システム一般向けページのルーティング
# ====

root to: 'article#top'
# ドキュメント表示
get '/article/doc', to: 'article#doc', as: :document
# 議案検索
get '/article/search', to: 'article#search', as: :search_article
# 議案差分
get '/article/diff', to: 'article#diff', as: :diff_article
# トップページ (root)
get '/article/top', to: 'article#top'
# 議案のPDFプレビュー
get '/article/:id/pdf', to: 'article#pdf'
# 議案の表示・操作
resources :article do
  # 議案編集時のロック操作
  resource :lock, only: [:new, :create]
end
# ブロック会議日程の表示
resources :meeting, only: [:index, :show]
# 表の操作
resources :table, only: [:new, :create, :edit, :update, :destroy]
# ログイン操作
resource :login, only: [:show, :create]

# 寮生集会・大会の議事録表示・編集
get '/gijiroku/content', to: 'gijiroku#content', as: :content_gijiroku
get '/gijiroku/list', to: 'gijiroku#list', as: :list_gijiroku
get '/gijiroku/:id/delete', to: 'gijiroku#destroy', as: :destroy_gijiroku
resources :gijiroku, only: [:index, :show, :new, :create, :edit, :update]
# ブロック会議の議事録投稿
get '/meeting/:meeting_id/block/:block_id/comment/edit', to: 'comment#edit', as: :edit_comment
patch '/meeting/:meeting_id/block/:block_id/comment/', to: 'comment#update', as: :comments
# ブロック会議議事録の投稿ページへのリンク（モバイル端末向け）
get '/meeting/:meeting_id/comment', to: 'comment#index', as: :select_block_comments
# 表の編集のロック操作
get '/article/:article_id/table/:table_id/lock/new', to: 'article/lock#new', as: :new_article_lock_for_table
post '/article/:article_id/table/:table_id/lock', to: 'article/lock#create', as: :article_lock_for_table
# ブロック会議資料PDFのダウンロード（一般向け）
get '/meeting/:id/download', to: 'meeting#download', as: :download_meeting

# ブロック会議議事録まとめ
get '/comment/summary', to: 'comment#summary', as: :summary_comment
# 議事録チャット操作
get '/comment/:comment_id/message/new', to: 'comment/message#new', as: :new_comment_message
post '/comment/:comment_id/message', to: 'comment/message#create', as: :comment_messages
delete '/comment/message/:id', to: 'comment/message#destroy', as: :comment_message

# Error page（エラーページの表示確認用）
get '/error/:id', to: 'error#show', as: :error
# About Kumano-Dormitory Document System
get '/about', to: 'funny#about', as: :about
# 資料ダウンロード（寮生大会や代議員会の資料PDFのダウンロードリンク）
get '/docs/download/:id', to: 'docs#download', as: :download_documents
get '/docs', to: 'docs#index', as: :documents
get '/docs/new', to: 'docs#new', as: :new_document
get '/docs/:id', to: 'docs#show', as: :document
get '/docs/:id/edit', to: 'docs#edit', as: :edit_document
post '/docs', to: 'docs#create', as: :documents
patch '/docs/:id', to: 'docs#update', as: :document
delete '/docs/:id', to: 'docs#destroy', as: :document

# 部会委員会の資料編集のためのログイン
get '/docs/login/new', to: 'docs/login#new', as: :new_login_docs
post '/docs/login', to: 'docs/login#create', as: :login_docs
