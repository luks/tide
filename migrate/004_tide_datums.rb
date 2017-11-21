Sequel.migration do
  change do
    create_table(:datum_kinds) do
      primary_key :id
      String :name, size: 100, null: false
      index [:name], name: :unique_tide_datum, unique: true
    end
  end
end