defmodule TodosyncWeb.UsersView do
  use TodosyncWeb, :view

  def render("show.json", data) do
    if data.user do
      %{
        id: data.user.id,
        remember_the_milk_key: data.user.r_t_m_key,
        todoist_key: data.user.todoist_key
      }
    else
      %{code: 403, message: "Authorization key not found."}
    end
  end

  def render("auth.json", data) do
    %{auth_key: data.user.auth_key}
  end

  def render("error.json", response) do
    %{code: response.data.code, message: response.data.message}
  end

end
