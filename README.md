# sinatra-memo-app

フィヨルドブートキャンプのRubyプラクティス課題である Sinatra を使用した簡易メモアプリのリポジトリです。

## How To Use

以下の作業は全てルートディレクトリで実施します。

1. 必要な `gem` をインストールするために `bundle install` を実行してください。

    ```sh
    $ bundle install
    ```

2. 必要なデータベースを構築するため、下記のシェルスクリプトを実行してください。

    ```sh
    $ ./init/init.sh
    ```
   - `postgresql` がインストールされていない場合は下記リンク等を参照して導入してください。  
    https://wiki.postgresql.org/wiki/Apt

   - デフォルトの `postgres` データベースを削除している場合はエラーが発生する可能性があります。  
   `postgres` データベースを作成する、もしくは `init/init.sh` 内の `postgres` を自身の利用可能なデータベース名へ変更してください。

     ```sh
     # ロールとデータベースの作成
     psql -f ./init/create_role_and_database.sql -d postgres
     ```

3. アプリケーションを立ち上げるためには `bundle exec` を実行してください。

    ```sh
    $ bundle exec ruby memo.rb
    ```

4. アプリケーションが起動したら `http://localhost:4567/memos` へアクセスし、画面が表示出来たら完了です。
