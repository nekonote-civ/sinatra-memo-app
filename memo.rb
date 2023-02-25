# frozen_string_literal: true

require 'sinatra'
require 'json'

BASE_STATIC_PATH = './public/'

def read_files
  base_path = "#{BASE_STATIC_PATH}/json/"
  Dir.glob('*.json', base: base_path)
end

def read_all_json_contents
  files = read_files
  files.map do |file|
    full_path = "#{base_path}#{file}"
    File.open(full_path) { |open_file| JSON.load(open_file) }
  end
end

def read_json_contents(memo_id)
  files = read_files
  files.each do |file|
    full_path = "#{base_path}#{file}"
    result_file = File.open(full_path) do |open_file|
      json = JSON.load(open_file)
      json if json['id'] == memo_id
    end
    return result_file if result_file
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
  @contents = read_json_contents(params['memo_id'])
  erb :memo
end

# メモ編集画面
get '/edit/:memo_id' do
  erb :edit
end