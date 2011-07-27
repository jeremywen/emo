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
  haml :emo
end

get "/emo/chars" do  
  @emos = possible_chars()
  haml :emo
end


#######################################
# Helpers
#######################################
helpers do

  def max_emos()
    1300
  end
  
  def gen_emo(x)
    @chars = possible_chars()
    emo_array = []
	x = [x,max_emos()].min
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
  
  def possible_chars()
    File.readlines("possible_chars.txt")
  end
  
  def rnd_char()
    @chars[rand(@chars.size)].chomp
  end
  
end
