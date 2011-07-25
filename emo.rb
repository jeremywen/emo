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
      emo_array << "#{outter+inner+outter}"
    } 
    emo_array
  end
  
  def rnd_char()
    @chars[rand(@chars.size)].chomp
  end
  
end
