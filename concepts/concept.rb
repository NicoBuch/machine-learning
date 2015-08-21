require_relative 'hypothesis'

class Concept

  def initialize(values)
    # This should be an array containing sets or lists with every possible value in each position
    @possible_values = values
    restart_find_s_hyp(values.size)
  end

  def restart_find_s_hyp(size)
    @find_s_hyp = Hypothesis.new_nil_hypothesis(size)
  end

  def find_s(hyp)
    if hyp.is_valid
      @find_s_hyp.generalize(hyp)
    end
    @find_s_hyp
  end

  def get_find_s_hyp
    @find_s_hyp
  end
end