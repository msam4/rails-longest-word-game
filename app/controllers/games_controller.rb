require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @answer = params[:letters].upcase

    @grid = params[:grid].split(" ")

    @contains_grid = @answer.split("").all? do |letter|
      @answer.count(letter) <= @grid.count(letter)
    end

    response = URI.open("https://wagon-dictionary.herokuapp.com/#{@answer}").read
    json = JSON.parse(response)
    @english_word = json['found']

    @results = if @contains_grid && @english_word
      "Congratulations! #{@answer} is a valid English word!"
    elsif @contains_grid && !@english_word
      "Sorry but #{@answer} does not seem to be a valid English word..."
    else
      "Sorry but #{@answer} can't be built out of #{@grid}..."
    end
  end
end
