require File.expand_path('../linear_equation', __FILE__)

le = LinearEquation.new do
  x - y + z = 10
  3.x - 3.y + 2.z = 11
  2.x + 3.z = 9
end

puts(le.solution)
