require 'sinatra'
require 'pathname'


get "/" do
  @links = Dir["public/files/*.*"].map { |file|
    file_link(file[7,file.length])
  }.join
  erb :index
end

get "/emo" do
  gen_emo(1000)
end

get "/emo/:times" do
  gen_emo(params[:times].to_i)
end

helpers do

  def file_link(file)
    filename = Pathname.new(file).basename
    "<li><a href='#{file}' target='_self'>#{filename}</a></li>"
  end

  def gen_emo(x)
    html="<html><body>"
    chars = File.readlines("possible_chars.txt")
    x.times { |ch|
      html+="<div style='font-family:Monospace;width:75px;float:left'><code>"
      outter = chars[rand(chars.size)].chomp
      inner = chars[rand(chars.size)].chomp
      html+=outter+inner+outter
      html+="</code></div>"
    } 
    html+="</body></html>"
  end

end
