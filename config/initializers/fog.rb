CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Setting.aws.access_key_id,
    :aws_secret_access_key  => Setting.aws.secret_access_key,
    :region                 => 'ap-northeast-1',
  }
  config.fog_directory  = Setting.s3.bucket
end
