module Esomer
  class Parser
    def parse(str)
      tokens = str.scan(/[+\-]+|[><]+|[.,\[\]]/)
      # @type var stack: Array[AST::Node]
      stack = [program = AST::Program.new]

      tokens.each do |token|
        current_context = stack.last || raise
        case token
        when /[+\-]+/
          current_context.children.push(AST::AddHere.new(token.count("+") - token.count("-")))
        when /[><]+/
          current_context.children.push(AST::MoveRelative.new(token.count(">") - token.count("<")))
        when "."
          current_context.children.push(AST::PrintHere.new)
        when ","
          current_context.children.push(AST::ReadHere.new)
        when "["
          loop_ast = AST::WhileLoop.new
          stack.push(loop_ast)
          current_context.children.push(loop_ast)
        when "]"
          raise "Unbalanced brackets" unless stack.pop
        else
          raise
        end
      end

      raise "Unbalanced brackets" if stack.size != 0

      program
    end
  end
end
