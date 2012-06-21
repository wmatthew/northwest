# sorterRun.rb
# by Matthew Webber
#
# Figure out good and bad states for Northwest game.
# http://m.atthe.ws/games/northwest/
#
# dependencies: none
# usage: 
# > ruby sorterRun.rb 5

$DEBUG = true
$VERBOSE = true
$DUMP = true

require 'sorter.rb'
include Sorter
$start_time= Time.now

size = ARGV.pop().to_i
say "Evaluating #{size} x #{size} board..."

judgeAll(size, true)
say "Report"
say "Size: #{size}"
say "Total bad states: #{numBad()}"

if ($DEBUG)
  say "Total good states: #{numGood()}"
end

say "-----------------------"
say "All bad states:"
if ($DUMP)
  dump_bad()
end
say "-----------------------"

time_elapsed = Time.now-$start_time
say time_elapsed.to_s + " seconds."
