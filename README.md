# Summary
- 基本のCRUD機能の学習。
- 新規事業開発において、ビジネスモデルの妥当性検証の共有を目的として、ビジネスモデルキャンバス管理アプリを作成しました。

# 開発環境
- MacOS Catarina10.15.7
- フロント
  - HTML（haml）
  - CSS3（SCSS）
  - Javascipt（Jquery）
- バック
  - Ruby2.5.1
  - Rails5.0.7
  - MySQL
  - nginx、unicorn

# ブラウザでのアクセス
http://13.112.125.237/

## 学習の記録（Qiita）
- [【Rails】SNS認証の登録手順(Twitter、Facebook、google)](https://qiita.com/manbolila/items/8caa1f5d2b1fb96d2646)
- [【Rails】SNS認証(Twitter、Facebook、google)](https://qiita.com/manbolila/items/48d361fd5968179918c3)
- [【Rails】お気に入り機能](https://qiita.com/manbolila/items/43a04e8d0d5018cf7f62)
- [【Rails】コメント機能（登録・表示・削除）](https://qiita.com/manbolila/items/84739af7a73acd33f067)
- [【Rails】タグ管理機能(acts-as-taggable-on使用)](https://qiita.com/manbolila/items/3f178b7698d877a29b12)

# Functions
- ユーザー新規登録・ログイン/ログアウト機能・SNS連携
- マイページ機能
- キャンバス作成・編集・削除機能
  - コメント、いいね！機能
  - タグ付け機能
  - 複数画像投稿機能
  - Markdown記法によるメモ投稿機能

# Demo
## ユーザー新規登録・ログイン機能
- メールアドレス、Facebook、Twitter、Google認証によるユーザー登録が可能。
  - SNS認証は、ローカル環境のみ。
<img src="https://gyazo.com/03bf5f1a72d009c8193f2bb11ca0c6a9/raw" width="450px">

## キャンバス作成・編集・削除機能
- ログイン中ユーザーのみが可能。
- キャンバス作成・編集時に、タグ付け登録が可能。
  - トップページに、登録数順に、タグ一覧表示。
  - タグをクリックすると、紐づくキャンバス一覧を表示できる。
- キャンバス作成・編集時に、0~5枚までの画像を投稿可能。
<img src="https://gyazo.com/470d2d21432a2c07e1dd6fc7063832ba/raw" width="450px">

- 詳細表示ページにて、コメント投稿・削除が可能。
<img src="https://gyazo.com/2ab0ccdb527838c36fb5a355cad00d0a/raw" width="450px">

- 投稿者以外のユーザーは、いいね！登録・削除が可能。
  - いいね！登録済のキャンバスは、マイページにて一覧表示。
<img src="https://gyazo.com/f9268e2b7105a31bd52c03942fd9015e/raw" width="450px">

# ER diagram
<img src="https://gyazo.com/f5e47e5a55d0c55e15633054af5e0770/raw" width="900px">

## users table
|Column|Type|Options|
|------|----|-------|
|name|string|null:false|
|password|string|null:false|
|email|string|null:false, unique: true, index:true|

### Association
- has_many :posts
- has_many :comments, dependent: :destroy
- has_many :favorites, dependent: :destroy
- has_many :sns_credentials


## sns_credentials table
|Column|Type|Options|
|------|----|-------|
|provider|string|null: false|
|uid|string|null: false, unique: true|
|user|references|null: false, foreign_key: true|

### Association
- belongs_to :user, optional: true


## posts table
|Column|Type|Options|
|------|----|-------|
|problem|text||
|existing|text||
|solution|text||
|metics|text||
|value|text||
|advantage|text||
|channel|text||
|customer|text||
|cost|text||
|revenue|text||
|note|text||
|purpose|text||
|vision|text||
|user|references|null: false, foreign_key: true|

### Association
- belongs_to :user
- has_many :comments, dependent: :destroy
- has_many :favorites
- has_many :imgs, dependent: :destroy


## imgs table
|Column|Type|Options|
|------|----|-------|
|src|string|null:false|
|post|references|null: false, foreign_key: true|

### Association
- belongs_to :post


## favorites table
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|post|references|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post


## comments table
|Column|Type|Options|
|------|----|-------|
|comment|text|null: false|
|user|references|null: false, foreign_key: true|
|post|references|null: false, foreign_key: true|

### Association
- belongs_to :user
- belongs_to :post

## tags table
|Column|Type|Options|
|------|----|-------|
|name|string||
|taggings_count|integer||

### Association
- acts-as-taggable-on(gem)を使用。

## taggings table
- acts-as-taggable-on(gem)を使用。
