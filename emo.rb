# show midi pattern squares - by generating short midi files
# show audio pattern squares - by generating short audio files
# show beats gem pattern squares - by generating text for the beats gem
# show smiley image squares
# bookmarklet to paste emo into imo chat
# need a rating system for emo, too many bad ones
# and the middle char should not be the same as the outer ones
# rating system based on happiness-sadness-angryness. 
# categorize each one to be, store it, and put them in order, color them
# infinite scroll to keep it from running out of memory on large numbers


require 'sinatra'
require 'pathname'
require "erb"
include ERB::Util
  
get "/?" do
  redirect "/emo/#{max_emos()}"
end

get "/emo/?" do
  redirect "/emo/#{max_emos()}"
end

get "/emo/:times/?" do 
  x = params[:times].to_i
  if x > max_emos()
    redirect "/emo/#{max_emos()}"
  end
  @emos = gen_emo(x)
  erb :emo
end

helpers do

  def max_emos()
    1300
  end
  
  def gen_emo(x)
    emo_array = []
    @chars = File.readlines("possible_chars.txt")
	x = [x,max_emos()].min
    x.times { |ch|
      outter = rnd_char()
	  inner = rnd_char()
	  while outter.eql?(inner)
        inner = rnd_char()
	  end
      emo_array << "#{html_escape(outter+inner+outter)}"
    } 
    emo_array
  end
  
  def rnd_char()
    @chars[rand(@chars.size)].chomp
  end
  
end
