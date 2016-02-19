# Require core library
require 'middleman-core'

module Landingman
  class DeployExtension < ::Middleman::Extension
    YEAR = 60 * 60 * 24 * 365

    def initialize(app, options_hash={}, &block)
      super
      self.configure_s3_sync
    end

    def after_configuration
      self.configure_s3_cache
    end

    protected
      def configure_s3_sync
        # Deployment via S3 Sync
        bucket = app.config[:aws_bucket]
        app.activate :s3_sync do |s3_sync|
          s3_sync.bucket                = ENV['AWS_BUCKET'] || bucket       # The AWS bucket name.
          s3_sync.region                = ENV['AWS_REGION'] || 'us-west-2'  # The AWS region for your bucket.
          s3_sync.aws_access_key_id     = ENV['AWS_ACCESS_ID']
          s3_sync.aws_secret_access_key = ENV['AWS_SECRET_KEY']
          s3_sync.delete                = false                             # We delete stray files by default.
          s3_sync.after_build           = false                             # Disable chaining on build
          s3_sync.prefer_gzip           = true
          s3_sync.index_document        = 'index.html'
          s3_sync.error_document        = '404.html'
        end
      rescue RuntimeError => e
        logger.debug "S3 Sync is already activated"
      end

      def configure_s3_cache
        # Caching headers
        default_policy = { max_age: YEAR, public: true, expires: (Time.now + YEAR) }
        ::Middleman::S3Sync.add_caching_policy(:default, default_policy) unless ::Middleman::S3Sync.default_caching_policy
        ::Middleman::S3Sync.add_caching_policy('application/json', { max_age: 0, public: true, must_revalidate: true })
        ::Middleman::S3Sync.add_caching_policy('application/xml', { max_age: 0, public: true, must_revalidate: true })
        ::Middleman::S3Sync.add_caching_policy('text/plain', { max_age: 0, public: true, must_revalidate: true })
        ::Middleman::S3Sync.add_caching_policy('text/html', { max_age: 0, public: true, must_revalidate: true })
      end
  end
end