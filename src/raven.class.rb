class Raven
  def initialize()
     @raven_target_domain= "hahwul.com"  # test domain
     @raven_target_ip = ""
     @raven_level = 1
     @raven_verbose = 0  #verbose mode
     # level 1 : subdomain check,
     # level 2 : level 1 + port scan
     # level 3 : level 2 + ???
     @raven_options = {"wordlist" => nil,
                       ""=>nil
                      }
  end

  def set_level(level)  
     @raven_level = level
  end
  def set_target(target)
     r = Socket.gethostbyname(target)
     @raven_target_domain = target
     @raven_target_ip = r[3].unpack("CCCC").join(".")
  end
  def set_ip(ip)
     @raven_target_ip = ip
  end

  def scan_subdomain()  # scan subdomain &  takeover
    threads = []
    File.open("./data/wordlist.txt","r").each_line do |sub|
      begin
        line = sub.chomp!
        #puts "#{line}.#{@raven_target_domain}"
        result = Socket.gethostbyname("#{line}.#{@raven_target_domain}")
        ip = result[3].unpack("CCCC").join(".")
        reverse = Socket.gethostbyaddr(ip)
        puts "[+] #{line}.#{@raven_target_domain}\t#{ip}\t#{reverse[0]}"
        begin
          r = Resolv::DNS.open do |dns|
            dns.getresource("#{line}.#{@raven_target_domain}", Resolv::DNS::Resource::IN::CNAME)
          end
          puts  "  - "+r.name.to_s
        rescue
          #handle error
        end
      rescue #SocketError => e
         # not found
         # puts "a"
      end
    end
  end
end
