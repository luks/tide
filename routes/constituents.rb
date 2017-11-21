class Tide
  route 'constituents' do |r|
    r.is do
      @constituents = Constituent.select(
        Sequel.qualify(:constituents, :name),
        :definition,
        :alias,
        :speed,
        :format )
        .left_outer_join(:aliases, name: :name)
        .order(Sequel.qualify(:constituents, :name)).all
      r.get do
        view 'constituents/index'
      end
    end
  end
end
