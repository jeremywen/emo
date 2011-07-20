require 'sinatra'
require 'pathname'


get "/" do
  @links = Dir["public/files/*.*"].map { |file|
    file_link(file[7,file.length])
  }.join
  erb :index
end

helpers do

  def file_link(file)
    filename = Pathname.new(file).basename
    "<li><a href='#{file}' target='_self'>#{filename}</a></li>"
  end

end
