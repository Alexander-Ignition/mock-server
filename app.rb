# README: https://github.com/sinatra/sinatra/blob/master/README.ru.md
require 'sinatra'
require 'JSON'

enable :sessions
set :session_secret, 'super secret'

helpers do
  def authenticate!
    unless session[:user_id] == user_id
      halt 403, JSON.generate(error: 'invalid_credentials', description: 'ой ой')
    end
  end

  def user_id
    '1234'
  end
end

before '/api/*' do
  content_type :json
  authenticate! unless params[:splat] == ['login']
end

post '/api/login' do
  data = JSON.parse request.body.read
  email = data['email']
  password = data['password']

  if email == 's@ss.ru' && password == 'demo'
    session[:user_id] = user_id
    status 200
    File.read('./resource/user.json')
  else
    status 403
    JSON.generate(error: 'invalid_credentials', description: 'упс')
  end
end

post '/api/logout' do
  session[:user_id] == nil
end

get '/api/materials' do
  JSON.generate(materials: [1, 2])
end
