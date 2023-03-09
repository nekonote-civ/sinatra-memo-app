# frozen_string_literal: true

require 'sinatra'
require 'securerandom'
require 'pg'

class Memo
  def initialize
    @connection = PG.connect(dbname: 'memo_app')
  end

  def select_all_contents
    @connection.exec('select id, title, content from memos')
  end

  def select_contents(id)
    @connection.exec_params('select id, title, content from memos where id = $1', [id])
  end

  def create_contents(title, content)
    @connection.exec_params('insert into memos(id, title, content) values(gen_random_uuid(), $1, $2)', [title, content])
  end

  def update_contents(title, content, id)
    @connection.exec_params('update memos set title = $1, content = $2 where id = $3', [title, content, id])
  end

  def delete_contents(id)
    @connection.exec_params('delete from memos where id = $1', [id])
  end
end

memo = Memo.new

# メモ一覧画面
get '/memos' do
  @title = 'トップページ'
  @page = 'memos'
  @contents = memo.select_all_contents
  erb :memos
end

# メモ登録
post '/memos' do
  memo.create_contents(params[:title], params[:content])
  redirect '/memos'
end

# メモ更新
patch '/memos/:memo_id' do
  memo.update_contents(params[:title], params[:content], params[:memo_id])
  redirect '/memos'
end

# メモ削除
delete '/memos/:memo_id' do
  memo.delete_contents(params[:memo_id])
  redirect '/memos'
end

# メモ登録画面
get '/memos/new' do
  @title = 'メモ登録ページ'
  @page = 'new'
  erb :edit
end

# メモ表示画面
get '/memos/:memo_id' do
  @title = '個別メモページ'
  @page = 'memo'
  @contents = memo.select_contents(params['memo_id'])
  redirect not_found if @contents.ntuples.zero?
  @contents = @contents[0]
  erb :memo
end

# メモ編集画面
get '/memos/edit/:memo_id' do
  @title = 'メモ編集ページ'
  @page = 'edit'
  @contents = memo.select_contents(params['memo_id'])
  redirect not_found if @contents.ntuples.zero?
  @contents = @contents[0]
  erb :edit
end

# 404 Not Found
not_found do
  @title = '404 Not Found'
  erb :not_found
end
