Sequel.migration do
  change do
    create_table(:water_levels) do
      primary_key :id
      Timestamp :date
      Float :level
      foreign_key :index, :data_sets, null: false, key: [:index], on_delete: :cascade
    end
  end
end