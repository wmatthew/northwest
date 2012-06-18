# Sorter.rb
# by Matthew Webber
#
# Figure out good and bad states for Northwest game.
# usage ./sorter.rb 12
# dependencies none
#
# http://m.atthe.ws/games/northwest/
$start_time= Time.now

# Configuration
$DEBUG = false
$VERBOSE = true
$DUMP = true

# arrays. not used anymore; hashes are faster.
$known_bad = ['1']
$known_good = ['0']

$hash_bad = {'1'=>true}
$hash_good = {'0'=>true}

#========================================================
# Get an array of legal configurations of a fixed size
# This is clumsy but the helper function is nice.
def getStates(total_squares, max_rows, max_cols)
  ret1 = getStatesHelper(total_squares, max_rows, max_cols)
  ret2 = []
  for i in ret1
    ret2.push(i[0..(i.length-2)])
  end
  return ret2
end

def getStatesHelper(total_squares, max_rows, max_cols)
  if (max_rows < 0)
    return []
  end
  if (total_squares == 0)
    return ['']
  end
  ret = []
  for i in (1..[total_squares,max_cols].min)
    current = getStatesHelper(total_squares-i,max_rows-1,i); #ooh elegant
    for j in current
      ret.push("#{i}.#{j}");
    end
  end
  return ret
end

#========================================================
# Given a state, what is the list of states that could follow?
# state is of a form like 4.2.1
def getNextStates(state)
  next_states = []
  cumul = []
  old = state.split('.')
  for index in (0..(old.length-1))
    i = old[index].to_i
    for j in (0..i-1)
      future = Array.new(cumul);
      future.push(j)
      for k in (old[index+1..old.length-1])
        future.push([k.to_i,j.to_i].min)
      end
      next_states.push(neaten(future));
    end
    cumul.push(i)
  end
  return next_states
end

#========================================================
# Neaten and reformat into string
def neaten(state_array)
  arr2 = state_array.find_all{|x|x>0}
  if (arr2.length == 0)
    return "0"
  end
  return arr2.join('.');
end

#========================================================
# Discover all bad states that fit in a square of size 'size'
def judgeAll(size) 
  for num in (1..size*size)
    say "Judging #{num}."
    mini_start_time= Time.now    
    states = getStates(num, size, size)
    for state in states
      judge(state)
    end
    mini_time_elapsed = Time.now-mini_start_time
    secs_left = ((size*size-num)*mini_time_elapsed).ceil;
    mins_left = (secs_left/60).floor;
    secs_left = secs_left - (mins_left*60);
    say "  took #{mini_time_elapsed}s. Approx #{mins_left}:#{secs_left}s left."
    $stdout.flush
  end
end

def judge(state)
  for follower in getNextStates(state)
    if (isBad(follower))
      itsGood(state)
      return
    else
      if ($DEBUG)
        if (!isGood(include?(follower)))
          say "Error, state not found anywhere: " + follower;
        end
      end
    end
  end
  itsBad(state)
end

#========================================================
# Access/write the good/bad lists. Everything goes thru these functions.
def itsBad(state)
  if (!$hash_bad.include?(state))
    $hash_bad[state]=true
  end
end

def itsGood(state)
  if ($DEBUG)
    if (!$hash_good.include?(state))
      $hash_good[state]=true
    end
  end
end

# hooray for confusing function names
def isBad(state)
  return $hash_bad.include?(state) 
end

def isGood(state)
  return $hash_good.include?(state) 
end

def numBad()
  return $hash_bad.length
end

def numGood()
  return $hash_good.length
end

def dump_bad()
  puts $hash_bad.keys
end

#========================================================
# Blah
def say(msg)
  if ($VERBOSE)
    puts msg
  end
end

#========================================================
# Unit Tests
# don't use 'say' because this is important
if ( getStates(6,3,3).length != 3)
  puts "Get States failed test"
end

if (neaten([3,2,0,0]).length != 3)
  puts "Neaten failed test"
end

if ( getNextStates('2.2.2').length != 6)
  puts "getNextStates failed text"
end

if ( getNextStates('7.2.1').length != 10)
  puts "getNextStates failed text"
end

#========================================================

size = ARGV.pop().to_i
say "Judging everything up to #{size}x#{size}..."
judgeAll(size)
say ""
say "======================="
say "And now for the report!"
say "Size: #{size}"
say "How many bad ones? #{numBad()}"
if ($DEBUG)
  say "How many good ones? #{numGood()}"
else
  say "How many good ones? DUNNO LOL"
end

if ($DUMP)
  dump_bad()
end

time_elapsed = Time.now-$start_time
say time_elapsed.to_s + " seconds."
