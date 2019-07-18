module Specifications
  class Pdf
    attr_reader :type, :meeting_id, :after_6pm

    def initialize(type: :web_articles,
                   meeting_id: 1,
                   after_6pm: false)
      @type = type
      @meeting_id = meeting_id
      @after_6pm = after_6pm
    end

    def ==(other)
      self.eql?(other)
    end

    def eql?(other)
      @type == other.type && @meeting_id == other.meeting_id && @after_6pm == other.after_6pm
    end
  end
end
