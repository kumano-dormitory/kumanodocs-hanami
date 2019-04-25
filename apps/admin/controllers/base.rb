module Admin
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
  end
end
