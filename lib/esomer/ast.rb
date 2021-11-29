module Esomer
  module AST
    class Node
      attr_reader :children
      def initialize
        @children = []
      end
    end

    class Program < Node
    end

    class WhileLoop < Node
    end

    class MoveRelative
      attr_reader :offset
      def initialize(offset)
        @offset = offset
      end
    end

    class AddHere
      attr_reader :value
      def initialize(value)
        @value = value
      end
    end

    class AddRelative
      attr_reader :offset, :value
      def initialize(offset, value)
        @offset = offset
        @value = value
      end
    end

    class PrintHere
    end

    class PrintRelative
      attr_reader :offset
      def initialize(offset)
        @offset = offset
      end
    end

    class ReadHere
    end

    class ReadRelative
      attr_reader :offset
      def initialize(offset)
        @offset = offset
      end
    end
  end
end
