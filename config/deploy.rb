# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"   # capistranoのバージョンを固定

set :application, "myCanvas"  # Capistranoのログの表示用
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

set :linked_files, %w{ config/secrets.yml }   # secrets.yml用のシンボリックリンクを追加

# デプロイ終了後、Unicornを再起動する記述
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'upload secrets.yml'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
    end
  end
  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end
