require 'rubygems'
require 'sinatra'

class DeaDiag < Sinatra::Base
  get '/' do
    host = ENV['VCAP_APP_HOST']
    port = ENV['VCAP_APP_PORT']
    all = `env`
    "<h1>Hello from VCAP! via: #{host}:#{port}</h1><p>#{all}</p>"
  end

  get '/crash/:id' do
    ps = "kill -9 #{params[:id]}"
    Kernel.`ps
  end

  get '/cpu_benchmark' do
    start_time = Time.now
    1000.times { |n|
      Math.log(n)
    }
    elapsed_time = Time.now - start_time
    "<h1>#{elapsed_time}</h1>"
  end
end
