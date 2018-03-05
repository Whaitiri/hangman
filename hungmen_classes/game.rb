class Game # game.rb
  def initialize(gameNum)
    @playerGuessNum = 3
    @gameNum = gameNum
    @players = []
    @currentWord = self.callWord

    begin
      puts "How many players? 1 or 2" # use a begin/rescue/end
      response = Integer(gets.chomp)
      if response == 1 or response == 2
        response.times do |x|
          puts "What is your name, Player #{x+1}?"
          playerName = gets.chomp
          playerWordBlanked = @currentWord.map { |c| '_' }
          @players[x] = Player.new(x+1, playerName.dup, playerWordBlanked.dup, @playerGuessNum.dup)
        end
      else
        raise if response != 1 or response != 2 # retry if response != 1 or if response != 2
      end
    rescue
      puts "Please input the number 1 or 2"
      retry
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
    return wordList[rand(0...wordList.count)].split("") #return is implicit here
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
    unless self.checkGuessesLeft #unless
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

      elsif response.length > 1 or response =~ /[^a-z]/ or response == ''
        puts "please enter a single letter"
        response = nil

      elsif player.playerGuesses.include?(response)
        puts "you have already input that letter"
        response = nil

      end
      raise
    rescue
      retry if response == nil
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

    unless player.playerGuesses.include?(response) # change to unless, remove the else
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
      puts ""
    end
  end

end
