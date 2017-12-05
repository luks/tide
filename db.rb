require_relative '.env.rb'

require 'sequel'

# Delete DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('DATABASE_URL'))
DB.extension(:pagination)
DB.extension :pg_array, :pg_interval

TIPS = {
  stations_name: 'This is the name of the station.',
  stations_id: 'This is the unique identifier of the station within the specified context.',
  stations_id_context: 'This is the context of the Station ID.',
  stations_units: 'Select feet or meters for tides, knots for currents.',
  stations_datumkind: 'Choose Mean Lower Low Water or whatever is the description of the datum that you have received.',
  help_reference_station: 'A tide station whose predictions trace directly to harmonic constants that were derived from water level readings for that same station is called a reference station.',
  stations_ref_index: 'A tide station whose predictions trace directly to harmonic constants that were derived from water level readings for that same station is called a reference station.',
  help_subordinate_station: 'A subordinate station is a tide station whose predictions are obtained by applying corrections to the predictions generated for a reference station.'
}.freeze
