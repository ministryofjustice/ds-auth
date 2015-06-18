# To compile assets and push them to S3, run "bundle exec rake assets:sync".
# Note that this will only work from an AWS instance that is part of the
# correct IAM role.
AssetSync.configure do |config|
  config.fog_provider = "AWS"

  # We use Instance roles rather than specifying an AWS access Key and secret
  config.aws_iam_roles = true

  # We don't want to sync every time we precompile assets - only on-demand
  config.run_on_precompile = false

  # Bucket name
  config.fog_directory = Settings.aws.s3_asset_bucket_name

  # Increase upload performance by configuring your region
  config.fog_region = Settings.aws.region

  # Don't delete files from the store
  config.existing_remote_files = "keep"
end
