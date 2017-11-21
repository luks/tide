class Constituent < Sequel::Model

  one_to_many :aliases, key: :name
  one_to_many :constants, key: :name


end