defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Process.send_after(self(), :tick, 2000)
    end

    socket =
      socket
      |> assign(responders: 1)
      |> assign(minutes_per_responder: 10)
      |> assign(page_title: "Effort Calculator")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <section>
        <button phx-click="add" phx-value-quantity="1">
          +
        </button>
        <div>
          <%= @responders %> people
        </div>
        &times;
        <div>
          <%= @minutes_per_responder %> mins
        </div>
        =
        <div>
          <%= @responders * @minutes_per_responder %> mins
        </div>
      </section>

      <form phx-submit="recalculate">
        <label>Minutes per Responder:</label>
        <input type="number" name="minutes" value={@minutes_per_responder} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    socket = update(socket, :responders, &(&1 + String.to_integer(quantity)))

    {:noreply, socket}
  end

  def handle_event(
        "recalculate",
        %{"minutes" => minutes},
        socket
      ) do
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes))
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end
