# frozen_string_literal: true

require "open3"

module Esomer
  class Compiler
    def build_cpp(code, dest, compiler: "gcc", optimize_level: 0)
      raise "Invalid optimization level: #{optimize_level}" if [0,1,2].include?(optimize_level)
      cmd = case compiler
      when "gcc"
        ["g++","-o", dest, "-x", "c++", "-O#{optimize_level}", "-std=c++11", "-"]
      when "clang"
        ["clang++", "-o", dest, "-x", "c++", "-O#{optimize_level}", "-std=c++11", "-"]
      else
        raise "Unsupported C compiler"
      end

      out, err, status = Open3.capture3(*cmd, stdin_data: code)
      if status.exitstatus != 0
        STDERR.print(err)
        raise "C++ compile failed"
      end
    end

    def build_executable(bf_code, dest, optimize_level: 0)
      ast = Parser.new.parse(bf_code)
      cpp_code = CodeGenerator.new.generate_cpp(ast)
      build_cpp(cpp_code, dest, optimize_level: optimize_level)
    end
  end
end
