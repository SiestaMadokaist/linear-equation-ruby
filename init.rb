require File.expand_path('../linear_equation', __FILE__)
require 'pry'

le = LinearEquation.new do
  2.x - 3.y + 3.a = 15
  2.x - 4.y + 2.a = 10
  3.x + 1.y + 3.a = 2
end

puts(le.solution)
