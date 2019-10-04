module Super::Controllers::Log
  class Index
    include Super::Action
    expose :logs, :font_size

    def call(params)
      n = 100
      length = params[:length].to_i
      if 0 < length && length < 6
        n = 100 * length
      end
      open(ENV['LOG_PATH']) do |io|
        @logs = io.reverse_each.lazy.first(n).reverse
      end
      @font_size = (params[:fontSize].to_i == 0) ? 12 : params[:fontSize].to_i

      if params[:raw]
        self.body = logs.reduce{|ret, line| ret + line}
        self.status = 200
      end
    end
  end
end
