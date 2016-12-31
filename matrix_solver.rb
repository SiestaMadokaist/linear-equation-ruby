require 'memoist'
class MatrixSolver
  attr_reader(:lhs, :rhs)
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def pairs
    @lhs.zip(@rhs)
  end

  def eliminated(index)
    l, r = pairs.select{|lh, rh| lh[index] != 0}.first
    others = pairs.select{|p| p != [l, r]}.map{|lh, rh| zeroize(index, l, r, lh, rh)}
    require 'pry'
    binding.pry
  end

  def zeroize(index, lref, rref, lm, rm)
    return [lm, rm] if lm[index] == 0
    mu = lref[index].to_f / lm[index]
    lt = lm.map{|v| v * mu }
    rt = rm * mu
    [lt.zip(lref).map{|a, b| a - b}, rt - rref]
  end

end
