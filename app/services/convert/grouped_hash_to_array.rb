module Convert

  class GroupedHashToArray

    def initialize(grouped_hash)
      @grouped_hash = grouped_hash
    end

    def run
      perform
    end

    def self.call(grouped_hash)
      new(grouped_hash).send(:perform)
    end

    private

    attr_reader :grouped_hash

    def perform
      array  = []
      # species_pivot_array << ["Year"] + species_pivot_by_year.first[1][0]
      grouped_hash.each do |year, data|
        data.each_with_index do |row, index|
          array << ["Year #{year}"] + row if index.eql? 0
          array << [year] + row       unless index.eql? 0
        end
      end
      array
    end
  end

end
