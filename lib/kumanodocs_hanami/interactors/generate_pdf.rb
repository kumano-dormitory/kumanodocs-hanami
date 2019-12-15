# ====
# PDF生成サービス
# ====
# 資料システムで必要となる各種PDFを生成するサービス
# callメソッドで呼ばれ、引数として Specifications::Pdf のインスタンスを受け取る.
# = 主な処理
# - Specification::Pdfの情報に従ってPDFを生成
# - 生成したPDFはキャッシュし、再度生成する必要がない場合は生成を行わない
# - 生成したPDFへのパスを @pathに代入して制御を返す
# - PDFの生成に失敗したかの判断は failure? メソッドで判定できる
#
# = Latexのテンプレートについて
# テンプレートファイルの場所は以下の２箇所
# - apps/admin/templates/meeting/download.tex.erb
# - apps/web/templates/meeting/download.tex.erb
#
# = 生成するPDFの種類
# - specification.type == :admin_articles
#     ブロック会議資料の印刷用PDF. 資料委員会向け内部ページからダウンロードするPDF.
# - specification.type == :admin_comments
#     旧 ブロック会議報告会資料.（ブロック会議で出た議事録をすべてまとめたもの）
#     資料委員会向け内部ページからダウンロードするPDF
# - specification.type == :web_article_preview
#     一つの議案の印刷プレビュー用のPDF. 議案詳細画面でプレビューとして表示される.(議案投稿後に表示される画面)
#     議案投稿者が印刷したときの表示のされ方について確認を行う
# - specification.type == :table
#     一つの表のみを含むPDF. 表が正常にPDFとして出力されるかを確認するために生成.
#     表の投稿時に、正しく表が生成できるかを実際にその表のみを含むPDFを生成して確認を行う.
# - specification.type == :web_articles (上記以外の場合も含む)
#     ブロック会議資料のPDF. 一般向けページからダウンロードされるPDF/
#     資料委員会の印刷用PDFとの違いは余白が大きいことのみ.

require 'hanami/interactor'

