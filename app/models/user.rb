class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]
  
  # omniauthのコールバック時に呼ばれるメソッド
  def self.from_omniauth(auth)
    # 指定条件で検索してなければ、Sns_credentialsテーブルにレコード作成
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create

    # userテーブルに登録済みか？(Sns_credentialsテーブルのuser_idカラムが空か？ or userテーブルにメールアドレスが登録済みか？)
    user = sns.user || User.where(email: auth.info.email).first_or_initialize(
      name: auth.info.name,
      email: auth.info.email
    )
    # userテーブルに登録済みの場合：そのままログインするため、snsテーブルのuser_idカラムを保存
    if user.persisted?
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
  end

  has_many :posts
  has_many :comments
  has_many :favorites
  has_many :sns_credentials
end
