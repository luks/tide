Sequel.migration do
  up do
    a = File.open('migrate/specs/timezones.txt')
    b = a.read
    c = b.split("\n")
    zones = []
    c.each do |z|
      zones << {:name => z}
    end
    DB[:timezones].multi_insert(zones)
  end
  down do
    DB[:timezones].truncate
  end
end
