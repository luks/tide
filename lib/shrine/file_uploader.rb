class FileUploader < Shrine

  plugin :processing
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 50 * 1024 * 1024, message: 'is too large (max is 50 MB)'
  end

  process(:store) do |io, context|
    a = io.read.split(/\r\n/).map { |x| x.split(/\s/)[0].to_i }.sort
    context[:record].update(from: Time.at(a.first), to: Time.at(a.last))
    io
  end

end