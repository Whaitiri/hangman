#!/usr/bin/env ruby

require_relative "hungmen_classes/player"
require_relative "hungmen_classes/game"
require_relative "hungmen_classes/system"
require_relative "hungmen_classes/guessinput"

hangmanSystem = System.new
hangmanSystem.playGame
