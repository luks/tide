class DataSet < Sequel::Model
  plugin :nested_attributes

  one_to_many :constants, key: :index
  one_to_many :stations, key: :ref_index, class: self
  many_to_one :ref_station, key: :ref_index, class: self

  nested_attributes :constants, destroy: true

  many_to_many :constituents, left_key: :index, right_key: :name,
                              join_table: :constants

  UNITS = %w(meters feet knots knots^2).freeze

  RESTRICTION = ['Public domain', 'Non-commercial use only', 'DoD/DoD contractors only.'].freeze

  plugin :validation_helpers

  def validate
    super
    validates_presence %i(name)
    validates_presence :lng
    validates_presence :lat
    validates_presence :datum if meridian
    validates_presence :meridian if datum
    validates_presence :ref_index, message: 'is mandatory for subordinate station ' unless datum
    validates_presence :datum, message: 'is mandatory for reference station' unless ref_index

    validates_unique :name
    validates_max_length 89, :name
    validates_includes UNITS, :units

    validates_numeric :min_dir, allow_nil: true
    validates_numeric :max_dir, allow_nil: true

    validates_numeric :lng
    validates_numeric :lat

    validates_operator(:>=, -180, :lng) if lng.is_a?(Float)
    validates_operator(:<=, 180, :lng)  if lng.is_a?(Float)
    validates_operator(:>=, -90, :lat)  if lat.is_a?(Float)
    validates_operator(:<=, 90, :lat)   if lat.is_a?(Float)

    validates_operator(:<, 360, :min_dir) if min_dir.is_a?(Float)
    validates_operator(:>=, 0.0, :min_dir) if min_dir.is_a?(Float)

    validates_operator(:<, 360, :max_dir) if max_dir.is_a?(Float)
    validates_operator(:>=, 0.0, :max_dir) if max_dir.is_a?(Float)
  end

  def is_reference?
    ref_index.nil?
  end

  def is_subordinate?
    !is_reference?
  end
end
