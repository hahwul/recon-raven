def print_and_flush(str)
  print str
  $stdout.flush
end

def print_state(min,max,desc)
  percent = (min*100) / max
  state_format = "[ #{percent.to_s}% | #{min.to_s}/#{max.to_s}] #{desc}"
  print "\r                                                                "
  print "\r"+state_format
end

def rputs(str)
  print "\r                                                                "
  puts "\r"+str.to_s
end
