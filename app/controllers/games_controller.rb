class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
    if @game.save
      redirect_to games_url
    else
      render action: "new",  flash: { error: "An error occurred while creating Game." }
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to games_url, notice: "Game has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Game." }
    end
  end

  def destroy
    @game = Game.find(params[:id])
    if @game.destroy
      redirect_to games_url, notice: "Game has been deleted."
    else
      redirect_to games_url, flash: { error: "An error occurred while deleting Game."}
    end
  end
end