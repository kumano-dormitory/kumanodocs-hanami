# ====
# 寮生大会資料PDF等ダウンロードアクション
# ====
# 寮生大会資料などのPDFを転送する
# パラメータとしてidを受け取り、資料の種類を判別する

module Web::Controllers::Docs
  class Download
    include Web::Action

    def initialize(document_repo: DocumentRepository.new,
                   authenticator: JwtAuthenticator.new)
      @document_repo = document_repo
      @authenticator = authenticator
    end

    def call(params)
      case params[:id]
      when "ryoseitaikai" then # 寮生大会資料
        if FileTest.exist?("/app/ryoseitaikai.pdf")
          encoded_filename = URI.encode_www_form_component("寮生大会議案書.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai.pdf"
        end
      when "ryoseitaikai2" then #変更・返答まとめ
        if FileTest.exist?("/app/ryoseitaikai2.pdf")
          encoded_filename = URI.encode_www_form_component("代議員会からの変更点.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai2.pdf"
        end
      when "ryoseitaikai3" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai3.pdf")
          encoded_filename = URI.encode_www_form_component("自由討論資料1.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai3.pdf"
        end
      when "ryoseitaikai4" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai4.pdf")
          encoded_filename = URI.encode_www_form_component("自由討論資料2.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai4.pdf"
        end
      when "daigi1" then # 代議員会資料
        if FileTest.exist?("/app/daigi1.pdf")
          encoded_filename = URI.encode_www_form_component("代議員会資料.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/daigi1.pdf"
        end
      when "daigi2" then # 代議員会用変更点・返答まとめ
        if FileTest.exist?("/app/daigi2.pdf")
          encoded_filename = URI.encode_www_form_component("返答変更点まとめ.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/daigi2.pdf"
        end
      else
        # 部会・委員会の資料
        document = @document_repo.find(params[:id])
        if FileTest.exist?("./docs/id#{document.id}/#{document.body}")
          encoded_filename = URI.encode_www_form_component("#{document.title}.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename=\"kumano_ryo_document_#{document.id}.pdf\"; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "./docs/id#{document.id}/#{document.body}"
        end
      end
      # Display "In preparation"
    end
  end
end
