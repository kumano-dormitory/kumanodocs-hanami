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
      now.between?(recent_meeting.deadline, recent_meeting.date.to_time + (60 * 60 * 22))
    end
  end
end
