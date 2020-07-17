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
$ bin/rails g controller tasks index show get edit
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

あとは、つまづいたところだけめも。

#### chapter 5-9
specが実行できない
```
$ bundle exec rspec spec/system/tasks_spec.rb
```
を実行したところ、エラー
```
Selenium::WebDriver::Error::SessionNotCreatedError:
   session not created
   from disconnected: unable to connect to renderer
     (Session info: headless chrome=84.0.4147.89)
```
まず、chromedriver-helperがサポート終了しているので、webdriverを使う。
[サポートが終了したchromedriver-helperからwebdrivers gemに移行する手順](https://qiita.com/jnchito/items/f9c3be449fd164176efa)
もしくは、
[RSpecでchromedriverとChromeのバージョンが合わない](https://qiita.com/sakakinn/items/dc5d588df87c054554be)

次に、chromeとchromedriverのバージョンを合わせる。
chromedriverの場所
```
$ which chromedriver
>>> /usr/local/bin/chromedriver
$ /usr/local/bin/chromedriver -v
>>> ChromeDriver 83.0.4103.39
```
chromeのバージョンが84だったので、ChromeDriverをupdateする
ここも1つ注意で、chromedriverが`homebrew/core`ではなく`homebrew/cask`にあるらしいので、
```
$ brew cask install chromedriver
$ /usr/local/bin/chromedriver -v
>>> ChromeDriver 84.0.4147.30
```
で、解決。
で、specを実行すると、
```
Capybara::ElementNotFound:
  Unable to find field "メールアドレス" that is not disabled
```
メールアドレスなんてfieldがないよと言われるので、こちらで解決。
[【RSpec/capybara】fill_inが上手く動作しない](https://qiita.com/Takara1356/items/cc8535c4a6e66c5977e2)
