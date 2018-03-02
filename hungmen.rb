#!/usr/bin/env ruby
$playerGuesses = 10

class Player
  attr_accessor :guessRemaining, :playerName
  def createPlayer
    puts "What is your name"
    @playerName = gets.chomp
    @playerGuess = $playerGuesses
  end

  def loseGuess
    @playerGuess -= 1
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
      rollCall
    else
      initialize
    end
  end

  def rollCall
    @players.each do |player|
      puts "Hello, #{player.playerName}!"
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
    if @player.guessRemaining == 0
      puts "You have no coins left!"
      exit
    end
    puts "Press [y] to generate a word, #{@player.playerName}; you have #{@player.guessRemaining} coins remaining."
    response = gets.chomp
    if response == 'y'
      puts self.callWord
      @player.loseGuess
      self.input
    else
      exit
    end
  end

end

playGame = Game.new
p "you made it"
