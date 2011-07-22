# bookmarklet to paste emo into imo chat
# center vertically in box
# make the chars larger
# need a rating system for emo, too many bad ones
# and the middle char should not be the same as the outer ones
# rating system based on happiness-sadness-angryness. people categorize each one to be, store it, and put them in order, color them, and have a mood scale, maybe a separate mood-ring page
# infinite scroll to keep it from running out of memory on large numbers


require 'sinatra'
require 'pathname'
require "erb"
include ERB::Util
  
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
    emoArray = []
    chars = File.readlines("possible_chars.txt")
    x.times { |ch|
      outter = chars[rand(chars.size)].chomp
      inner = chars[rand(chars.size)].chomp
      emoArray << "#{html_escape(outter+inner+outter)}"
    } 
    emoArray
  end

end
