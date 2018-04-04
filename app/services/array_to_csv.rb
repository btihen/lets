require 'csv'

class ArrayToCsv

  def initialize(array)
    @array = array
  end

  def run
    return {error: "not an Array"}   unless array.is_a? Array
    return {error: "need 2-D Array"} unless array[0].is_a? Array
    return []                            if array.blank?
    perform
  end

  def self.call(array)
    return {error: "not an Array"}   unless array.is_a? Array
    return {error: "need 2-D Array"} unless array[0].is_a? Array
    return []                            if array.blank?
    new(array).send(:perform)
  end

  private

  attr_reader :array

  def perform
    # https://stackoverflow.com/questions/4822422/output-array-to-csv-in-ruby
    csv_string = CSV.generate do |csv|
      array.each do |row|
        csv << row
      end
    end
    return csv_string
  end

end
