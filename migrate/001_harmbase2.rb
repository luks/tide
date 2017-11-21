Sequel.migration do
  change do
    create_table(:constituents) do
      String :name, text: true, null: false
      String :definition, text: true, null: false
      Float :speed, null: false

      primary_key [:name]
    end

    create_table(:data_sets) do
      primary_key :index
      String :name, text: true, null: false
      String :station_id_context, text: true
      String :station_id, text: true
      Float :lat
      Float :lng
      String :timezone, text: true, null: false
      String :country, text: true
      String :units, text: true, null: false
      Float :min_dir
      Float :max_dir
      String :legalese, text: true
      String :notes, text: true
      String :comments, text: true
      String :source, text: true
      String :restriction, text: true, null: false
      Date :date_imported, default: Sequel::CURRENT_DATE
      String :xfields, text: true
      column :interval, :geometry
      String :datumkind, text: true
      Float :datum
      Integer :months_on_station
      Date :last_date_on_station
      foreign_key :ref_index, :data_sets, key: [:index]
      String :min_time_add
      Float :min_level_add
      Float :min_level_multiply
      String :max_time_add
      Float :max_level_add
      Float :max_level_multiply
      String :flood_begins
      String :ebb_begins
      String :original_name, text: true
      String :state, text: true
    end

    create_table(:drops) do
      String :format, text: true, null: false
      String :name, text: true, null: false

      primary_key %i(format name)
    end

    create_table(:footnotes) do
      String :tag, text: true, null: false
      String :content, text: true, null: false

      primary_key [:tag]
    end

    create_table(:refs2010) do
      String :station_id, text: true, null: false
      Float :m2phase, null: false

      primary_key [:station_id]
    end

    create_table(:aliases) do
      String :format, text: true, null: false
      String :alias, text: true, null: false
      foreign_key :name, :constituents, type: String, text: true, null: false, key: [:name]

      primary_key %i(format alias)
    end

    create_table(:constants) do
      foreign_key :index, :data_sets, null: false, key: [:index], on_delete: :cascade
      foreign_key :name, :constituents, type: String, text: true, null: false, key: [:name]
      Float :phase, null: false
      Float :amp, null: false

      primary_key %i(index name)
    end
  end
end
