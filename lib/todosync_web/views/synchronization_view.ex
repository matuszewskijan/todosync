defmodule TodosyncWeb.SynchronizationView do
  use TodosyncWeb, :view

  def render("show.json", data) do
    %{
      creations: data.sync_info[:creations] || 0,
      modifications: data.sync_info[:modifications] || 0,
      deletions: data.sync_info[:deletions] || 0
    }
  end

end
