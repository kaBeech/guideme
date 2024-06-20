defmodule Step do
  use GuidemeWeb, :html
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  defp get_last_char(text) do
    String.slice(text, -2..-1)
  end

  def render_step(assigns) do
    ~H"""
    <div class="flex justifyLeft gap1">
      <%= if @external_link do %>
        <a href={@external_link} target="_blank" rel="noopener noreferrer">
          
        </a>
      <% else %>
        <span class="textDull">
          
        </span>
      <% end %>
      <%= if @image do %>
        <span class="link pointer" phx-click={JS.toggle(to: "#image-step" <> @number)}>
          
        </span>
        <div
          id={"image-step" <> @number}
          phx-click={JS.toggle(to: "#image-step" <> @number)}
          class="hidden"
        >
          <div class="dimScreenImageHolder">
            <img class="textDull" src={@image} />
          </div>
        </div>
      <% else %>
        <span class="textDull">
          
        </span>
      <% end %>
      <span class="textDull">
        
      </span>
      <span>
        <input type="checkbox" />
      </span>
      <span class="textDull"><%= @number %>.</span>
      <%= @full_text %>
    </div>
    """
  end
end
