defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel
alias Memory.Game

  def join("games:" <> name, payload, socket) do
    
    
    game = Memory.GameBackup.load(name) || Game.new()
    socket = socket
    |> assign(:game, game)
    |> assign(:name, name)

    if(authorized?(payload)) do
      {:ok,%{"game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end
   
  def handle_in("gamename", %{"game_name" => game_name},socket)
    do
    {:reply, {:ok, %{"yy" => game_name}}, socket}
  end


   def handle_in("click", payload, socket) do
  
    game = Game.cardClick(socket.assigns[:game],payload["row"],payload["col"])
    Memory.GameBackup.save(socket.assigns[:name],game)
    socket = assign(socket, :game, game)

    {:reply, {:ok, %{"game" => game}}, socket}
  end

    def handle_in("restart", payload, socket) do
    
    game = Game.new()
    Memory.GameBackup.save(socket.assigns[:name],game)
    socket = assign(socket, :game, game)

    {:reply, {:ok, %{"game" => game}}, socket}
  end
   


    

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
