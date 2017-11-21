class Alias < Sequel::Model

  many_to_one :constituent, key: :name

end