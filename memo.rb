# frozen_string_literal: true

require 'sinatra'
require 'json'

BASE_STATIC_PATH = './public/'

def read_json_contents
  base_path = "#{BASE_STATIC_PATH}/json/"
  files = Dir.glob('*.json', base: base_path)
  files.map do |file|
    full_path = "#{base_path}#{file}"
    File.open(full_path) { |open_file| JSON.load(open_file) }
  end
end

# メモ一覧画面
get '/memos' do
  @contents = read_json_contents
  erb :memos
end

# メモ追加画面
get '/memos/new' do
  erb :new
end

# メモ表示画面
get '/memos/:memo_id' do
  erb :show
end

# メモ編集画面
get '/edit/:memo_id' do
  erb :edit
end