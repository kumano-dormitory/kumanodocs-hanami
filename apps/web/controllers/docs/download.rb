module Web::Controllers::Docs
  class Download
    include Web::Action

    def initialize(authenticator: JwtAuthenticator.new)
      @authenticator = authenticator
    end

    def call(params)
      case params[:id]
      when "0" then # 寮生大会資料
        if FileTest.exist?("/app/ryoseitaikai.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline"})
          unsafe_send_file "/app/ryoseitaikai.pdf"
        end
      when "1" then # 代議員会資料
        if FileTest.exist?("/app/daigi1.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline"})
          unsafe_send_file "/app/daigi1.pdf"
        end
      when "2" then # 代議員会用変更点・返答まとめ
        if FileTest.exist?("/app/daigi2.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline"})
          unsafe_send_file "/app/daigi2.pdf"
        end
      when "3" then #変更・返答まとめ
        if FileTest.exist?("/app/ryoseitaikai2.pdf")
          self.forat = :pdf
          self.headers.merge!({'Content-Disposition' => 'inline'})
          unsafe_send_file "/app/ryoseitaikai2.pdf"
        end
      end
      # Display "In preparation"
    end
  end
end
