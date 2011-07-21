require 'sinatra'
require 'pathname'


get "/" do
  @links = Dir["public/files/*.*"].map { |file|
    file_link(file[7,file.length])
  }.join
  erb :index
end

get "/emo" do
  @emos = gen_emo(1000)
  erb :emo
end

get "/emo/:times" do
  @emos = gen_emo(params[:times].to_i)
  erb :emo
end

helpers do

  def file_link(file)
    filename = Pathname.new(file).basename
    "<li><a href='#{file}' target='_self'>#{filename}</a></li>"
  end

  def gen_emo(x)
    html = ""
    chars = File.readlines("possible_chars.txt")
    x.times { |ch|
      html+="<div class='emo'><code>"
      outter = chars[rand(chars.size)].chomp
      inner = chars[rand(chars.size)].chomp
      html+=outter+inner+outter
      html+="</code></div>"
    } 
    html
  end

end
