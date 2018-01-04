class PlayersDatatable
  delegate :params, :form_tag, :hidden_field_tag, :submit_tag, :text_field_tag, :button_to, :link_to, :radio_button_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Player.count,
      iTotalDisplayRecords: players.total_entries,
      aaData: data
    }
  end

private

  def data
    players.map do |player|
      [
        player_add_form(player),
        player.first_name,
        player.last_name,
        player.display_name,
        player.last_team.try(:name),
        player.last_number,
        player.position,
        player.height,
        player.school,
        player.hometown,
        player.id
      ]
    end
  end
  
  def player_add_form(player)
    if params[:team_id]
      form_tag "" do
        hidden_field_tag(:player_id, player.id) +
        hidden_field_tag(:season_id, params[:season_id]) +
        submit_tag("Add to Roster", class: "btn btn-mini btn-primary")
      end
    elsif params[:merge]
      radio_button_tag(:player, player.id)
    elsif params[:merge_duplicates]
      radio_button_tag(:duplicate, player.id)
    else
      link_to('Edit', Rails.application.routes.url_helpers.edit_player_path(player), class: 'btn btn-primary btn-mini') +
      button_to('Delete', player, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger btn-mini')
    end
  end

  def players
    @players ||= fetch_players
  end

  def fetch_players
    if params[:team_id]
      team = Team.find(params[:team_id])
      players = team.roster(params[:season_id]).any? ? Player.where('id not in (?)', team.roster(params[:season_id]).map(&:player)) : Player
    else
      players = Player
    end
    players = players.order("#{sort_column} #{sort_direction}")
    players = players.page(page).per_page(per_page)
    if params[:sSearch].present?
      players = players.where("first_name ILIKE :search or last_name ILIKE :search or (trim(first_name) || ' ' || last_name) ILIKE :search", search: "%#{params[:sSearch]}%")
    end
    players 
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id first_name last_name]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end