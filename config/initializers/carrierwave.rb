require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production? # 本番環境:AWS使用
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_access_key_id,    # secrets.ymlの設定内容を呼び出す(「aws_access_key_id」が、secrets.ymlで設定した「aws_access_key_id」の値という意味)
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region: 'ap-northeast-1'    # アジアパシフィック（東京）を指定
    }

    config.fog_directory  = 'mycanvas2020'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/mycanvas2020'
  else
    config.storage :file # 開発環境:public/uploades下に保存
    config.enable_processing = false if Rails.env.test? #test:処理をスキップ
  end
end