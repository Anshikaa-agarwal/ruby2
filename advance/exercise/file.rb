require 'csv'
path = 'C:\\Users\\anshi\\Desktop\\ruby\\csv\\e1.csv'
data = CSV.read(path)
p data[1..]