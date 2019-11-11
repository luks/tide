Sequel.migration do
  change do
    create_table(:station_files) do
      primary_key :id
      String :description, text: true
      String :file_data, text: true
      Timestamp :from
      Timestamp :to
      foreign_key :index, :data_sets, null: false, key: [:index], on_delete: :cascade
    end
  end
end