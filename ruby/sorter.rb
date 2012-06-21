# Sorter.rb
# by Matthew Webber
#
# Determine good and bad states for Northwest game.
# http://m.atthe.ws/games/northwest/
#
# dependencies: none
# usage: none (included from other files)
module Sorter

$hash_bad = {}
$hash_good = {}

#========================================================
# Canonical representation
def canon(str)
  rep = ''
  str += '0';
  lastVal = str[0,1].to_i(16)
  for i in (1..str.length-1)
    val = str[i,1].to_i(16)
    if (val < lastVal)
      rep += (lastVal).to_s(16)
      rep += (i)  .to_s(16)
      lastVal = val
    end
  end
  return [rep,rep.reverse].min
end

#========================================================
# Get all states that fit in max_rows x max_cols
# such that the total squares <= total_squares
def getStates(total_squares, max_rows, max_cols)
  return []   if (max_rows < 0)
  return [''] if (total_squares == 0)

  ret = []
  for i in (1..[total_squares,max_cols].min)
    current = getStates(total_squares-i, max_rows-1, i); #ooh elegant
    for j in current
      ret.push("#{i.to_s(16)}#{j}");
    end
  end
  return ret
end

#========================================================
# Given a state, what is the list of states that could follow?
# state is of a form like 4.2.1
def getNextStates(state)
  next_states = []
  for i in (0..state.length-1)
    ival = state[i,1].to_i(16)
    for clamp in (0..ival-1)
      x = state.dup
      for k in (i..state.length-1)
        if (clamp < state[k,1].to_i(16))
          x[k,1] = clamp.to_s(16)
        end
      end
      sh = x.tr('0','')    
      if (sh.length > 0)
        next_states.push(sh) 
      end
    end
  end
  return next_states
end

#========================================================
# Discover all bad states that fit in a square of size 'size'

def judgeAll(size, printTiming) 
  for num in (1..size*size)
    mini_start_time= Time.now    

    states = getStates(num, size, size)
    for state in states
      judge(state)
    end

    if (printTiming)
      mini_time_elapsed = Time.now-mini_start_time
      secs_left = ((size*size - num) * mini_time_elapsed).ceil;
      mins_left = (secs_left/60).floor;
      secs_left = secs_left - (mins_left*60);
      say "  %d took %ds. Estimated %2d:%02ds left." % [num, mini_time_elapsed, mins_left, secs_left]
      $stdout.flush
    end
  end
end

def judge(state)
  s = canon(state)
  for follower in getNextStates(state)
    f = canon(follower)
    if (isBad(f))
      itsGood(s)
      return
    elsif (!isGood(f))    
      say 'Error, state not found anywhere: <' + f + '>';
    end
  end
  itsBad(s)
end

#=======================================================================
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
  for key in $hash_bad.keys
    puts "'#{key}',"
  end
end

def say(msg)
  puts msg if ($VERBOSE)
end

end
