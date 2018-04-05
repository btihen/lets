module Convert

  class SqlToCsv

    def initialize(sql_records)
      @sql_records = sql_records
    end

    def run
      perform
    end

    def self.call(sql_records)
      new(sql_records).send(:perform)
    end

    private

    attr_reader :sql_records

    def perform
      return [] if sql_records.blank?
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

end
