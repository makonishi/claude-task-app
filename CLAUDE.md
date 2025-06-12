# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code) へのガイダンスを提供します。

## プロジェクト概要

Ruby on Rails 7.2.2で構築されたタスク管理Webアプリケーションです。優先度、ステータス、期限日などの機能を備えたタスクの基本的なCRUD操作を提供します。

## よく使う開発コマンド

### Docker環境（推奨）

```bash
# アプリケーションを起動
docker-compose up

# Railsコンソールを実行
docker-compose run web rails console

# データベースマイグレーションを実行
docker-compose run web rails db:migrate

# RSpecテストを実行
docker-compose run web bundle exec rspec

# 特定のspecファイルを実行
docker-compose run web bundle exec rspec spec/models/task_spec.rb

# 特定パターンのspecを実行
docker-compose run web bundle exec rspec spec/models/

# RuboCop（コードリンティング）を実行
docker-compose run web bundle exec rubocop

# Brakeman（セキュリティ分析）を実行
docker-compose run web bundle exec brakeman
```

### ローカル環境

```bash
# 初期セットアップ
bin/setup

# Railsサーバーを起動
bin/rails server

# Railsコンソールを実行
bin/rails console

# データベース操作
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# 全てのRSpecテストを実行
bundle exec rspec

# 特定のspecファイルを実行
bundle exec rspec spec/models/task_spec.rb

# ドキュメント形式でspecを実行
bundle exec rspec --format documentation
```

## アーキテクチャ

### プロジェクト構造

アプリケーションは標準的なRails MVCアーキテクチャに従っています：

- `app/controllers/tasks_controller.rb` - タスクのCRUD操作を処理
- `app/models/task.rb` - バリデーション付きのTaskモデル
- `app/views/tasks/` - タスクビュー用のERBテンプレート
- `config/routes.rb` - タスクリソースのRESTfulルート

### Taskモデルのスキーマ

```ruby
# db/schema.rb
create_table "tasks" do |t|
  t.string "title"
  t.text "description"
  t.string "status"
  t.integer "priority"
  t.date "due_date"
  t.timestamps
end
```

### Docker構成

アプリケーションは2つのサービスを持つDocker Composeを使用します：

- **web**: Railsアプリケーションコンテナ（ポート3000）
  - Ruby 3.3ベース
  - ホットリロード用に現在のディレクトリをマウント
  - 環境: development

- **db**: PostgreSQL 15コンテナ（ポート5432）
  - データベース: task_manager_development
  - ユーザー名: postgres
  - パスワード: password

### データベース設定

Dockerとローカル環境を切り替える際は、正しいデータベースホストを確認してください：
- Docker: `host: db`
- ローカル: `host: localhost`

## 開発時の注意事項

- プロジェクトはJavaScript管理にImport Mapsを使用（webpack/node_modulesなし）
- インタラクティブな機能にはHotwire（Turbo + Stimulus）が利用可能
- RSpecテストファイルは`spec/`に配置
- テストデータ生成にはFactory Botが利用可能
- Gemfileには環境切り替え時に調整が必要なプラットフォーム固有のgemが含まれる