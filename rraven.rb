require File.dirname(__FILE__) + '/config/config.rb'
require File.dirname(__FILE__) + '/src/func_print.rb'
require File.dirname(__FILE__) + '/src/func_util.rb'
require File.dirname(__FILE__) + '/src/raven.class.rb'

system('clear')
banner

if (ARGV[0] == '-u') || (ARGV[0] == '--update')
  puts ':: Update ::'
  puts '[+] Update Recon-Raven'.green
  Dir.chdir(File.dirname(__FILE__))
  system('git pull -v')
  puts '[+} Updated Recon-Raven'.red

else if (ARGV[0] == '-h') || (ARGV[0] == '--help')
       help
       exit

     else if (ARGV[0] == '-v') || (ARGV[0] == '--version')
            puts '[+] version is v' + $version
            exit

          else if ARGV.size > 1
                 # help_short()
                 exit

               else # [ Main ] Start
                 # - Interactive Shell
                 print_and_flush "\n -- Pre config\n"
                 $raven = Raven.new
                 # Qustion.
                 $raven.set_target(Ask.input('[?] Input target'.colorize(:light_blue)))
                 $raven.set_thread(Ask.input('[?] Number of thread [default 5]'.colorize(:light_blue)))
                 # TODO: . idx => list in raven class
                 idx = Ask.checkbox '[?] Select module  (space : check, enter : confirm)'.colorize(:light_blue), [
                   'All',
                   'subdomain discovery & takeover',
                   'portscan',
                   'directory & file bruteforce'
                 ]
                 puts idx

                 print "[+] Pre setting is complate, press 'enter' key for scanning .. ".colorize(:green)
                 gets.chomp
                 system('clear')
                 banner
                 puts ' -- Start scan'
                 $raven.scan_subdomain
  #  $raven.scan_nmap("localhost")

end # Main end
end # -v end
end # -h end
end
