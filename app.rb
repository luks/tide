require_relative 'models'
require 'roda'
require 'pry'
require 'will_paginate'
require 'will_paginate/view_helpers'
require 'will_paginate/sequel'

class Tide < Roda

  plugin :default_headers,
         'Content-Type' => 'text/html',
         # 'Content-Security-Policy' => "default-src 'self' https://oss.maxcdn.com/ https://maxcdn.bootstrapcdn.com https://ajax.googleapis.com",
         # 'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  plugin :assets, css: %w(steps.css tide.css leaflet.css), js: %w(jquery-3.2.1.min.js leaflet.js steps.js)

  use Rack::Session::Cookie,
      key: '_Tide_session',
      #:secure=>!TEST_MODE, # Uncomment if only allowing https:// access
      secret: File.read('.session_secret')

  plugin :csrf
  plugin :render, escape: true
  plugin :multi_route
  plugin :forme
  plugin :h
  plugin :indifferent_params
  plugin :flash

  compile_assets

  Unreloader.require('lib') {}
  Unreloader.require('routes') {}
  Unreloader.require('helpers') {}
  include Helpers::FormHelpers

  plugin :will_paginate, renderer: :bootstrap

  route do |r|
    r.assets
    r.multi_route

    r.root do
      view 'index'
    end

  end
end
