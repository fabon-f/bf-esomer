# frozen_string_literal: true

require "test_helper"

class EsomerTest < Test::Unit::TestCase
  test "parser" do
    parser = ::Esomer::Parser.new
    ast = parser.parse(">++++[<+>-]")
    assert_instance_of(::Esomer::AST::Program, ast)
    assert_instance_of(::Esomer::AST::MoveRelative, ast.children[0])
    assert_equal(1, ast.children[0].offset)
    assert_instance_of(::Esomer::AST::AddHere, ast.children[1])
    assert_equal(4, ast.children[1].value)
    assert_instance_of(::Esomer::AST::WhileLoop, ast.children[2])
    loop_ast = ast.children[2]
    assert_instance_of(::Esomer::AST::MoveRelative, loop_ast.children[0])
    assert_equal(-1, loop_ast.children[0].offset)
    assert_instance_of(::Esomer::AST::AddHere, loop_ast.children[1])
    assert_equal(1, loop_ast.children[1].value)
    assert_instance_of(::Esomer::AST::MoveRelative, loop_ast.children[2])
    assert_equal(1, loop_ast.children[2].offset)
    assert_instance_of(::Esomer::AST::AddHere, loop_ast.children[3])
    assert_equal(-1, loop_ast.children[3].value)
  end
end
