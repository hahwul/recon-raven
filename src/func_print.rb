def help
  puts 'Usage: ruby rraven.rb OPTION[-v, -h, -u]'
  puts 'run rraven'
  puts ' -#> ruby rraven.rb'
  puts 'update'
  puts ' -#> ruby rraven.rb -u'
  puts 'help'
  puts ' -#> ruby rraven.rb -h'
  puts 'version'
  puts ' -#> ruby rraven.rb -v'
end

def help_short
  # TODO...
end

def banner
  puts " :::::::..  .,::::::   .,-:::::     ...   :::.    :::.     :::::::..    :::.  :::      .::..,:::::::::.    :::.
 ;;;;``;;;; ;;;;'''' ,;;;'````'  .;;;;;;;.`;;;;,  `;;;     ;;;;``;;;;   ;;`;; ';;,   ,;;;' ;;;;''''`;;;;,  `;;;
 [[[,/[[['  [[cccc  [[[        ,[[      \[[,[[[[[. '[[      [[[,/[[['  ,[[ '  [[,\[[  .[[/    [[cccc   [[[[[. '[[
 $$$$$$c    $$\"\"\"\"  $$$        $$$,     $$$$$$ \"Y$c$$ cccc $$$$$$c     c$$$cc$$$cY$c.$$\"     $$\"\"\"\"   $$$ \"Y$c$$
 888b \"88bo,888oo,__`88bo,__,o,\"888,_ _,88P888    Y88      888b \"88bo, 888   888,Y88P       888oo,__ 888    Y88
 MMMM   \"W\" \"\"\"\"YUMMM \"YUMMMMMP\" \"YMMMMMP\" MMM     YM      MMMM   \"W\"  YMM   \"\"`  MP        \"\"\"\"YUMMMMMM     YM"
  puts '[+] Reconnaissance tool of Penetration test & Bug Bounty'
  puts '[+] Code by HAHWUL(https://www.hahwul.com)'
end
