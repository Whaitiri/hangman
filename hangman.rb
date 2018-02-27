#!/usr/bin/env ruby

$wordlist = Array.new
$currentguess = Array.new
$allguesses = Array.new
$guessremaining = 5

File.open("/usr/share/dict/words").each do |line|
  if line.strip.length > 6 or line.strip.length < 3
    next
  elsif line[0].match(/^[A-Z]/)
    next
  else
    $wordlist << line.strip
  end
end

$currentword = $wordlist[rand(0...$wordlist.count)].split("")

$currentword.each do
  $currentguess << '_'
end

def playloop
  puts ""
  print $currentguess.join
  print " ("
  print $currentword.length
  puts " letters)"
  print "You have "
  print $guessremaining
  puts " guesses"
  print "Letters used: "
  puts $allguesses.join(",")

  puts "Please enter a letter:"
  guessinput = gets.chomp
  puts " "
  guessfail = 0
  i = 0
  $currentword.each do |letter|
    if guessinput == "cheat" #enter cheat for testing
      print "TESTING ONLY - THE ANSWER IS "
      puts $currentword.join
      guessinput = nil
      break

    elsif guessinput.length > 1
      puts "please enter a single letter"
      guessinput = nil
      break

    elsif $allguesses.include?(guessinput)
      puts "you have already input that letter"
      guessinput = nil
      break

    elsif letter == guessinput
      $currentguess.insert(i, letter)
      $currentguess.delete_at(i+1)
      i += 1

    else
      guessfail += 1
      i += 1

    end
  end

  if $allguesses.include?(guessinput)
  else
    $allguesses << guessinput
  end

  if guessfail >= $currentword.length
    $guessremaining -= 1
  else
  end

  if $guessremaining < 1
    puts "you ran out of guesses"
    print "The word was "
    puts $currentword.join
    exit

  elsif $currentguess == $currentword
    puts "You won!!!!!"
    print "The word was "
    puts $currentword.join
    exit

  else
    playloop

  end
end

playloop
