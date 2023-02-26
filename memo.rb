# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'

BASE_STATIC_PATH = './public/'
JSON_PATH = "#{BASE_STATIC_PATH}json/".freeze

def full_json_path(file_name)
  "#{JSON_PATH}#{file_name}"
end

def read_json_files
  Dir.glob('*.json', base: JSON_PATH)
end

def read_all_json_contents
  files = read_json_files
  files.map do |file|
    full_path = full_json_path(file)
    File.open(full_path) do |open_file|
      json = JSON.parse(open_file.read)
      {
        id: file.split('.json')[0],
        title: json['title'],
        content: json['content']
      }
    end
  end
end

def read_json_contents(memo_id)
  full_path = full_json_path("#{memo_id}.json")
  return unless File.exist?(full_path)

  File.open(full_path) do |open_file|
    json = JSON.parse(open_file.read)
    {
      id: memo_id,
      title: json['title'],
      content: json['content']
    }
  end
end

def json_contents_update(id)
  full_path = full_json_path("#{id}.json")
  File.open(full_path, 'w') do |file|
    json = {
      title: params[:title],
      content: params[:content]
    }
    JSON.dump(json, file)
  end
end

def json_contents_delete(id)
  full_path = full_json_path("#{id}.json")
  File.delete(full_path)
end

# メモ一覧画面
get '/memos' do
  @contents = read_all_json_contents
  erb :memos
end

# メモ登録
post '/memos' do
  json_contents_update(SecureRandom.uuid)
  redirect '/memos'
end

# メモ更新
patch '/memos/:memo_id' do
  json_contents_update(params[:memo_id])
  redirect '/memos'
end

# メモ削除
delete '/memos/:memo_id' do
  json_contents_delete(params[:memo_id])
  redirect '/memos'
end

# メモ登録画面
get '/memos/new' do
  erb :edit
end

# メモ表示画面
get '/memos/:memo_id' do
  @contents = read_json_contents(params['memo_id'].to_s)
  redirect not_found unless @contents
  erb :memo
end

# メモ編集画面
get '/memos/edit/:memo_id' do
  @contents = read_json_contents(params['memo_id'].to_s)
  redirect not_found unless @contents
  erb :edit
end

# 404 Not Found
not_found do
  erb :not_found
end
