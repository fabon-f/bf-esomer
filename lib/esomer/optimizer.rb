module Esomer
  class Optimizer
    def reduce_pointer_movement(ast)
      # @type var new_ast: ::Esomer::AST::Node
      new_ast = ast.class.new
      current_pos = 0
      modifications = Hash.new(0)
      ast.children.each do |node|
        case node
        when AST::WhileLoop
          new_ast.children.push(*diff_hash_to_opcodes(modifications))
          new_ast.children.push(AST::MoveRelative.new(current_pos)) if current_pos != 0
          current_pos = 0
          modifications = Hash.new(0)
          new_ast.children.push(reduce_pointer_movement(node))
        when AST::PrintHere
          new_ast.children.push(*diff_hash_to_opcodes(modifications))
          new_ast.children.push(AST::PrintRelative.new(current_pos))
          modifications = Hash.new(0)
        when AST::ReadHere
          new_ast.children.push(*diff_hash_to_opcodes(modifications))
          new_ast.children.push(AST::ReadRelative.new(current_pos))
          modifications = Hash.new(0)
        when AST::AddHere
          modifications[current_pos] += node.value
        when AST::MoveRelative
          current_pos += node.offset
        when AST::AddRelative, AST::PrintRelative, AST::ReadRelative
          new_ast.children.push(node)
        else
          raise
        end
      end
      new_ast.children.push(*diff_hash_to_opcodes(modifications))
      new_ast.children.push(AST::MoveRelative.new(current_pos)) if current_pos != 0
      new_ast
    end

    private def diff_hash_to_opcodes(hash)
      hash.filter{_2 != 0}.sort_by{_1}.map do |offset, value|
        AST::AddRelative.new(offset, value)
      end
    end
  end
end
