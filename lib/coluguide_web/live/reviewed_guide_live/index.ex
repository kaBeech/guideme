defmodule ColuguideWeb.ReviewedGuideLive.Index do
  use ColuguideWeb, :live_view
  import NavBar
  import ColuguideWeb.Guide.ReviewStatus
  import ColuguideWeb.Search

  alias Coluguide.{ReviewRecords, Users, Guides}
  alias Coluguide.ReviewRecords.ReviewedGuide

  def list_guides do
    Guides.list_guide_names_and_ids()
  end

  def list_users do
    Users.list_users()
  end

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :search_guides_enabled, true)
    {:ok, stream(socket, :reviewed_guides, ReviewRecords.list_reviewed_guides())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Review assignment")
    |> assign(:reviewed_guide, ReviewRecords.get_reviewed_guide!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Review assignment")
    |> assign(:reviewed_guide, %ReviewedGuide{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Assign Guides for Review")
    |> assign(:reviewed_guide, nil)
  end

  @impl true
  def handle_info(
        {ColuguideWeb.ReviewedGuideLive.FormComponent, {:saved, reviewed_guide}},
        socket
      ) do
    {:noreply, stream_insert(socket, :reviewed_guides, reviewed_guide)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reviewed_guide = ReviewRecords.get_reviewed_guide!(id)
    {:ok, _} = ReviewRecords.delete_reviewed_guide(reviewed_guide)

    {:noreply, stream_delete(socket, :reviewed_guides, reviewed_guide)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    socket = assign(socket, :search_query, query)
    ColuguideWeb.Search.search_guides(query, socket)
  end

  def handle_event("focus_search", _params, socket) do
    {:noreply, assign(socket, :search_guides_focused, true)}
  end

  def handle_event("clear_search", _params, socket) do
    clear_search(socket)
  end

  def handle_event("keyup", %{"key" => "Escape"}, socket) do
    {:noreply,
     socket
     |> assign(:form, to_form(%{"query" => ""}))
     |> assign(:search_results, [])}
  end

  def handle_event("keyup", _, socket) do
    {:noreply, socket}
  end
end