ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base
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

  # start the server if ruby file executed directly
  run! if app_file == $0
end