class GeneratePdf
  include Hanami::Interactor
  expose :path

  def initialize(article_repo: ArticleRepository.new,
                 meeting_repo: MeetingRepository.new,
                 comment_repo: CommentRepository.new,
                 message_repo: MessageRepository.new,
                 block_repo: BlockRepository.new,
                 admin_history_repo: AdminHistoryRepository.new)
    @article_repo = article_repo
    @meeting_repo = meeting_repo
    @comment_repo = comment_repo
    @message_repo = message_repo
    @block_repo = block_repo
    @admin_history_repo = admin_history_repo
    @path = ""
  end

  def call(specification)

    if specification.type == :admin_articles
      @meeting = @meeting_repo.find(specification.meeting_id)
      @articles = @article_repo.for_download(@meeting, after_6pm: specification.after_6pm)
      past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
      @past_comments = @comment_repo.by_meeting(past_meeting.id)
                                    .group_by{|comment| comment[:article_id]}
      @past_messages = @message_repo.by_meeting(past_meeting.id)
                                    .group_by{|message| message[:comment_id]}
      # 出力する議案の印刷フラグをすべてtrueにする
      @article_repo.update_printed(@articles.map{ |article| { id: article.id, printed: true}})
      @admin_history_repo.add(:meeting_download,
        JSON.pretty_generate({action: "meeting_download", payload: {meeting: @meeting.to_h.merge({articles: @articles.map(&:id)})}})
      )
      # テンプレートファイルのパスは apps/admin/templates/meeting/download.tex.erb
      @tex_str = Admin::Views::Meeting::Download.render(
        format: :tex, meeting: @meeting, articles: @articles, past_comments: @past_comments, past_messages: @past_messages, type: :articles
      )
      digest = Digest::MD5.hexdigest(@tex_str)
      tmp_filename = "kumanodocs_meeting_#{@meeting.id}"
      tmp_folderpath = "/tmp/kumanodocs/meeting#{@meeting.id}/a#{digest}/"

      unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
        FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
        open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
          f.puts(@tex_str)
        end
        # 目次を正しく出力するために2回コンパイルを行う
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    elsif specification.type == :admin_comments
      @meeting = @meeting_repo.find_with_articles(specification.meeting_id)
      @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
      @blocks = @block_repo.all
      @tex_str = Admin::Views::Meeting::Download.render(format: :tex, meeting: @meeting, articles: @articles, blocks: @blocks, type: :comments)

      digest = Digest::MD5.hexdigest(@tex_str)
      tmp_filename = "kumanodocs_comments_#{@meeting.id}"
      tmp_folderpath = "/tmp/kumanodocs/comments#{@meeting.id}/a#{digest}/"

      unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
        FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
        open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
          f.puts(@tex_str)
        end
        # 目次を正しく出力するために２回コンパイルを行う
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    elsif specification.type == :web_article_preview
      @article = @article_repo.find_with_relations(specification.article_id)
      @tex_str = Admin::Views::Meeting::Download.render(format: :tex, article: @article, type: :article_preview)

      digest = Digest::MD5.hexdigest(@tex_str)
      tmp_filename = "kumanodocs_article_#{@article.id}"
      tmp_folderpath = "/tmp/kumanodocs/articles/article#{@article.id}/a#{digest}/"

      unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
        FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
        open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
          f.puts(@tex_str)
        end
        # PDFのコンパイル
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    elsif specification.type == :table
      @caption = specification.data[:caption]
      @table_data = CSV.parse(specification.data[:csv], col_sep: "\t")
      @tex_str = Admin::Views::Meeting::Download.render(format: :tex, table_data: @table_data, caption: @caption, type: :table)

      digest = Digest::MD5.hexdigest(@tex_str)
      tmp_filename = "kumanodocs_table_#{digest}"
      tmp_folderpath = "/tmp/kumanodocs/tables/"

      unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
        FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
        open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
          f.puts(@tex_str)
        end
        # PDFのコンパイル
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    else
      # option[:for] == :web_articles
      @meeting = @meeting_repo.find_with_articles(specification.meeting_id)

      @articles = @meeting.articles.map{ |article| @article_repo.find_with_relations(article.id) }
      past_meeting = @meeting_repo.find_past_meeting(@meeting.id)
      @past_comments = @comment_repo.by_meeting(past_meeting.id)
                                    .group_by{|comment| comment[:article_id]}
      @past_messages = @message_repo.by_meeting(past_meeting.id)
                                    .group_by{|message| message[:comment_id]}
      # テンプレートファイルのパスは apps/web/templates/meeting/download.tex.erb
      @tex_str = Web::Views::Meeting::Download.render(
        format: :tex, meeting: @meeting, articles: @articles, past_comments: @past_comments, past_messages: @past_messages
      )
      digest = Digest::MD5.hexdigest(@tex_str)
      tmp_filename = "kumanodocs_meeting_#{@meeting.id}"
      tmp_folderpath = "/tmp/kumanodocs/meeting#{@meeting.id}/a#{digest}/"

      unless FileTest.exist?("#{tmp_folderpath}#{tmp_filename}.pdf")
        FileUtils.mkdir_p(tmp_folderpath) unless FileTest.exist?(tmp_folderpath)
        open("#{tmp_folderpath}#{tmp_filename}.tex", "w") do |f|
          f.puts(@tex_str)
        end
        # 目次を正しく出力するために２回コンパイルを行う
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == nil || $? == 0 }
        error! 'latex err' unless IO.popen("ptex2pdf -u -l -output-directory #{tmp_folderpath} #{tmp_folderpath}#{tmp_filename}.tex") { |io| $? == 0 }
      end
      @path = "#{tmp_folderpath}#{tmp_filename}.pdf"
    end
  end
end
