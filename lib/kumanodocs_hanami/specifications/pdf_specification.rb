module Specifications
  class Pdf
    attr_reader :type, :meeting_id, :after_6pm, :article_id, :data

    def initialize(type: :web_articles,
                   meeting_id: 1,
                   after_6pm: false,
                   article_id: 0,
                   data: {})
      @type = type
      @meeting_id = meeting_id
      @after_6pm = after_6pm
      @article_id = article_id
      @data = data
    end

    def ==(other)
      self.eql?(other)
    end

    def eql?(other)
      @type == other.type && @meeting_id == other.meeting_id && @after_6pm == other.after_6pm && @article_id == other.article_id
    end
  end
end
