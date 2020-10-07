# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"   # capistranoのバージョンを固定

set :application, "my_canvas"  # Capistranoのログの表示用
set :repo_url, "git@github.com:manbo1123/myCanvas.git"    # どのリポジトリからアプリをpullするかを指定

# バージョンが変わっても共通で参照するディレクトリを指定
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'

# どの公開鍵を利用してデプロイするか( 公開キーの確認方法 .sshディレクトリで % ls )
set :ssh_options, auth_methods: ['publickey'], keys: ['~/.ssh/myCanvas.pem']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }        # プロセス番号を記載したファイルの場所
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }  # Unicornの設定ファイルの場所
set :keep_releases, 5

# デプロイ終了後、Unicornを再起動する記述
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
