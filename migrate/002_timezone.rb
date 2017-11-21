Sequel.migration do
  change do
    create_table(:timezones) do
      primary_key :id
      String :name, size: 100, null: false
      index [:name], name: :unique_timezone_name, unique: true
    end
  end
end