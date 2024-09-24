defmodule GuidemeWeb.ChapterLive.Select do
  use GuidemeWeb, :live_view

  import NavBar

  alias Guideme.{Guides}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, guides: Guides.list_guides())}
  end
end
