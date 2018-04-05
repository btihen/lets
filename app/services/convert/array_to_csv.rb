require 'csv'

module Convert
  
  class ArrayToCsv

    def initialize(array)
      @array = Array(array)
    end

    def run
      perform
    end

    def self.call(array)
      new(array).send(:perform)
    end

    private

    attr_reader :array

    def perform
      return []                            if array.blank?
      # TODO: raise an error if this happens
      return {error: "need 2-D Array"} unless array[0].is_a? Array
      # https://stackoverflow.com/questions/4822422/output-array-to-csv-in-ruby
      csv_string = CSV.generate do |csv|
        array.each do |row|
          csv << row
        end
      end
      return csv_string
    end
  end

end
