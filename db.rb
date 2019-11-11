require_relative '.env.rb'

require 'sequel'

# Delete DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('DATABASE_URL'))
DB.extension(:pagination)
# DB.extension :pg_array, :pg_interval

TIPS = {
  stations_name: 'This is the name of the station.',
  stations_id: 'This is the unique identifier of the station within the specified context.',
  stations_id_context: 'This is the context of the Station ID.',
  stations_units: 'Select feet or meters for tides, knots for currents.',
  stations_min_dir: 'This is the direction of the maximum ebb current.  Enter a number between 0 and 359, or leave blank for unknown or not applicable.',
  stations_max_dir: 'This is the direction of the maximum flood current.  Enter a number between 0 and 359, or leave blank for unknown or not applicable.',
  stations_months_on_station: 'This is the number of months of tide data that were used to calculated the harmonic constants for this station.  Unknown is indicated by a blank.',
  stations_last_date_on_station: 'This is the last date in the time series that was used to calculate the harmonic constants for this station.  The format is YYYYMMDD.  Unknown is indicated by a blank.',
  stations_datumkind: 'Choose Mean Lower Low Water or whatever is the description of the datum that you have received.',
  stations_datum: 'For tides, this is the elevation of Mean Sea Level (MSL) relative to the specified datum in Level Units. For currents it is an analogous constant used to calibrate the velocity of the predicted currents against zero.',
  stations_meridian: 'This is the standard time to which epochs are adjusted, a.k.a. the meridian, in hours and minutes east of UTC.  The format is +/-HHMM.  Do not use daylight savings time.',
  stations_restriction: 'This specifies the acceptable use of the tide data for this station.  If you set it to <b>public domain</b>, it means that anybody can steal your data for any purpose.',
  help_reference_station: 'A tide station whose predictions trace directly to harmonic constants that were derived from water level readings for that same station is called a reference station.',
  stations_ref_index: 'A tide station whose predictions trace directly to harmonic constants that were derived from water level readings for that same station is called a reference station.',
  help_subordinate_station: 'A subordinate station is a tide station whose predictions are obtained by applying corrections to the predictions generated for a reference station.',
  constants_name: 'This table contains all of the amplitude and epoch data for this station. The constituent names are not editable.'
}.freeze
