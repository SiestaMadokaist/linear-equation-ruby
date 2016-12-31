require File.expand_path('../linear_equation', __FILE__)

le = LinearEquation.new do
  2.x + 3.y = 10
  3.x - 3.y = 11
end

binding.pry

puts(le.solution)
