Sequel.migration do
  up do
    a = File.open('migrate/specs/tidal_datums.txt')
    b = a.read
    c = b.split("\n")
    datums = []
    c.each do |d|
      datums << {:name => d}
    end
    DB[:datum_kinds].multi_insert(datums)
  end
  down do
    DB[:datum_kinds].truncate
  end
end