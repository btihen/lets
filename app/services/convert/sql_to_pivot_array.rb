module Convert

  class SqlToPivotArray

    DataRow = Struct.new(:row, :column, :field)

    def initialize(sql_records, data_type)
      @sql_records = sql_records

      case data_type
      when :tree_species
        @args = { row: 'elevation_m',
                  column: 'species_code',
                  field: 'avg_species_count'}
      when :tree_circumfences
        raise NotImplementedError
      else
        raise NotImplementedError
      end
    end

    def run
      perform
    end

    def self.call(sql_records, data_type)
      new(sql_records).send(:perform)
    end

    protected

    attr_reader :sql_records, :args

    def perform
      data_objects = sql_to_data_objects_array
      pivot_object = build_pivot_object( data_objects )
      pivot_object_to_array( pivot_object )
    end

    private

    def sql_to_data_objects_array
      pivot_vals = []
      # make data into a format usable by PivotTable
      sql_records.each do |hash|
        pivot_vals << DataRow.new(hash[ args[:row] ],    # hash['elevation_m']
                                  hash[ args[:column] ], # hash['species_code']
                                  hash[ args[:field] ] ) # hash['avg_species_count']
      end
      return pivot_vals
    end

    def build_pivot_object(pivot_vals)

      # configure pivot table
      pivot = PivotTable::Grid.new do |g|
        g.source_data = pivot_vals
        g.row_name    = :row      # :species_code
        g.column_name = :column   # :elevation_m
        g.field_name  = :field    # :avg_species_count
      end

      # build the data_grid
      pivot.build
    end

    def pivot_object_to_array(pivot_object)
      # copy pivot_object data grid out of object and build data array
      pivot_array = pivot_object.data_grid.dup

      # update the data array - nils to 0 & add elevation value to each row
      pivot_array.each_with_index do | _, index|

        # convert data nils into 0
        pivot_array[index] = pivot_array[index].map{|r| r||0 }

        # add the elevation to the front of the row
        pivot_array[index].unshift( pivot_object.row_headers[index] )
      end

      # add headers to the top of the array
      pivot_array.unshift( ["elevation"] + pivot_object.column_headers )
    end

  end

end
