# frozen_string_literal: true

require "tty-font"
require "pastel"

module Hangman
  class Title
    TITLE = "Hangman"

    def initialize
      @font = TTY::Font.new
      @pastel = Pastel.new
    end

    def show
      puts @pastel.magenta(@font.write(TITLE))
    end
  end
end
