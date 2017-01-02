require File.expand_path('../linear_equation', __FILE__)

le = LinearEquation.new do
  x - 2.y + z = 9
  2.x - y = 4
  y + z = 12
end

puts(le.solution)
