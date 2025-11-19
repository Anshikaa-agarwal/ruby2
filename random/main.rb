module ABC ; end
load "r1.rb", ABC
p defined?(::A)
# p defined?(::a)
p defined?(::C)
p defined?(::D)