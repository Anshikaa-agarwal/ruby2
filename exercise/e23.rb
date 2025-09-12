# frozen_string_literal: true

require 'csv'

class Employee
  attr_reader :name, :empid, :designation

  def initialize(empid, name, designation)
    @empid = empid
    @name = name
    @designation = designation
  end

  def to_s
    "#{@name} (EmpId: #{@empid})\n"
  end
end

class List
  def initialize
    @employees = []
  end

  def add_employee(emp)
    @employees << emp
  end

  def group_by_designation
    @employees.group_by { |emp| emp.designation }.sort_by { |_, val| -val.size}.to_h
  end

  def print_list
    group_by_designation.each_pair do |key, val|
      puts val.size > 1 ? "#{key}s" : key
      val.each { |emp| puts emp }
      puts
    end
  end
end

# converting CSV table to hash
class CSV

  def self.append_to_list(file_path, list)
    foreach(file_path, headers: true) do |row|
      designation = row[' Designation'].strip
      name = row['Name'].strip
      empid = row[' EmpId'].strip
      list.add_employee(Employee.new(empid, name, designation))
    end
  end

end

file_path = 'C:\Users\anshi\Desktop\ruby\csv\employee_data.csv'
list = List.new
CSV.append_to_list(file_path, list)
list.print_list