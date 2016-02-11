require "middleman-core"
require 'middleman-s3_sync'
require 'landingman-deploy/commands'

Middleman::Extensions.register :landingman_deploy do
  require "landingman-deploy/extension"
  ::Landingman::DeployExtension
end
