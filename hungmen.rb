#!/usr/bin/env ruby
$playerGuessNum = 2

class Player
  attr_accessor :playerGuess, :playerWord, :playerName, :playerGuesses, :playerNum
  def createPlayer(playerNum)
    puts "What is your name, Player #{playerNum}?"
    @playerName = gets.chomp
    @playerGuess = $playerGuessNum
    @playerGuesses = []
    @playerWord = []
    @playerNum = playerNum
  end

  def addGuess(i,guess)
    @playerWord[i] = guess
  end
end

class Game
  def initialize(gameNum)
    @gameNum = gameNum
    @players = []
    @currentWord = self.callWord
    currentWordBlanked = []
    @currentWord.each do
      currentWordBlanked << '_'
    end

    puts "How many players? 1 or 2"
    response = Integer(gets.chomp)
    if response == 1 or response == 2
      response.times do |x|
        @players[x] = Player.new
        @players[x].createPlayer(x+1)
      end
      @players.each do |player|
        player.playerWord = currentWordBlanked.dup
      end
    else
      initialize
    end
  end

  def callWord
    wordList = []
    File.open("/usr/share/dict/words").each do |line|
      line = line.strip
      if line.strip.length > 7 or line.strip.length < 3
        next
      elsif line[0].match(/^[A-Z]/)
        next
      else
        wordList << line.strip
      end
    end
    return wordList[rand(0...wordList.count)].split("")
  end

  def input
    @players.each do |player|
      if player.playerGuess < 1
        puts "#{player.playerName} has run out of guesses!"
        next
      end
      self.checkGuess(player)
      if player.playerWord == @currentWord
        puts "#{player.playerName} won!"
        self.summarizeGame
        exit
      end
    end
    if self.checkGuessesLeft

    else
      self.input
    end
  end

  def guessPrompt(player)
    puts "#{player.playerName}'s turn to guess'; you have #{player.playerGuess} guesses remaining."
    if player.playerGuesses.length > 0
      puts "#{player.playerName}'s previous guesses:"
      player.playerGuesses.each do |guess|
        print "#{guess} "
      end
      puts ""
    end
    puts "#{player.playerWord.join(' ')}"
    print "Input a letter: "
  end

  def checkGuess(player)
    begin
      self.guessPrompt(player)
      response = gets.chomp.downcase
      if response == "cheat" #enter cheat for testing
        puts "TESTING ONLY - THE ANSWER IS #{@currentWord.join}"
        response = nil

      elsif response == 'exit'
        exit

      elsif response.length > 1 or response =~ /[^a-z]/
        puts "please enter a single letter"
        response = nil

      elsif player.playerGuesses.include?(response)
        puts "you have already input that letter"
        response = nil

      end
      raise
    rescue
      retry if response == nil or response == ''
    end
    i = 0
    guessFail = 0
    @currentWord.each do |letter|
      if letter == response
        player.playerWord[i] = letter
      else
        guessFail += 1
      end
      i += 1
    end

    if player.playerGuesses.include?(response)
    else
      player.playerGuesses << response
    end

    if guessFail >= i
      player.playerGuess -= 1
      puts "#{player.playerName}'s guess was incorrect..."
    else
      puts "#{player.playerName}'s guess was correct!"
    end
    puts "#{player.playerName}: #{player.playerWord.join(' ')}"
  end

  def checkGuessesLeft
    noCoins = 0
    @players.each do |player|
      if player.playerGuess < 1
        noCoins += 1
      end
    end
    if noCoins >= @players.length
      puts "All players have run out of coins!"
      self.summarizeGame
      return true
    else
      return false
    end
  end

  def summarizeGame
    puts "Summary for Game #{@gameNum}:"
    puts "The word was #{@currentWord.join}"
    @players.each do |player|
      puts "#{player.playerName}'s guesses:"
      player.playerGuesses.each do |guess|
        print "#{guess} "
      end
      puts ""
      puts "#{player.playerName}'s guess was #{player.playerWord.join} with #{player.playerGuess} guesses remaining"
    end
  end

end

class System
  def initialize
    @games = []
    @gamesPlayed = 0
    firstGame = Game.new(1)
    firstGame.input
    @games << firstGame
    self.playAgain
  end

  def playAgain
    puts "Would you like to play again? (enter [y] or [n])"
    response = gets.chomp
    if response == "y"
      @gamesPlayed += 1
      @games[@gamesPlayed] = Game.new(@gamesPlayed+1)
      @games[@gamesPlayed].input
      self.playAgain
    else
      puts "Thanks for playing!"
      puts ""
      puts "Summary of all games:"
      @games.each do |game|
        game.summarizeGame

      end

    end
  end
end

gameSystem = System.new
