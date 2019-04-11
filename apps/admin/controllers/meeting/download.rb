module Admin::Controllers::Meeting
  class Download
    include Admin::Action
    expose :meeting, :tex

    def initialize(meeting_repo: MeetingRepository.new)
      @meeting_repo = meeting_repo
    end

    def call(params)
      @meeting = @meeting_repo.find_with_printed_articles(params[:id])
      @tex = @meeting.to_tex
      # write_file(temp, @tex)
      # run_command(ptex2pdf -u -l, temp)
      # self.format = :pdf
      # unsafe_send_file Pathname.new("/path/to/pdf")
      self.format = :txt
    end
  end
end
