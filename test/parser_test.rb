# frozen_string_literal: true

require "test_helper"

class EsomerTest < Test::Unit::TestCase
  test "parser" do
    parser = ::Esomer::Parser.new
    ast = parser.parse(">++++[<+>-]")
    assert_instance_of(::Esomer::AST::Program, ast)

    node1 = ast.children[0]
    assert_instance_of(::Esomer::AST::MoveRelative, node1)
    raise unless node1.instance_of?(::Esomer::AST::MoveRelative)
    assert_equal(1, node1.offset)

    node2 = ast.children[1]
    assert_instance_of(::Esomer::AST::AddHere, node2)
    raise unless node2.instance_of?(::Esomer::AST::AddHere)
    assert_equal(4, node2.value)

    assert_instance_of(::Esomer::AST::WhileLoop, ast.children[2])
    loop_ast = ast.children[2]
    raise unless loop_ast.instance_of?(::Esomer::AST::WhileLoop)

    node3 = loop_ast.children[0]
    assert_instance_of(::Esomer::AST::MoveRelative, node3)
    raise unless node3.instance_of?(::Esomer::AST::MoveRelative)
    assert_equal(-1, node3.offset)

    node4 = loop_ast.children[1]
    assert_instance_of(::Esomer::AST::AddHere, node4)
    raise unless node4.instance_of?(::Esomer::AST::AddHere)
    assert_equal(1, node4.value)

    node5 = loop_ast.children[2]
    assert_instance_of(::Esomer::AST::MoveRelative, node5)
    raise unless node5.instance_of?(::Esomer::AST::MoveRelative)
    assert_equal(1, node5.offset)

    node6 = loop_ast.children[3]
    assert_instance_of(::Esomer::AST::AddHere, node6)
    raise unless node6.instance_of?(::Esomer::AST::AddHere)
    assert_equal(-1, node6.value)
  end

  test "parser should fail with unbalanced brackets" do
    assert_raise_message("Unbalanced brackets") do
      parser = ::Esomer::Parser.new
      parser.parse("[[]")
    end
    assert_raise_message("Unbalanced brackets") do
      parser = ::Esomer::Parser.new
      parser.parse("[]]")
    end
  end
end
