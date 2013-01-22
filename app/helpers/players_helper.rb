module PlayersHelper
  def user_admin?
    current_user.try(:admin?)
  end
end
