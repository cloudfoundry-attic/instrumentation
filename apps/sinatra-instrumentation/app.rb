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

  if params.has_key?('short_response')
    buffer.size.to_s
  else
    buffer
  end
end
