class Raven
  def initialize
    @raven_target_domain = '' # test domain
    @raven_target_ip = ''
    @raven_level = 1
    @raven_thread = 1
    @raven_verbose = 0 # verbose mode
    # level 1 : subdomain check,
    # level 2 : level 1 + port scan
    # level 3 : level 2 + ???
    @raven_options = { 'wordlist' => nil,
                       '' => nil }
    @raven_subdomains = []
    @raven_report = { 'subdomain' => '' }
  end

  def set_level(level)
    @raven_level = level
  end

  def set_thread(n)
    @raven_thread = n
  end

  def set_target(target)
    r = Socket.gethostbyname(target)
    @raven_target_domain = target
    @raven_target_ip = r[3].unpack('CCCC').join('.')
  end

  def set_ip(ip)
    @raven_target_ip = ip
  end

  def scan_port
    # TODO: // check subdomain , etc...

    sock = TCPSocket.new(@raven_target_domain, '80')
    rputs "#{port} open." if sock
  rescue StandardError => ex
    p ex unless ex.is_a?(Errno::ECONNREFUSED)
  ensure
    sock.close if sock
  end

  def scan_subdomain # scan subdomain &  takeover
    rputs '[+] Subdomain Discovery & TakeOver Vulnerability'
    threads = []
    pattern_sites = { "createsend": 'https://www.zendesk.com/',
                      "cargocollective": 'https://cargocollective.com/',
                      "cloudfront": 'https://aws.amazon.com/cloudfront/',
                      "desk.com": 'https://www.desk.com/',
                      "fastly.net": 'https://www.fastly.com/',
                      "feedpress.me": 'https://feed.press/',
                      "freshdesk.com": 'https://freshdesk.com/',
                      "ghost.io": 'https://ghost.org/',
                      "github.io": 'https://pages.github.com/',
                      "helpjuice.com": 'https://helpjuice.com/',
                      "helpscoutdocs.com": 'https://www.helpscout.net/',
                      "herokudns.com": 'https://www.heroku.com/',
                      "herokussl.com": 'https://www.heroku.com/',
                      "herokuapp.com": 'https://www.heroku.com/',
                      "pageserve.co": 'https://instapage.com/',
                      "pingdom.com": 'https://www.pingdom.com/',
                      "amazonaws.com": 'https://aws.amazon.com/s3/',
                      "myshopify.com": 'https://www.shopify.com/',
                      "stspg-customer.com": 'https://www.statuspage.io/',
                      "sgizmo.com": 'https://www.surveygizmo.com/',
                      "surveygizmo.eu": 'https://www.surveygizmo.com//',
                      "sgizmoca.com": 'https://www.surveygizmo.com/',
                      "teamwork.com": 'https://www.teamwork.com/',
                      "tictail.com": 'https://tictail.com/',
                      "domains.tumblr.com": 'https://www.tumblr.com/',
                      "unbouncepages.com": 'https://unbounce.com/',
                      "uservoice.com": 'https://www.uservoice.com/',
                      "wpengine.com": 'https://wpengine.com/',
                      "bitbucket": 'https://bitbucket.org/',
                      "squarespace.com": 'https://www.squarespace.com/',
                      "unbounce.com": 'https://unbounce.com/',
                      "zendesk.com": 'https://www.zendesk.com/' }

    pattern_response = ['<strong>Trying to access your account',
                        'Use a personal domain name',
                        'The request could not be satisfied',
                        "Sorry, We Couldn't Find That Page",
                        'Fastly error: unknown domain',
                        'The feed has not been found',
                        'You can claim it now at',
                        'Publishing platform',
                        "There isn't a GitHub Pages site here",
                        '<title>No such app</title>',
                        'No settings were found for this company',
                        '<title>No such app</title>',
                        "You've Discovered A Missing Link. Our Apologies!",
                        'Sorry, couldn&rsquo;t find the status page',
                        'NoSuchBucket',
                        'Sorry, this shop is currently unavailable',
                        '<title>Hosted Status Pages for Your Company</title>',
                        'data-html-name="Header Logo Link"',
                        "<title>Oops - We didn't find your site.</title>",
                        'class="MarketplaceHeader__tictailLogo"',
                        "Whatever you were looking for doesn't currently exist at this address",
                        'The requested URL was not found on this server',
                        'The page you have requested does not exist',
                        'This UserVoice subdomain is currently available!',
                        'but is not configured for an account on our platform',
                        '<title>Help Center Closed | Zendesk</title>']
    i = 0
    wordlist = File.open(File.dirname(__FILE__) + '/../data/wordlist.txt', 'r').readlines
    max = wordlist.size
    wordlist.each do |sub|
      begin
        line = sub.chomp!
        # rputs "#{line}.#{@raven_target_domain}"
        tmp_domain = ''
        tmp_ip = ''
        tmp_ping = ''
        tmp_cname = ''
        tmp_site = ''
        tmp_takeover = ''
        result = Socket.gethostbyname("#{line}.#{@raven_target_domain}")
        ip = result[3].unpack('CCCC').join('.')
        reverse = Socket.gethostbyaddr(ip)
        rputs "[+] #{line}.#{@raven_target_domain}\t#{ip}\t#{reverse[0]}".colorize(:green)
        tmp_domain = "#{line}.#{@raven_target_domain}"
        tmp_ip = ip
        p = Net::Ping::External.new("#{line}.#{@raven_target_domain}")
        if p.ping?
          rputs '  - PING: OK'
          tmp_ping = true
        else
          rputs '  - PING: FAIL'
          tmp_ping = false
        end
        begin # Sub domain takeover check
          r = Resolv::DNS.open do |dns|
            dns.getresource("#{line}.#{@raven_target_domain}", Resolv::DNS::Resource::IN::CNAME)
          end
          rputs '  - CNAME: ' + r.name.to_s
          tmp_cname = r.name.to_s
          pattern_site.each do |site|
            next unless r.name.to_s.include? site[0]
            rputs ' - SITE: ' + site[0]
            tmp_site = site[0]
            uri = URI(site[0]) # check url
            pattern_response.each do |res|
              result = Net::HTTP.get(uri)
              if res.include? res
                rputs ' - TAKEOVER' + uri
                tmp_takeover = uri
              end
            end
          end
          @raven_subdomains.push [tmp_domain, tmp_ip, tmp_ping, tmp_cname, tmp_site, tmp_takeover]
        rescue StandardError
          # handle error
        end
      rescue StandardError # SocketError => e
        # not found
        # rputs "a"
      end
      print_state(i, max.to_i, "Scanning subdomain - #{sub}.#{@raven_target_domain}")
      i += 1
    end
  end
end
