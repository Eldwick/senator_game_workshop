class SenatorController < ApplicationController
  def game
    @senator = Senator.random
  end
end
