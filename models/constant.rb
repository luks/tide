class Constant < Sequel::Model

  many_to_one :constituent, key: :name
  many_to_one :data_set, key: :index

  unrestrict_primary_key

  def validate
    super
    validates_presence :amp
    validates_presence :phase

    validates_numeric :amp
    validates_numeric :phase

    validates_operator(:>=, 0.00005, :amp) if amp.is_a?(Float)
    validates_operator(:>=, 0, :phase)  if phase.is_a?(Float)
    validates_operator(:<, 360, :phase)  if phase.is_a?(Float)

  end

end