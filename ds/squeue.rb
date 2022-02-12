module DS
  class SQueue
    def initialize(size = 5)
      @stacka = DS::Stack.new(size)
      @stackb = DS::Stack.new(size)
    end

    def add(item)
      @stacka.push(item)
    end

    def remove
      transfer if @stackb.empty?
      @stackb.pop
    end

    private

    def transfer
      while !@stacka.empty?
        @stackb.push(@stacka.pop)
      end
    end
  end
end
