# frozen_string_literal: false

# interactive program
class REPL
  attr_reader :count, :current_binding

  def initialize
    @count = 1
    @current_binding = binding
    @code = ''
  end

  private

  def next_line
    @count += 1
  end

  def input
    print "irb: #{count}> "
    gets.chomp
  end
  
  def process_line(line)
    line.chomp.empty? ? evaluate_code : @code << "\n" << line
  end

  def evaluate_code
    output = eval(@code, current_binding)
    puts "=> #{output.inspect}"
  rescue StandardError => e
    puts "#{e.message} (#{e.class})"
  ensure
    @code = ''
  end

  public

  def instructions
    <<~INSTR
      Enter code through command line.
      Enter a blank line to evaluate.
      Enter 'q' to quit.
    INSTR
  end

  def start
    loop do
      line = input
      break if REPL.quit?(line)

      process_line(line)
      next_line
    end
  end

  def self.quit?(line)
    line == 'q'
  end
end

r1 = REPL.new
puts r1.instructions
r1.start