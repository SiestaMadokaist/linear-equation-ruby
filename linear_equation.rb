require 'memoist'
require 'matrix'
require 'set'

class Parameter
  attr_reader(:string)
  def initialize(string)
    @string = string
  end

  def negative?
    @string.start_with?("-")
  end

  def positive?
    not negative?
  end

  def regex_group
    @string.match(/(?<multiplier>\d+)\.(?<name>\w+)/)
  end

  def multiplier
    regex_group[:multiplier].to_i
  end

  def sign
    return "-" if negative?
    return ""
  end

  def name
    regex_group[:name]
  end

  def to_s
    inspect
  end

  def inspect
    "#{sign}#{multiplier}#{name}"
  end

end
class Equation

  extend Memoist
  attr_reader(:source)
  def initialize(source)
    @source = source
  end

  def left_hand
    source
      .scan(/[+-]* *\d+\.\w+/)
      .map{|s| Parameter.new(s)}
  end
  memoize(:left_hand)

  def right_hand
    source
      .split("=")
      .last
      .strip
      .to_i
  end

  def inspect
    "#{left_hand.join(" + ")} = #{right_hand}"
  end

  def parameters
    left_hand.map(&:name)
  end

  def relevant_variables
    left_hand.select{|p| p.multiplier != 0 }.map(&:name)
  end

end

class LinearEquation

  attr_reader(:eq)
  extend Memoist
  def initialize(&eq)
    raise ArgumentError, "equation must be passed" unless block_given?
    @eq = eq
  end

  def raw_equations
    @eq
      .source
      .split("\n")
      .map(&:strip)
      .select{|x| not x.start_with?("#")}
      .slice(1..-2)
  end

  def equations
    raw_equations.map{|s| Equation.new(s) }
  end
  memoize(:equations)

  def unbound_variables
    equations.map(&:relevant_variables).flatten.to_set
  end
  memoize(:unbound_variables)

  def left_matrix
    arr = equations.map do |eq|
      unbound_variables
        .map{|v| eq.left_hand.select{|p| p.name == v }.first }
        .map{|p| p ? p.multiplier : 0}
    end
    Matrix[*arr]
  end
  memoize(:left_matrix)

  def inverse_left_matrix
    left_matrix.inverse
  end

  def right_matrix
    arr = equations.map(&:right_hand).map{|x| [x]}
    Matrix[*arr]
  end
  memoize(:right_matrix)

  def solution
    unbound_variables.zip(_solution).map{|var, value| "#{var} = #{value}"}.join("\n")
  end

  def _solution
    inverse_left_matrix * right_matrix
  end

end
