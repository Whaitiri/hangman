#!/usr/bin/env ruby

class Player
  attr_accessor :guessRemaining, :playerName
  def initialize(allowedGuesses, playerName)
    @allGuesses = []
    @guessRemaining = allowedGuesses
    @playerName = playerName
  end

  def loseGuess
    @guessRemaining -= 1
  end

end

class Game
  def initialize
    puts "Enter name:"
    name = gets.chomp
    @player = Player.new(3, name)
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
playGame.input
