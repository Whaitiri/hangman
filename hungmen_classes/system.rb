class System # system.rb
  def initialize
    @games = []
    @gamesPlayed = 0
  end

  def playGame
    print "Would you like to play Hangman"
    if @gamesPlayed > 0
      print " again"
    end
    puts "? (enter [y] or [n])"
    response = gets.chomp
    if response == "y"
      @games[@gamesPlayed] = Game.new(@gamesPlayed + 1)
      @games[@gamesPlayed].gameLoop
      @gamesPlayed += 1
      self.playGame
    else
      puts "Thanks for playing!"
      if @games.length > 0
        puts ""
        puts "Summary of all games:"
        puts ""
        @games.each do |game|
          game.summarizeGame
        end
        # @games.each(&:summarizeGame)
      end

    end
  end
end
