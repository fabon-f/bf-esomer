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

    class PrintHere
    end

    class ReadHere
    end
  end
end
