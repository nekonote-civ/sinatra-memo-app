# frozen_string_literal: true

require 'sinatra'
require 'json'

BASE_STATIC_PATH = './public/'
JSON_PATH = "#{BASE_STATIC_PATH}json/"

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
      json = JSON.load(open_file)
      {
        :id => file.split('.json')[0],
        :title => json['title'],
        :content => json['content']
      }
    end
  end
end

def read_json_contents(memo_id)
  full_path = full_json_path("#{memo_id}.json")
  return unless File.exist?(full_path)

  File.open(full_path) do |open_file|
    json = JSON.load(open_file)
    {
      :id => memo_id,
      :title => json['title'],
      :content => json['content']
    }
  end
end

# メモ一覧画面
get '/memos' do
  @contents = read_all_json_contents
  erb :memos
end

# メモ追加画面
get '/memos/new' do
  erb :new
end

# メモ表示画面
get '/memos/:memo_id' do
  @contents = read_json_contents(params['memo_id'].to_s)
  erb :memo
end

# メモ編集画面
get '/edit/:memo_id' do
  erb :edit
end