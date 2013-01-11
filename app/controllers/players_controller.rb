class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(params[:player])
    if @player.save
      redirect_to players_path
    else
      render action: "new"
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      redirect_to players_path, notice: "Your player has successfully been updated."
    else
      render action: "edit"
    end
  end

  def destroy
    Player.destroy(params[:id])
    redirect_to :back, notice: "Player has been deleted."
  end
end
