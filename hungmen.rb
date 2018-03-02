#!/usr/bin/env ruby
$playerGuessNum = 10

class Player
  attr_accessor :playerGuess, :playerName, :playerGuesses
  def createPlayer
    puts "What is your name"
    @playerName = gets.chomp
    @playerGuess = $playerGuessNum
    @playerGuesses = []
  end

  def loseGuess
    @playerGuess -= 1
  end

  def storeGuess(x)
    @playerGuesses << x
  end


end

class Game
  def initialize
    @players = []
    puts "How many players? 1 or 2"
    response = Integer(gets.chomp)
    if response == 1 or response == 2
      response.times do |x|
        @players[x] = Player.new
        @players[x].createPlayer
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
    return wordList[rand(0...wordList.count)]
  end

  def input
    @players.each do |player|
      if player.playerGuess == 0
        puts "You have no coins left!"
        exit
      end
      puts "Press [y] to generate a word, #{player.playerName}; you have #{player.playerGuess} coins remaining."
      if player.playerGuesses.length > 0
        puts "#{player.playerName}'s previous words:"
        player.playerGuesses.each do |guess|
          print "#{guess}, "
        end
        puts ""
      end
      response = gets.chomp
      if response == 'y'
        word = self.callWord
        puts word
        player.storeGuess(word)
        player.loseGuess
      else
        exit
      end
    end
    self.input
  end

end

playGame = Game.new
playGame.input
