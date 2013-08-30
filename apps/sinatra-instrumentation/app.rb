require 'sinatra'

get '/' do
  busy = params.delete('busy').to_f
  response_size = params.delete('response_size').to_i

  raise "Unrecognized params: #{params.keys}" unless params.empty?

  # allocate memory
  buffer = '0' * response_size

  later = (Time.now + busy)
  until Time.now > later
  end

  buffer
end

get '/busy/:busy/size/:response_size' do |busy, response_size|
  busy = busy.to_f
  response_size = response_size.to_i

  # allocate memory
  buffer = '0' * response_size

  later = (Time.now + busy)
  until Time.now > later
  end

  buffer
end
