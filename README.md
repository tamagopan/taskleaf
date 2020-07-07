# README

# task管理ツールを作る
## 環境構築
* ruby v2.5.1
* rails 5.2.1
* Postgre SQL 12.3

## 7/4~5 雛形の作成
### 3-1.雛形作成
#### 雛形作成
DBを指定して、rails new

```ruby
$ rails new taskleaf -d postgresql
```

#### DBを作成

```ruby
$ bin/rails db:create
```

=> サーバの起動を確認

#### slimの導入

```ruby:Gemfile
gem 'slim-rails'
gem 'html2slim'
```

Gemfile編集後、

```
$ bundle install
```

レイアウトテンプレートをerbからslimに変更
```
$ bundle exec erb2slim app/view/layouts/ --delete
```

#### Bootstrap、scssの導入

```ruby:Gemfile
gem 'bootstrap'
```

Gemfile編集後、

```
$ bundle install
```

app/assets/stylesheets/application.cssを削除し、
app/assets/stylesheets/application.scssを作成

```
$ rm app/assets/stylesheets/application.css
$ touch app/assets/stylesheets/application.scss
```

app/assets/stylesheets/application.scssでbootstrapをimport

```scss:app/assets/stylesheets/application.scss
@import "bootstrap"
```

#### 日本語翻訳ファイルのダウンロード
エラーメッセージを日本語化するために、日本語翻訳ファイルをダウンロード

```
$ wget https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/local/ja.yml --output-document=config/locales/ja.yml
$ touch config/initializers/locale.rb
```

デフォルトで日本語を使用するように設定

```ruby:config/initializers/locale.rb
Rails.application.config.118n.default_locale = :ja
```

### 3-2.タスクモデルの作成
#### Taskモデルの作成
Taskモデルの作成

```
$ bin/rails g model Task name:string description:string
$ bin/rails db:migrate
```

tasksコントローラーの作成

```
bin/rails g controller tasks index show get edit
```
ルーティングを書き換える
```ruby:config/route.rb
- get 'tasks/index'
- get 'tasks/show'
- get 'tasks/new'
- get 'tasks/edit'
+ root to: 'tasks#index'
+ resources :tasks
```

ひとまず、ここまで。
