module Browser; module DOM

unless defined?(`window.MutationObserver`)
  class MutationObserver
    class Record
      attr_reader :type, :target, :old, :attribute

      def initialize(*)

      end

      def attributes?; type == :attributes; end
      def tree?;       type == :tree;       end
      def cdata?;      type == :cdata;      end
    end

    def initialize(&block)
      @block    = block
      @observed = []
    end

    def observe(target, options = nil)
      unless options
        options = {
          children:   true,
          tree:       true,
          attributes: :old,
          cdata:      :old
        }
      end

      self
    end

    def take
      result, @records = @records, []

      result
    end

    def disconnect

    end
  end
end

end; end
