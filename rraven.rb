require File.dirname(__FILE__)+"/config/config.rb"  #Include Config File
require File.dirname(__FILE__)+"/src/func_print.rb"  #Include Config File

system("clear")
# banner()

if(ARGV[0] == "-u" or ARGV[0] == "--update")
  puts ":: Update ::"
  puts "[+] Update Recon-Raven".green
  Dir.chdir(File.dirname(__FILE__))
  system("git pull -v")
  puts "[+} Updated Recon-Raven".red

else if(ARGV[0] == "-h" or ARGV[0] == "--help")
  help()
  exit()

else if(ARGV[0] == "-v" or ARGV[0] == "--version")
  puts "[+] version is v"+$version
  exit()
  
else if(ARGV.size > 1)
  #help_short()
  exit()

else  # Main Start . Interactive Shell

