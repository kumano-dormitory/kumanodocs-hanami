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
      
      when "ryoseisyukai" then # 寮生集会資料
        if FileTest.exist?("/shiryo/ryoseisyukai.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_経緯まとめ.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai.pdf"
        end
      when "ryoseisyukai2" then # 寮生集会資料
        if FileTest.exist?("/app/ryoseisyukai2.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_論点まとめ.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai2.pdf"
        end
      when "ryoseisyukai3" then # 寮生集会資料
        if FileTest.exist?("/app/ryoseisyukai3.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_声明文案.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai3.pdf"
        end
      when "ryoseisyukai4" then # 寮生集会資料
        if FileTest.exist?("/app/ryoseisyukai4.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_ブロック会議への返答.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai4.pdf"
        end
      when "ryoseisyukai5" then # 寮生集会資料
        if FileTest.exist?("/app/ryoseisyukai5.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_出すべき派意見まとめ.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai5.pdf"
        end
      when "ryoseisyukai6" then # 寮生集会資料
        if FileTest.exist?("/app/ryoseisyukai6.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_出すべきでない派意見まとめ.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai6.pdf"
        end
      when "ryoseisyukai7" then # 寮生集会資料
        if FileTest.exist?("/app/ryoseisyukai7.pdf")
          encoded_filename = URI.encode_www_form_component("20210709寮生集会_B210阿津(出すべきでない派)意見.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseisyukai7.pdf"
        end

      when "shuchi_guide" then #周知さんの説明
        if FileTest.exist?("/app/others/shuchi.mp4")
          encoded_filename = URI.encode_www_form_component("shuchi.mp4")
          self.format = :mp4
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/others/shuchi.mp4"
        end
      when "ryoseitaikai" then # 寮生大会資料
        if FileTest.exist?("/app/shiryo/ryoseitaikai.pdf")
          encoded_filename = URI.encode_www_form_component("20221217寮生大会議案書.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/shiryo/ryoseitaikai.pdf"
        end
      when "ryoseitaikai2" then #寮生大会資料
        if FileTest.exist?("/app/shiryo/ryoseitaikai2.pdf")
          encoded_filename = URI.encode_www_form_component("大学改革アピール.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/shiryo/ryoseitaikai2.pdf"
        end
      when "ryoseitaikai3" then #変更点まとめ
        if FileTest.exist?("/app/shiryo/ryoseitaikai3.pdf")
          encoded_filename = URI.encode_www_form_component("論文謝辞アピール.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/shiryo/ryoseitaikai3.pdf"
        end
      when "ryoseitaikai4" then # 返答まとめ
        if FileTest.exist?("/app/shiryo/ryoseitaikai4.pdf")
          encoded_filename = URI.encode_www_form_component("週刊　工学部自治会を作る.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/shiryo/ryoseitaikai4.pdf"
        end
      when "ryoseitaikai5" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai5.pdf")
          encoded_filename = URI.encode_www_form_component("中銀破綻PT.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai5.pdf"
        end
      when "ryoseitaikai6" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai6.pdf")
          encoded_filename = URI.encode_www_form_component("モノを大事にしよう.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai6.pdf"
        end
      when "ryoseitaikai7" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai7.pdf")
          encoded_filename = URI.encode_www_form_component("SNS（インターネット）のつかいかた.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai7.pdf"
        end
      when "ryoseitaikai8" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai8.pdf")
          encoded_filename = URI.encode_www_form_component("学術連帯局.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai8.pdf"
        end
      when "ryoseitaikai9" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai9.pdf")
          encoded_filename = URI.encode_www_form_component("居住理由判定会議.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai9.pdf"
        end
      when "ryoseitaikai10" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai10.pdf")
          encoded_filename = URI.encode_www_form_component("寮外連携局.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai10.pdf"
        end
      when "ryoseitaikai11" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai11.pdf")
          encoded_filename = URI.encode_www_form_component("寮内の補充・補修について.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai11.pdf"
        end
      when "ryoseitaikai12" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai12.pdf")
          encoded_filename = URI.encode_www_form_component("突入報告ビラ.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai12.pdf"
        end
      when "ryoseitaikai13" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai13.pdf")
          encoded_filename = URI.encode_www_form_component("強制執行阻止！ 三里塚に行こう.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai13.pdf"
        end
      when "ryoseitaikai14" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai14.pdf")
          encoded_filename = URI.encode_www_form_component("1212月19日窓口交渉！！.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai14.pdf"
        end
      when "ryoseitaikai15" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai15.pdf")
          encoded_filename = URI.encode_www_form_component("中銀破綻論.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai15.pdf"
        end
      when "ryoseitaikai16" then # 自由討論
        if FileTest.exist?("/app/ryoseitaikai16.pdf")
          encoded_filename = URI.encode_www_form_component("自由討論「現状の把握と対話による調和へ」参考資料.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryoseitaikai16.pdf"
        end
      when "ryoseitaikaigiji" then #寮生大会臨時議事録
        if FileTest.exist?("/app/giji/ryoseitaikaigiji.html")
          encoded_filename = URI.encode_www_form_component("ryoseitaikaigiji.html")
          self.format = :html
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/giji/ryoseitaikaigiji.html"
        end

      when "daigi0" then # 代議員会の手引き
        if FileTest.exist?("/app/daigi0.pdf")
          encoded_filename = URI.encode_www_form_component("代議員会の手引き.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/daigi0.pdf"
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
      when "ryosai2022" then # 2022年度熊野寮祭実行委員会総括
        if FileTest.exist?("/app/ryosai2022.pdf")
          encoded_filename = URI.encode_www_form_component("2022年度熊野寮祭実行委員会総括.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryosai2022.pdf"
        end
      when "ryosai2022-change" then # 2022年度熊野寮祭実行委員会総括 前回の議事録への返答
        if FileTest.exist?("/app/ryosai2022-change.pdf")
          encoded_filename = URI.encode_www_form_component("2022年度熊野寮祭実行委員会総括_前回の議事録への返答.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryosai2022-change.pdf"
        end
      when "ryosai2022-events" then # 2022年度熊野寮祭企画総括
        if FileTest.exist?("/app/ryosai2022-events.pdf")
          encoded_filename = URI.encode_www_form_component("2022年度熊野寮祭企画総括.pdf")
          self.format = :pdf
          self.headers.merge!({'Content-Disposition' => "inline; filename*=UTF-8''#{encoded_filename}"})
          unsafe_send_file "/app/ryosai2022-events.pdf"
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
