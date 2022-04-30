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

    def generate_pseudo_code(ast, indent_level = 0)
      indent = "  " * indent_level
      codes = ast.children.map do |node|
        case node
        when AST::MoveRelative
          if node.offset == 0
            ""
          elsif node.offset > 0
            "#{indent}pos += #{node.offset};"
          else
            "#{indent}pos -= #{-node.offset};"
          end
        when AST::AddHere
          if node.value == 0
            ""
          elsif node.value > 0
            "#{indent}tape[pos] += #{node.value};"
          else
            "#{indent}tape[pos] -= #{-node.value};"
          end
        when AST::PrintHere
          "#{indent}printchar(tape[pos]);"
        when AST::PrintRelative
          if node.offset == 0
            "#{indent}printchar(tape[pos]);"
          elsif node.offset > 0
            "#{indent}printchar(tape[pos + #{node.offset}]);"
          else
            "#{indent}printchar(tape[pos - #{-node.offset}]);"
          end
        when AST::ReadHere
          "#{indent}tape[pos] = readchar();"
        when AST::ReadRelative
          if node.offset == 0
            "#{indent}tape[pos] = readchar();"
          elsif node.offset > 0
            "#{indent}tape[pos + #{node.offset}] = readchar();"
          else
            "#{indent}tape[pos - #{-node.offset}] = readchar();"
          end
        when AST::WhileLoop
          "#{indent}while(tape[pos]) {\n#{generate_pseudo_code(node, indent_level + 1)}\n#{indent}}";
        when AST::AddRelative
          pos = if node.offset == 0
            "pos"
          elsif node.offset > 0
            "pos + #{node.offset}"
          else
            "pos - #{-node.offset}"
          end

          add_op = node.value >= 0 ? "+= #{node.value}" : "-= #{-node.value}"
          node.value == 0 ? "" : "#{indent}tape[#{pos}] #{add_op};"
        else
          raise "Invalid AST"
        end
      end

      codes.grep_v("").join("\n")
    end
  end
end
