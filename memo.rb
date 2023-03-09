# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'

BASE_STATIC_PATH = './public/'
JSON_PATH = "#{BASE_STATIC_PATH}json/"

def full_json_path(file_name)
  "#{JSON_PATH}#{File.basename(file_name)}"
end

def read_json_files
  Dir.glob('*.json', base: JSON_PATH)
end

def read_all_json_contents
  read_json_files.map { |file| read_json(File.basename(file, '.json'), full_json_path(file)) }
end

def read_json_contents(id)
  full_path = full_json_path("#{id}.json")
  File.exist?(full_path) ? read_json(id, full_path) : nil
end

def read_json(id, path)
  json = JSON.parse(File.read(path))
  {
    id:,
    title: json['title'],
    content: json['content']
  }
end

def update_json_contents(id, title, content)
  File.open(full_json_path("#{id}.json"), 'w') do |file|
    json = {
      title:,
      content:
    }
    JSON.dump(json, file)
  end
end

def delete_json_contents(id)
  File.delete(full_json_path("#{id}.json"))
end

# メモ一覧画面
get '/memos' do
  @title = 'トップページ'
  @page = 'memos'
  @contents = read_all_json_contents
  erb :memos
end

# メモ登録
post '/memos' do
  update_json_contents(SecureRandom.uuid, params[:title], params[:content])
  redirect '/memos'
end

# メモ更新
patch '/memos/:memo_id' do
  update_json_contents(params[:memo_id], params[:title], params[:content])
  redirect '/memos'
end

# メモ削除
delete '/memos/:memo_id' do
  delete_json_contents(params[:memo_id])
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
  @contents = read_json_contents(params['memo_id'].to_s)
  redirect not_found unless @contents
  erb :memo
end

# メモ編集画面
get '/memos/edit/:memo_id' do
  @title = 'メモ編集ページ'
  @page = 'edit'
  @contents = read_json_contents(params['memo_id'].to_s)
  redirect not_found unless @contents
  erb :edit
end

# 404 Not Found
not_found do
  @title = '404 Not Found'
  erb :not_found
end
