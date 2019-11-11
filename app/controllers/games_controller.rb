require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid.join(' ')
    # @start_time = Time.now
  end

  def score
    @answer = params[:word]
    grid = params[:grid].split(' ')
    # end_time = Time.now
    run_game(@answer, grid)
  end

  def generate_grid
    alph = ('A'..'Z').to_a.sample(10)
  end

  def run_game(attempt, grid)
    grid = grid.each_with_object(Hash.new(0)) { |element, count| count[element] += 1 }
    @result = {}
    @result[:score] = 0
    # @result[:time] = end_time - start_time
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)

    if user['found']
      letters = attempt.upcase.split('')
      letters.each do |letter|
        if grid[letter].zero?
          @result[:message] = 'not in the grid'
          return @result
        else
          grid[letter] -= 1
        end
      end
      @result[:score] = user['length']
      # @result[:score] = (user['length'] / @result[:time])
      @result[:message] = 'well done'
    else
      @result[:score] = 0
      @result[:message] = 'not an english word'
    end
    @result
  end
end
