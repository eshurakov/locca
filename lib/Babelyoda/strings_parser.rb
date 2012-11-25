
module Babelyoda
  class StringsParser
    Bit = Struct.new(:token, :value)

    def initialize(lexer)
      @lexer = lexer
    end

    def parse(str, &block)
      @block = block
      bitstream = []
      @lexer.lex(str) do | token, value |
        bitstream << Bit.new(token, value)
      end
      while bitstream.size > 0
        record = produce(bitstream)
        @block.call(record[:key], record[:value], record[:comment]) if record
      end
    end

    def produce(bs)
      match_bs(bs, :multiline_comment, :string, :equal_sign, :string, :semicolon) do |bits|
        result = {}
        result[:key] = bits[1]
        result[:comment] = bits[0]
        result[:value] = bits[3]
        return result
      end
      match_bs(bs, :singleline_comment, :string, :equal_sign, :string, :semicolon) do |bits|
        result = {}
        result[:key] = bits[1]
        result[:comment] = bits[0]
        result[:value] = bits[3]
        return result
      end
      match_bs(bs, :string, :equal_sign, :string, :semicolon) do |bits|        
        result = {}
        result[:key] = bits[0]
        result[:value] = bits[2]
        return result
      end
      match_bs(bs, :singleline_comment) do |bits|
        return nil
      end
      match_bs(bs, :multiline_comment) do |bits|
        return nil
      end
      raise "Syntax error: #{bs.shift(5).inspect}"
    end

    def match_bs(bs, *tokens)
      return unless bs.size >= tokens.size
      tokens.each_with_index do |token, idx|
        return unless bs[idx][:token] == token 
      end
      yield bs.shift(tokens.size).map { |bit| bit[:value] }
    end

    def cleanup_comment(str)
      if str.match(/^\/\/\s*/)
        str.sub(/^\/\/\s*/, '')
      else
        str.sub(/^\/\*\s*/, '').sub(/\s*\*\/$/, '')
      end
    end

    def cleanup_string(str)
      str.sub(/^\"/, '').sub(/\"$/, '')
    end
  end
end
