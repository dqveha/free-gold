require 'sinatra'
require 'sinatra/reloader'
require('./lib/album')
require('./lib/song')
also_reload 'lib/**/*.rb'
require 'pry'

get('/') do
  @albums = Album.all
  @sold_albums = Album.sold_all()
  @albums = Album.alphabet()
  erb(:albums)
end

# get('/') do
#   "This will be our home page. '/' is always the root route in a Sinatra application."
# end

get('/albums') do
  @albums = Album.all
  @sold_albums = Album.sold_all()
  @albums = Album.alphabet()
  erb(:albums)
end

# get('/albums') do
#   "This route will show a list of all albums."
# end

post('/albums') do
  name = params[:album_name]
  album = Album.new(name, nil)
  album.save() # saves into class variable (@@albums)
  @albums = Album.all()
  @sold_albums = Album.sold_all()
  @albums = Album.alphabet()
  erb(:albums)
end

# post('/albums') do
#   "This route will add an album to our list of albums. We can't access this by typing in the URL. In a future lesson, we will use a form that specifies a POST action to reach this route."
# end

get('/albums/new') do
  erb(:new_album)
end

# get('/albums/new') do
#   "This will take us to a page with a form for adding a new album."
# end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

# get('/albums/:id') do
#   "This route will show a specific album based on its ID. The value of ID here is #{params[:id]}."
# end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

post('/albums/:id/buy') do
  @album = Album.find(params[:id].to_i())
  @album.sold()
  redirect to ('/albums')
end

# get('/albums/:id/edit') do
#   "This will take us to a page with a form for updating an album with an ID of #{params[:id]}."
# end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

# patch('/albums/:id') do
#   "This route will update an album. We can't reach it with a URL. In a future lesson, we will use a form that specifies a PATCH action to reach this route."
# end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

# delete('/albums/:id') do
#   "This route will delete an album. We can't reach it with a URL. In a future lesson, we will use a delete button that specifies a DELETE action to reach this route."
# end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

# get('/custom_route') do
#   "We can even create custom routes, but we should only do this when needed."
# end

post('/albums/search') do
  @what = Album.search(params[:search])
  erb(:search)
end

# to search stuff.. I guess it needs to show up as post..