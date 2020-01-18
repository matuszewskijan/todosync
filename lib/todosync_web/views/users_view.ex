defmodule TodosyncWeb.UsersView do
  use TodosyncWeb, :view

  def render("show.json", _data) do
    %{success: true}
  end

  def render("auth.json", _data) do
    %{success: true}
  end

end
