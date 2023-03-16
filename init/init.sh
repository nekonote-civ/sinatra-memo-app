#!/bin/zsh

# ロールとデータベースの作成
psql -f ./init/create_role_and_database.sql -d postgres

# テーブルの作成とロールの変更
psql -f ./init/create_table_and_change_role.sql -d memo_app

echo "Done."
