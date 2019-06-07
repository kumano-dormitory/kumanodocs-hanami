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

    def during_meeting?(meeting: MeetingRepository.new.find_most_recent, now: Time.now)
      if meeting&.date then
        date = meeting.date
        start_at = Time.new(date.year, date.mon, date.day, 21,45,0,"+09:00")
        end_at = Time.new(date.year, date.mon, date.day, 12,0,0,"+09:00") + (60 * 60 * 24)
        now.between?(start_at, end_at)
      else
        false
      end
    end
  end
end
