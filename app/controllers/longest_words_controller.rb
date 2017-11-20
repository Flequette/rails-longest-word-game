require 'open-uri'
require 'json'

class LongestWordsController < ApplicationController

  def game
    @game = generate_grid(9)

  end

  def score
    attempt = params[:result]
    grid = params[:grid]
    start_time = params[:start_time].to_i
    end_time = Time.now.to_i

    run_game(attempt, grid, start_time, end_time)
  end

private

  def run_game(attempt, grid, start_time, end_time)
    @results = {}
    score = 0
    if word_english?(attempt) == false
      message = "Sorry, it is not an english word. Try again."
    elsif letter_include?(attempt, grid) == false
      message = "Sorry, your letter is not in the grid. Try again."
    else
      score = attempt.size.to_i * 10 - (end_time.to_i - start_time.to_i)
      message = "Well Done!"
    end
    @results[:time] = (end_time.to_i - start_time.to_i)
    @results[:score] = score
    @results[:message] = message
    return @results
  end

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def word_english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/" + attempt
    JSON.parse(open(url).read)["found"] ? true : false
  end

  def letter_include?(attempt, grid)
    attempt.upcase!
    letters = attempt.split("")
    truth = true
    letters.each do |letter|
      if letters.count(letter.upcase) <= grid.count(letter.upcase)
        truth = true
      else
        return false
      end
    end
  end

end
