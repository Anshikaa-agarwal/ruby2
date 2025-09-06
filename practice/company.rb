# Manager can not raise salary of diff department employee
class DifferentDepartment < StandardError ; end

class ContractorError < StandardError ; end

# parent class Employee
class Employee
  attr_reader :name, :salary
  attr_accessor :department, :title

  def initialize(name, department, title, salary)
    @name = name
    @department = department
    @title = title
    @salary = salary
  end

  def transfer_to(dept)
    self.department = dept
  end

  def retitle(title)
    self.title = title
  end

  def info
    puts "#{self.class.name} details: "
    puts "Name: #{self.name}"
    puts "Department: #{self.department}"
    puts "Title: #{self.title}"
    puts "Salary: #{self.salary} \n\n"
  end

  # changes to be made
  protected def receive_raise(amount)
    change_salary!(amount)
  end

  private def change_salary!(delta)
    @salary = @salary + delta
  end
end

# Manager class
class Manager < Employee
  def give_raise!(employee, amount)
    if self.department == employee.department
      if employee.is_a?(Contractor)
        raise ContractorError, "Manager cannot raise salary of contractors"
      else
        employee.receive_raise(amount)
      end
    else
      raise DifferentDepartment, "Manager cannot raise salary of different department's employee - employee(#{employee.department})"
    end
  end
end

# Contractors - special employee
class Contractor < Employee ; end

# main code
emp1 = Employee.new("Abc", "Maths", "Teacher", 50000)
emp2 = Employee.new("Def", "English", "Teacher", 60000)
manager1 = Manager.new("John", "Maths", "Manager", 100000)
contractor1 = Contractor.new("David", "Construction", "Contractor", 70000)

emp1.info

# main code
emp1 = Employee.new("Abc", "Maths", "Teacher", 50000)
emp2 = Employee.new("Def", "English", "Teacher", 60000)
manager1 = Manager.new("John", "Maths", "Manager", 100000)
contractor1 = Contractor.new("David", "Construction", "Contractor", 70000)

emp1.info

begin
  puts "emp1's salary before appraisal: #{emp1.salary}"
  manager1.give_raise!(emp1, 10000)
  puts "emp1's salary after appraisal: #{emp1.salary}\n\n"
rescue DifferentDepartment, ContractorError => e
  puts "Error while raising salary for #{emp1.name} (#{emp1.department}): #{e.class} - #{e.message}"
end

begin
  puts "emp2's salary before appraisal: #{emp2.salary}"
  manager1.give_raise!(emp2, 7000)
  puts "emp2's salary after appraisal: #{emp2.salary}\n\n"
rescue DifferentDepartment, ContractorError => e
  puts "Error while raising salary for #{emp2.name} (#{emp2.department}): #{e.class} - #{e.message}"
end

begin
  puts "contractor1's salary before appraisal: #{contractor1.salary}"
  manager1.give_raise!(contractor1, 5000)
  puts "contractor1's salary after appraisal: #{contractor1.salary}\n\n"
rescue DifferentDepartment, ContractorError => e
  puts "Error while raising salary for #{contractor1.name} (#{contractor1.department}): #{e.class} - #{e.message}"
end
