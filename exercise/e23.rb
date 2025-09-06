# frozen_string_literal: true

require 'csv'

# converting csv table to hash
class CSV
  def self.to_hash(file_path)
    hashh = {}
    foreach(file_path, headers: true) do |row|
      designation = row[' Designation'].strip
      name = row['Name'].strip
      empid = row[' EmpId'].strip

      desig = hashh[designation] ||= []

      desig << [name, empid]
    end
    hashh.sort_by { |_, v| v }.to_h
  end
end

# printing from hash
class Hash
  def print_formatted
    each_pair do |desig, pair|
      puts desig
      pair.each { |val| puts "#{val[0]} (EmpId: #{val[1]})" }
      puts
    end
  end
end

file_path = 'C:\Users\anshi\Desktop\ruby\csv\employee_data.csv'
CSV.to_hash(file_path).print_formatted