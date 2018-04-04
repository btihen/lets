require 'csv'

class SqlToCsv

  def initialize(sql_records)
    @sql_records = sql_records
  end

  def run
    return [] if sql_records.blank?
    perform
  end

  def self.call(sql_records)
    return [] if sql_records.blank?
    new(sql_records).send(:perform)
  end

  private

  attr_reader :sql_records

  def perform
    array = sql_2_array
    ArrayToCsv.(array)
  end

  def sql_2_array
    array = []
    keys = sql_records.first.keys
    array << keys
    sql_records.each do |row|
      data = []
      keys.each do |k|
        data << row[k]
      end
      array << data
    end
    array
  end

end
