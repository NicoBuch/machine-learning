#!/usr/bin/env ruby
require_relative 'concept'
require_relative 'hypothesis'

def exercise1
  possible_values = [['soleado','nublado','lluvioso'],['calida','fria'],['normal','alta'],['fuerte','debil'],['calida','fria'],['igual','cambiante']]
  example1 = Hypothesis.new(['soleado', 'calida', 'normal', 'fuerte', 'calida', 'igual'], true)
  example2 = Hypothesis.new(['soleado', 'calida', 'alta', 'fuerte', 'calida', 'igual'], true)
  example3 = Hypothesis.new(['nublado', 'fria', 'alta', 'fuerte', 'calida', 'cambiante'], false)
  example4 = Hypothesis.new(['soleado', 'calida', 'alta', 'fuerte', 'fria', 'cambiante'], true)
  concept = Concept.new(possible_values)
  puts 'La traza es:'
  puts concept.find_s(example1)
  puts concept.find_s(example2)
  puts concept.find_s(example3)
  puts concept.find_s(example4)
end

def exercise2
  possible_values = [['soleado','nublado','lluvioso'],['calida','fria'],['normal','alta'],['fuerte','debil'],['calida','fria'],['igual','cambiante']]
  objective = Hypothesis.new(['soleado', 'calida', '?', '?', '?', '?'], nil)
  concept = Concept.new(possible_values)
  count = 0
  while true
    count += 1
    r1 = possible_values[2][rand(possible_values[2].size)]
    r2 = possible_values[3][rand(possible_values[3].size)]
    r3 = possible_values[4][rand(possible_values[4].size)]
    r4 = possible_values[5][rand(possible_values[5].size)]
    random = Hypothesis.new(['soleado','calida',r1,r2,r3,r4], true)
    puts random
    concept.find_s(random)
    if concept.get_find_s_hyp == objective
      break
    end
  end
  print count.to_s
  puts 'FINISHED'
  return count
end

total = 0
20.times do
  total += exercise2
end
print 'Promedio: '
puts (total/20.0).round(2).to_s
