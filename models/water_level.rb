class WaterLevel < Sequel::Model

  many_to_one :data_set, key: :index

end