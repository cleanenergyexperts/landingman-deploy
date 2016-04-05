require 'middleman-cli'

module Middleman
  module Cli
    class DeployStaging < Thor::Group
      include Thor::Actions
      #check_unknown_options!
      namespace :staging

      def self.exit_on_failure?
        true
      end

      def staging
      	ARGV.shift # Remove environment name
      	ARGV.unshift('-e staging')
      	say("=== Deploying to Staging ===")
      	run("middleman s3_sync -e staging #{ARGV.join(' ')}") || exit(1)
      end
    end
    class DeployProduction < Thor::Group
      include Thor::Actions
      #check_unknown_options!
      namespace :production

      def self.exit_on_failure?
        true
      end

      def production
      	ARGV.shift # Remove environment name
      	ARGV.unshift('-e production')
        no_parallel = ARGV.delete('--no-parallel')
        if no_parallel.nil? then
        	say("=== Deploying to Production ===")
        	run("middleman s3_sync -B -e production #{ARGV.join(' ')}") || exit(1)
        else
          say("=== Building for Production ===")
          run("middleman build --no-parallel") || exit(1)
          say("=== Deploying to Production ===")
          run("middleman s3_sync -e production #{ARGV.join(' ')}") || exit(1)
        end
      end
    end

    # Add to CLI
  	Base.register(Middleman::Cli::DeployProduction, 'production', 'production [options]', 'Synchronizes a landingman site to production')
  	Base.register(Middleman::Cli::DeployStaging, 'staging', 'staging [options]', 'Synchronizes a landingman site to staging')
  end
end