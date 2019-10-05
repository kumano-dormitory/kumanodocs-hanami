module Super::Controllers::Db
  class Run
    include Super::Action

    def call(params)
      command = params[:cmd]
      if command[-1] ==  "\n"
        command = command[0..-2]
      end
      begin
        result = PG::connect(ENV['DATABASE_URL']).exec(command)
        header = result.first.keys.reduce{|str, x| "#{str}  |  #{x}"}
        output = result.map{|item| item.values.reduce{|str, x| "#{str} | #{x}"} + "\n" }.join

        self.body = escape_html "\n#{command}\n-----------------------\n  #{header}\n#{output}"
        self.status = 200
      rescue => e
        self.body = escape_html "#{command}\n#{e.message}"
        self.status = 200
      end
    end
  end
end
