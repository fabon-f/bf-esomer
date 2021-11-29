# frozen_string_literal: true

module Esomer
  class CodeGenerator
    def cpp_header
      <<-CPP
#include <cstdio>
#include <cstdint>
#include <array>

std::array<std::uint8_t,100001> tape;
std::int32_t pos;

inline uint8_t readchar() {
  std::fflush(stdout);
  int c = std::fgetc(stdin);
  return c == EOF ? 255 : c;
}

inline void printchar(uint8_t c) {
  std::fputc(c, stdout);
}

void exec();

int main() {
  tape.fill(0);
  pos = 50000;

  exec();
}

      CPP
    end

    def generate_cpp_proc(ast, indent_level = 1)
      indent = "  " * indent_level
      codes = ast.children.map do |node|
        case node
        when AST::MoveRelative
          "#{indent}pos += #{node.offset};"
        when AST::AddHere
          "#{indent}tape.at(pos) += #{node.value};"
        when AST::PrintHere
          "#{indent}printchar(tape.at(pos));"
        when AST::PrintRelative
          node.offset == 0 ? "#{indent}printchar(tape.at(pos));" : "#{indent}printchar(tape.at(pos + #{node.offset}));"
        when AST::ReadHere
          "#{indent}tape.at(pos) = readchar();"
        when AST::ReadRelative
          node.offset == 0 ? "#{indent}tape.at(pos) = readchar();" : "#{indent}tape.at(pos + #{node.offset}) = readchar();"
        when AST::WhileLoop
          "#{indent}while(tape.at(pos)) {\n#{generate_cpp_proc(node, indent_level + 1)}\n#{indent}}";
        when AST::AddRelative
          node.offset == 0 ? "#{indent}tape.at(pos) += #{node.value};" : "#{indent}tape.at(pos + #{node.offset}) += #{node.value};"
        else
          raise "Invalid AST"
        end
      end

      codes.join("\n")
    end

    def generate_cpp(ast)
      "#{cpp_header}void exec() {\n#{generate_cpp_proc(ast)}\n}\n"
    end
  end
end
