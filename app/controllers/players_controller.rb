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
      redirect_to players_url
    else
      render action: "new",  flash: { error: "An error occurred while creating Player." }
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    if @player.update_attributes(params[:player])
      redirect_to @player, notice: "Player has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Player." }
    end
  end

  def destroy
    @player = Player.find(params[:id])
    if @player.destroy
      redirect_to players_url, notice: "Player has been deleted."
    else
      redirect_to players_url, flash: { error: "An error occurred while deleting Player." }
    end
  end

  def show
    @player = Player.find_by_id(params[:id])
    if !@player
      redirect_to players_url, flash: { error: "Player does not exist." }
    end
  end
end
