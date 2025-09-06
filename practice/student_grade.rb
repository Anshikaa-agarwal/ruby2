class Student
  @@maxx = 0
  @@name

  attr_accessor :grades, :name

  def initialize(name)
    @name = name
    @grades = []
  end

  def average
    avg = (self.grades.reduce { |sum, marks| sum + marks})/self.grades.size
  end

  def add_grade(grade)
    self.grades << grade

    if average > @@maxx
      @@max = average
      @@name = self.name
    end
  end

  def self.topper
    @@name
  end
end

s1 = Student.new("A")
s1.add_grade(90)
s1.add_grade(80)

s2 = Student.new("B")
s2.add_grade(95)
s2.add_grade(85)

puts s1.average
puts Student.topper