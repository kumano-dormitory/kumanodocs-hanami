# =====
# Base Controller for Web app actions (一般向けページ)
# =====
# 一般向けページの全てのアクションに共通する処理を実装.
# apps/web/application.rb に、このモジュールを含める設定が記述されている
#
# = 機能
# - notifications(画面上部に表示するメッセージ)がflashに保存されている場合に取り出し、公開する処理
# - 直近のブロック会議の締め切りを過ぎているかを判定する共通メソッド after_deadline?
# - 直近のブロック会議の開催中かを判定する共通メソッド during_meeting?

module Web
  module BaseController
    def self.included(action)
      action.class_eval do
        expose :navigation, :notifications
      end
    end

    def navigation
      @navigation = {}
    end

    def notifications
      if flash[:notifications]
        @notifications = flash[:notifications].map { |key,val|
          new_val = val.map{ |k,v| [k.to_sym, v] }.to_h
          [key.to_sym, new_val]
        }.to_h
        flash.clear
      else
        @notifications = {}
      end
      @notifications
    end

    # 直近のブロック会議の締め切り後かどうかを返す 締め切り〜会議開始までならばtrue
    def after_deadline?(now: Time.now)
      recent_meeting = MeetingRepository.new.find_most_recent
      return false unless recent_meeting
      now.between?(recent_meeting.deadline, recent_meeting.date.to_time + (60 * 60 * 22))
    end

    # 直近のブロック会議の開催中かを判定する. 当日の21:45 ~ 翌日の間ならばtrue
    def during_meeting?(meeting: MeetingRepository.new.find_most_recent, now: Time.now)
      if meeting&.date then
        date = meeting.date
        start_at = Time.new(date.year, date.mon, date.day, 21,45,0,"+09:00")
        end_at = Time.new(date.year, date.mon, date.day, 23,59,59,"+09:00") + (60 * 60 * 24)
        now.between?(start_at, end_at)
      else
        false
      end
    end
  end
end
