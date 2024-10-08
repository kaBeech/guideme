defmodule ColuguideWeb.ReviewedGuideLive.FormComponent do
  use ColuguideWeb, :live_component

  alias Coluguide.{ReviewRecords, Users, Guides}

  defp list_guide_ids do
    Guides.list_guide_names_and_ids()
    |> Enum.map(&{&1.name, &1.id})
  end

  defp list_user_ids do
    Users.list_users()
    |> Enum.map(&{&1.email, &1.id})
  end

  @impl true
  def render(assigns) do
    users = list_user_ids()
    guides = list_guide_ids()

    ~H"""
    <div class="flex column alignCenter">
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="reviewed_guide-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="select" options={users} label="User ID" />
        <.input field={@form[:guide_id]} type="select" options={guides} label="Guide ID" />
        <:actions>
          <.button class="textSmaller" phx-disable-with="Saving...">Assign review</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reviewed_guide: reviewed_guide} = assigns, socket) do
    changeset = ReviewRecords.change_reviewed_guide(reviewed_guide)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"reviewed_guide" => reviewed_guide_params}, socket) do
    changeset =
      socket.assigns.reviewed_guide
      |> ReviewRecords.change_reviewed_guide(reviewed_guide_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"reviewed_guide" => reviewed_guide_params}, socket) do
    save_reviewed_guide(socket, socket.assigns.action, reviewed_guide_params)
  end

  defp save_reviewed_guide(socket, :edit, reviewed_guide_params) do
    case ReviewRecords.update_reviewed_guide(socket.assigns.reviewed_guide, reviewed_guide_params) do
      {:ok, reviewed_guide} ->
        notify_parent({:saved, reviewed_guide})

        {:noreply,
         socket
         |> put_flash(:info, "Reviewed guide updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_reviewed_guide(socket, :new, reviewed_guide_params) do
    case ReviewRecords.create_reviewed_guide(
           Users.get_user!(reviewed_guide_params["user_id"]),
           reviewed_guide_params
         ) do
      {:ok, reviewed_guide} ->
        notify_parent({:saved, reviewed_guide})

        {:noreply,
         socket
         |> put_flash(:info, "Reviewed guide created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
