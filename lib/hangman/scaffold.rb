# frozen_string_literal: true

module Hangman
  class Scaffold
    attr_reader :pastel

    def initialize
      @pastel = Pastel.new
    end

    def show(word, incorrect_count)
      puts <<~HANGMAN
        #{pastel.cyan("  _________  ")}
        #{pastel.cyan("  |       #{paint_hangman(0, incorrect_count)}  ")}
        #{pastel.cyan("  |       #{paint_hangman(1, incorrect_count)}  ")}
        #{pastel.cyan("  |      #{paint_hangman(2, incorrect_count)}#{paint_hangman(3, incorrect_count)}#{paint_hangman(4, incorrect_count)}")}
        #{pastel.cyan("  |      #{paint_hangman(5, incorrect_count)} #{paint_hangman(6, incorrect_count)}")}       #{word}
        #{pastel.cyan("  |          ")}
        #{pastel.cyan(" _|_         ")}
        #{pastel.cyan("|   |______  ")}
        #{pastel.cyan("|          | ")}
        #{pastel.cyan("|__________| ")}
      HANGMAN
    end

    def paint_hangman(position_number, incorrect_count)
      case position_number
      when 0 then "|" if incorrect_count.positive?
      when 1 then "O" if incorrect_count > 1
      when 2 then "/" if incorrect_count > 2
      when 3 then "|" if incorrect_count > 3
      when 4 then "\\" if incorrect_count > 4
      when 5 then "/" if incorrect_count > 5
      when 6 then "\\" if incorrect_count > 6
      end
    end
  end
end
