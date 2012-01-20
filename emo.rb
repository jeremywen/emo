# IDEAS
# -------------------
# maybe just simple up/down arrow buttons for ranking
# ajax click options at the top
# option to separate what can be eyes, what can be noses
# bookmarklet to paste emo into imo chat
# need a rating system for emo, too many bad ones
# rating system based on happiness-sadness-angryness. 
# categorize each one to be, store it, and put them in order, color them
# infinite scroll to keep it from running out of memory on large numbers
# rest option to return text only
#
# REFERENCE
# -------------------
# http://en.wikipedia.org/wiki/List_of_Unicode_characters
# http://www.copypastecharacter.com/

require 'sinatra'
require 'pathname'
require 'haml'
require "sinatra/reloader" if development?


#######################################################################################
# Settings
#######################################################################################
set :max_emos, 1300
set :possible_chars, File.readlines("possible_chars.txt")

configure do
  puts "[][][][][][][][][][][][][][][][][][][][][][]"
  puts "[][][][][][][][][][][][][][][][][][][][][][]" 
  puts "[][][][][][][][]EMO STARTED [][][][][][][][]"
  puts "[][][][][][][][][][][][][][][][][][][][][][]"
  puts "[][][][][][][][][][][][][][][][][][][][][][]"
  puts Time.now
  puts "settings.possible_chars.size() = " + settings.possible_chars.size().to_s
  puts "settings.max_emos" + settings.max_emos.to_s
end


#######################################################################################
# Routes
#######################################################################################
get "/emo/one/?" do  
  gen_emo(1)
end

get "/emo/chars/?" do  
  emo_array = []
  settings.possible_chars.each_with_index.map do |c,i|
    emo_array << "#{i.to_s}: #{c.to_s}"
  end
  
  @emos = emo_array
  haml :emo
end

get "/emo/:times/?" do 
  x = params[:times].to_i
  if x > settings.max_emos
    redirect "/emo/#{settings.max_emos}"
  end
  @emos = gen_emo(x)
  haml :emo
end

get "/emo/?" do
  redirect "/emo/#{settings.max_emos}"
end

get "/?" do
  redirect "/emo/#{settings.max_emos}"
end

#######################################################################################
# Helpers
#######################################################################################
helpers do

  def gen_emo(x)
    @chars = settings.possible_chars
    emo_array = []
	x = [x,settings.max_emos].min
    x.times { |ch|
      outter = rnd_char()
	  inner = rnd_char()
	  while outter.eql?(inner)
        inner = rnd_char()
	  end
      emo_array << "#{outter+inner+outter}"
    } 
    emo_array
  end
  
  def rnd_char()
    @chars[rand(@chars.size)].chomp
  end
  
end
