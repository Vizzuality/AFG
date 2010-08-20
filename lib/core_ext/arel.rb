module Arel
  module Sql
    module Attributes
      def self.for(column)
        case column.type
        when :string    then String
        when :text      then String
        when :integer   then Integer
        when :float     then Float
        when :decimal   then Decimal
        when :date      then Time
        when :datetime  then Time
        when :timestamp then Time
        when :time      then Time
        when :binary    then String
        when :boolean   then Boolean
        when :geometry  then String
        else
          raise NotImplementedError, "Column type `#{column.type}` is not currently handled"
        end
      end
    end
  end
end
