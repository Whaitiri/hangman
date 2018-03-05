class Player # player.rb
  attr_accessor :playerGuess, :playerWord, :playerName, :playerGuesses, :playerNum
  def initialize(playerNum, playerName, playerWord, playerGuessNum) #make this an initialize
    @playerName = playerName
    @playerGuess = playerGuessNum
    @playerGuesses = []
    @playerWord = playerWord
    @playerNum = playerNum
  end
end
