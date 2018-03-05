#!/usr/bin/env ruby


wordList = []
currentGuess = []

File.open("/usr/share/dict/words").each do |line|
  if line.strip.length > 6 or line.strip.length < 3
    next
  elsif line[0].match(/^[A-Z]/)
    next
  else
    wordList << line.strip
  end
end

currentWord = wordList[rand(0...wordList.count)].split("")
currentWord.each do
  currentGuess << '_'
end

class Player
  attr_accessor :pGuessRemaining
  def initialize(playerNum, currentWord, currentGuess, allGuess, guessRemaining)
    @playerNum = playerNum
    @currentWord = currentWord
    @currentGuess = currentGuess
    @allGuess = allGuess
    @guessRemaining = guessRemaining
  end

  def pPlayerNum
    return @playerNum
  end

  def pCurrentWord
    return @currentWord
  end

  def pCurrentGuess
    return @currentGuess
  end

  def pAllGuess
    return @allGuess
  end

  def pGuessRemaining
    return @guessRemaining
  end

  def promptInfo
    puts <<~HEREDOC

      Player #{@playerNum}'s turn!

      #{@currentGuess.join(' ')} (#{@currentWord.length} letters)
      You have #{@guessRemaining} guesses left
      Letters used: #{@allGuess.join(',')}

      Please enter a letter:
    HEREDOC
  end

  def receiveInput(guessInput)
    i = 0
    guessFail = 0
    correctGuess = false
    @currentWord.each do |letter|
      if guessInput == "cheat" #enter cheat for testing
        puts "TESTING ONLY - THE ANSWER IS #{@currentWord.join}"
        guessInput = nil
        break

      elsif guessInput.length > 1
        puts "please enter a single letter"
        guessInput = nil
        break

      elsif @allGuess.include?(guessInput)
        puts "you have already input that letter"
        guessInput = nil
        break

      else
        if letter == guessInput
          @currentGuess.insert(i, letter)
          @currentGuess.delete_at(i+1 )
          correctGuess = true
        else
          guessFail += 1
        end
        i += 1
      end
    end

    if @allGuess.include?(guessInput)
    else unless guessInput == nil
        @allGuess << guessInput
      end
    end

    @guessRemaining -= 1
  end

end


$p1 = Player.new(1, currentWord.clone, currentGuess.clone, [], 5)
$p2 = Player.new(2, currentWord.clone, currentGuess.clone, [], 5)

def playLoop(player)
    player.promptInfo
    guessInput = gets.chomp
    player.receiveInput(guessInput)

    if player.pGuessRemaining < 1
      puts "You ran out of guesses. The word was #{player.pCurrentWord.join}"

    elsif player.pCurrentGuess == player.pCurrentWord
      puts "You won!!! The word was #{player.pCurrentWord.join}"
      puts "Player #{player.pPlayerNum} won"

    else
      if player.pPlayerNum == 1
        playLoop($p2)
      elsif player.pPlayerNum == 2
        playLoop($p1)
      end
    end
end

playLoop($p1)
