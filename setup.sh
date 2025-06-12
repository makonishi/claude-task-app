#!/bin/bash

# Railsアプリケーションを生成
rails new . --force --database=postgresql

# database.ymlを設定
cat > config/database.yml <<EOL
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("DATABASE_HOST", "localhost") %>
  username: <%= ENV.fetch("DATABASE_USER", "postgres") %>
  password: <%= ENV.fetch("DATABASE_PASSWORD", "") %>

development:
  <<: *default
  database: task_manager_development

test:
  <<: *default
  database: task_manager_test

production:
  <<: *default
  database: task_manager_production
  username: task_manager
  password: <%= ENV["TASK_MANAGER_DATABASE_PASSWORD"] %>
EOL

# データベースを作成
rails db:create

# タスク管理機能のscaffoldを生成
rails generate scaffold Task title:string description:text status:string priority:integer due_date:date

# マイグレーション実行
rails db:migrate

echo "Setup completed!"