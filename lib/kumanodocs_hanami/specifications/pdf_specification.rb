# ====
# PDFの仕様
# ====
# PDF生成サービス(lib/kumanodocs_hanami/interactors/generate_pdf.rb)へと引数として渡す仕様
# このクラスのインスタンスで指定される仕様に従ってPDFが生成される.
# = 主なインスタンス変数の説明
# - type
#     生成されるPDFの種別を表す. デフォルトは :web_articles (一般向けブロック会議資料PDF)
#     その他の種別については generate_pdf.rb を参照.
# - meeting_id
#     ブロック会議資料のPDFの場合に、ブロック会議をidで指定
# - after_6pm
#     資料委員会向けのPDF出力時に本番用のPDFを生成するか、資料委員会用のPDFを出力するか指定
# - article_id
#     ある議案のみを含むPDFを生成する場合に、議案をidで指定
# - data
#     その他のデータ. (現在は表のPDFを生成する場合に表のデータを指定するために使用)

module Specifications
  class Pdf
    attr_reader :type, :meeting_id, :after_6pm, :article_id, :data

    def initialize(type: :web_articles,
                   meeting_id: 1,
                   after_6pm: false,
                   article_id: 0,
                   data: {})
      @type = type
      @meeting_id = meeting_id
      @after_6pm = after_6pm
      @article_id = article_id
      @data = data
    end

    def ==(other)
      self.eql?(other)
    end

    def eql?(other)
      @type == other.type && @meeting_id == other.meeting_id && @after_6pm == other.after_6pm && @article_id == other.article_id
    end
  end
end
