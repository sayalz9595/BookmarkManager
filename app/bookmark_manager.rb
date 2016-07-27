ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'Bookmark Secret'

  get '/links' do
    @links = Link.all
    erb(:'/links/index')
  end

  get '/links/new' do
    erb(:'links/new')
  end

  post '/links' do
    link = Link.create(:title => params[:title], :url => params[:url])
    params[:tags].split(/[\s,]+/).each do |tag|
      link.tags << Tag.first_or_create(:name => tag)
    end
    link.save
    redirect '/links'
  end

   get '/tags/:name' do
     tag = Tag.first(name: params[:name])
     @links = tag ? tag.links : []
     erb :'links/index'
   end

   get '/signup' do
     erb :'users/signup'
   end

   post '/signup' do
     user = User.create(:first_name => params[:first_name], :last_name => params[:last_name], :email => params[:email], :password => params[:password])
     session[:name] = user[:first_name]
     user.save
     redirect '/welcome'
   end

   get '/welcome' do
     @user = session[:name]
     erb :'users/welcome'
   end


  # start the server if ruby file executed directly
  run! if app_file == $0
end