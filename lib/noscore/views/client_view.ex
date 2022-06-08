defmodule Noscore.NotificationView do
  use Noscore.Signal
  alias Noscore.NotificationView

  def render("error.nostale", %{notification: notification}) do
    ["failc", render_one(notification, NotificationView, "reason.nostale")]
  end

  def render("info.nostale", %{notification: notification}) do
    ["info", notification.content]
  end

  def render("reason.nostale", %{notification: notification}) do
    case notification.reason do
      :outdated_client -> 1
      :unexpected_error -> 2
      :maintenance -> 3
      :session_already_used -> 4
      :unvalid_credentials -> 5
      :cant_authenticate -> 6
      :citizen_blacklisted -> 7
      :country_blacklisted -> 8
      :bad_case -> 9
    end
  end

  def render("lang.nostale", %{lang: lang}) do
    case lang do
      :kr -> 0
      :en -> 1
    end
  end

  def render("name_color.nostale", %{name_color: name_color}) do
    case name_color do
      :white -> 0
      :violet -> 2
      :invisible -> 6
    end
  end
end
