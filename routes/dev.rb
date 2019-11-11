class Tide
  plugin :autoforme

  Forme.register_config(:mine, base: :default, labeler: :explicit, wrapper: :div)
  Forme.default_config = :mine
  require 'forme/bs3'

  def self.setup_autoforme(name, &block)
    autoforme(name: name) do
      form_options input_defaults: { 'text' => { size: 50 }, 'checkbox' => { label_position: :before } }
      def self.model(mod, &b)
        super(mod) do
          class_display_name mod.name.sub('Latoto::', '')
          instance_exec(&b) if b
        end
      end
      instance_exec(&block)
    end
  end

  setup_autoforme(:bootstrap3) do
    form_options(config: :bs3)
    mtm_associations :all
    association_links :all_except_mtm
    model Alias
    model Constant
    model Constituent
    model DataSet
    # model Footnote
    model SubordinateStationView
  end

  route 'dev' do |_r|
    autoforme(:bootstrap3)
  end
end
