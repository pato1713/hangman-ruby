# frozen_string_literal: true

require_relative "hangman/version"
require_relative "hangman/game"

module Hangman
  class Error < StandardError; end

  def self.start
    Game.new.start
  end
end
