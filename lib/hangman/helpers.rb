# frozen_string_literal: true

module Hangman
  module Helpers
    MAX_ROUNDS = 7
    def clear_screen
      print "\e[2J\e[f"
    end

    def words_dictionary_path
      File.absolute_path("./lib/assets/google-10000-english-no-swears.txt")
    end

    def save_game_path
      File.absolute_path("./lib/assets/hangman_save.json")
    end
  end
end
