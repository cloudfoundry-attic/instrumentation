while 0==0 do
  200.times do |num|
    index = 2000 + num
    name = "cfdiag-app-#{index}"
    url = "#{name}.elisabeth.cf-app.com/cpu_benchmark"
    starttime = Time.now
    result = `curl #{url} 2>&1`
    responsetime = Time.now - starttime
    time = result.match(/(\d+\.\d+)/).to_s
    puts "#{starttime} : #{name} : #{time} : downloaded in #{responsetime} seconds"
  end
end


