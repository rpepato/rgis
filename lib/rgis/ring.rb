module RGis
  class Ring
    attr_accessor :points
    
    def initialize
      @points = []
    end
    
    def == other
      @points == other.points
    end

    def valid?
      @points.count > 3 && @points.first == @points.last
    end
    
    def failure_message
      "teste"
    end

  end
end
