class Hypothesis
  @@accept_all = '?'
  @@deny_all = '@'

  def initialize(values, valid)
    @values = Array.new(values.size)
    for i in 0..(values.size - 1)
      @values[i] = values[i]
    end
    @valid = valid
  end

  def self.eval(h1, h2)
    hyp1 = h1.get_array
    hyp2 = h2.get_array
    # Evaluates if the first hypothesis accepts the second one
    for i in 0..(hyp1.size - 1)
      if (hyp1[i] != hyp2[i]) && (hyp1[i] != @@accept_all)
        return false
      end
    end
    return true
  end

  def generalize(eval)
    hyp = eval.get_array
    # Returns a hypothesis that is more general than target and accepts eval
    for i in 0..(@values.size)
      if @values[i] != hyp[i]
        if @values[i] == @@deny_all
          @values[i] = hyp[i]
        else
          @values[i] = @@accept_all
        end
      end
    end
    return self
  end

  def self.new_nil_hypothesis(size)
    ans = Array.new(size)
    for i in 0..(size - 1)
      ans[i] = @@deny_all
    end
    return Hypothesis.new(ans, nil)
  end

  def self.new_all_hypothesis(size)
    ans = Array.new(size)
    for i in 0..(size - 1)
      ans[i] = @@accept_all
    end
    return Hypothesis.new(ans, nil)
  end

  def self.new_random_hypothesis(values)
    ans = Array.new(values.size)
    for i in 0..(values.size - 1)
      pos = rand(values[i].size)
      ans[i] = values[i][pos]
    end
    pos = rand(2)
    if pos == 1
      bool = true
    else
      bool = false
    end
    return Hypothesis.new(ans, bool)
  end

  def get_array
    return @values
  end

  def is_valid
    return @valid
  end

  def ==(hypothesis)
    if @values.size != hypothesis.get_array.size
      return false
    end
    if @valid != hypothesis.is_valid
      return false
    end
    for i in 0..(@values.size)
      if @values[i] != hypothesis.get_array[i]
        return false
      end
    end
    return true
  end

  def to_s
    return @values.to_s + @valid.to_s
  end
end