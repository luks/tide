require_relative '../lib/../lib/shrine/file_uploader'

class StationFile < Sequel::Model

  many_to_one :data_set, key: :index

  plugin :validation_helpers

  def validate
    super
    # validates_presence %i(from to file)
  end

  include FileUploader::Attachment.new(:file)

end
