
require 'bundler/setup'
require 'fido'
require 'fido/schema'
require 'json'
require 'irb'
require 'dry/inflector'
require 'dry/transformer'
require 'digest'
require 'ostruct'
require 'hash_diff'

hsh = {"a"=>"b", "c"=>{"e"=>[1]}, "k"=>"nop", "d"=>[1, 2, 3], "f"=>"j"}

module Functions
  extend Dry::Transformer::Registry

  import Dry::Transformer::HashTransformations
end

def t(*args)
  Functions[*args]
end

module RegexCompose
  class << self
    {
      sources: ->(*s) { s.map(&:source) }
    }.each do |method, lmbda|
      class_eval(<<-METHODS, __FILE__, __LINE__ + 1)
      def #{method}(*regexes)

      end
      METHODS
    end
  end
end

class IDFParser
  def initialize(filepath)
    File.open(filepath) do |file|
      while(line = file.gets)

      end
    end
  end
  def lambdas
    @lambdas = OpenStruct.new({
      joiner: -> (join_fn) { -> (*items) { items.join(&join_fn) } },
      sourcify: -> (*regexes) { regexes.map(&:source) },
      compose_with: -> (join_type) { }
    })
  end
  
  def regexes
    @regexes ||= OpenStruct.new({
      empty_start: /^\s*/,
      field_start: //
      line_type: /^\s*\\([^\s]+)/,
    })
  end

  def parse_start(line)
  end
end


binding.break
fn = t(:unwrap, 'c', ['d', 'f'], prefix: true)
fn.call(hsh)