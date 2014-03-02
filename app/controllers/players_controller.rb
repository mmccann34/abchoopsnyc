class PlayersController < ApplicationController
  def index
    #@players = Player.all
    @new_player = Player.new
  end
  
  def datatables
    respond_to do |format|
      format.json { render json: PlayersDatatable.new(view_context) }
    end
  end

  def new
    @player = Player.new
  end

  def create
    birthday = params[:player][:birthday]
    params[:player][:birthday] = Date.strptime(birthday, '%m/%d/%Y') if birthday && !birthday.empty?
    @player = Player.new(params[:player])
    set_social_media
    if @player.save
      redirect_to players_url, notice: "Player has successfully been created."
    else
      render action: "new",  flash: { error: "An error occurred while creating Player." }
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    birthday = params[:player][:birthday]
    params[:player][:birthday] = Date.strptime(birthday, '%m/%d/%Y') if birthday && !birthday.empty?
    set_social_media
    if @player.update_attributes(params[:player])
      redirect_to edit_player_url(@player), notice: "Player has successfully been updated."
    else
      render action: "edit", flash: { error: "An error occurred while updating Player." }
    end
  end
  
  def set_social_media
    @player.social_media_urls.clear

    if params[:social_media_values]
      params[:social_media_values].each do |index, value|
        if not value.blank?
          type = params[:social_media][index]
          @player.social_media_urls[type] = value
        end
      end
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
  
  def merge
    @players = Player.all.sort_by {|p| p.display_name.blank? ? p.last_name : p.display_name }
  end
  
  def merge_players
    @player = Player.find(params[:player])
    @duplicate = Player.find(params[:duplicate])
    @duplicate.stat_lines.update_all(player_id: @player.id)
    @duplicate.roster_spots.update_all(player_id: @player.id)
    @duplicate.destroy
    
    redirect_to merge_players_url, notice: "Duplicate has been successfully merged into Player."
  end
end
