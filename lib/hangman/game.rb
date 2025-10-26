require_relative "title"
require_relative "helpers"
require_relative "scaffold"

require "pastel"
require "tty-font"

module Hangman
  class Game
    include Helpers

    def initialize
      @secret_word = nil
      @title = Title.new
      @correct_guesses = []
      @incorrect_guesses = []
      @word = nil
      @pastel = Pastel.new
      @scaffold = Scaffold.new
      @font = TTY::Font.new
    end

    def start
      select_word
      main_loop
    end

    private

    def main_loop
      until finished?
        clear_screen
        @title.show
        @scaffold.show(@word)

        puts
        puts @pastel.red("Incorrect guesses: #{@incorrect_guesses}")
        puts
        make_guess
      end

      show_game_over_info
    end

    def won?
      @word == @secret_word
    end

    def lost?
      @incorrect_guesses.length == MAX_ROUNDS
    end

    def finished?
      won? || lost?
    end

    def show_game_over_info
      if won?
        puts @pastel.green(@font.write("You've won!"))
      else
        puts @pastel.red(@font.write("You've lost"))
      end
    end

    def normalize(str)
      str.split("").join(" ")
    end

    def random_word(file)
      file.readlines(chomp: true).filter { |elem| elem.length.between?(5, 12) }.sample
    end

    def select_word
      File.open(words_dictionary_path) do |f|
        @secret_word = normalize(random_word(f))
        @word = @secret_word.gsub(/[a-z]/, "_")
      end
    end

    def guess
      g_char = ""
      while g_char.length != 1
        puts "Please provide single character"
        g_char = gets.chomp
      end

      g_char
    end

    def make_guess
      g = guess
      idxs = @secret_word.chars.each_with_index.select { |c, _| c == g }.map(&:last)

      if idxs.empty?
        @scaffold.increase_incorrect
        @incorrect_guesses.push(g)
        return
      end

      idxs.each { |i| @word[i] = g }
    end
  end
end
