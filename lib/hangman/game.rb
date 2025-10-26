require_relative "title"
require_relative "helpers"
require_relative "scaffold"

require "pastel"
require "tty-font"
require "tty-prompt"
require "json"

module Hangman
  class Game
    include Helpers

    def initialize
      @word = nil
      @secret_word = nil
      @correct_guesses = []
      @incorrect_guesses = []
      @title = Title.new
      @pastel = Pastel.new
      @scaffold = Scaffold.new
      @font = TTY::Font.new
    end

    def menu_select
      clear_screen
      @title.show
      TTY::Prompt.new.select("Main menu") do |menu|
        menu.choice "Start new game", :new
        menu.choice "Load last saved game", :load
        menu.choice "Exit", :exit
      end
    end

    def start
      choice = menu_select
      return if choice == :exit

      if choice == :load
        load_game
      else
        select_new_word
      end

      main_loop
    end

    private

    def main_loop
      until finished?
        clear_screen
        @title.show
        @scaffold.show(@word, @incorrect_guesses.length)

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

    def select_new_word
      File.open(words_dictionary_path) do |f|
        @secret_word = normalize(random_word(f))
        @word = @secret_word.gsub(/[a-z]/, "_")
      end
    end

    def game_state
      {
        word: @word,
        secret_word: @secret_word,
        correct_guesses: @correct_guesses,
        incorrect_guesses: @incorrect_guesses
      }
    end

    def save_game
      serialized_state = JSON.generate(game_state)
      f = File.new(save_game_path, "w")
      f.write(serialized_state)
      f.close
    end

    def load_game
      saved_state = JSON.load_file(save_game_path, symbolize_names: true)
      @word = saved_state[:word]
      @secret_word = saved_state[:secret_word]
      @correct_guesses = saved_state[:correct_guesses]
      @incorrect_guesses = saved_state[:incorrect_guesses]
    end

    def guess
      g_char = ""
      while g_char.length != 1
        puts "Please provide single character (or type 'save' to save the game)"
        g_char = gets.chomp

        if g_char == "save"
          save_game
          puts "Game was saved succesfully"
        end
      end

      g_char
    end

    def make_guess
      g = guess
      idxs = @secret_word.chars.each_with_index.select { |c, _| c == g }.map(&:last)

      if idxs.empty?
        @incorrect_guesses.push(g)
        return
      end

      idxs.each { |i| @word[i] = g }
    end
  end
end
