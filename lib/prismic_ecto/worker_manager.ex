defmodule Prismic.Ecto.WorkerManager do
  @moduledoc false
  use GenServer
  alias Prismic.Ecto.Request

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def execute(query) do
    GenServer.call(__MODULE__, {:execute, query})
  end

  #
  # Callbacks
  #

  def handle_call({:execute, query}, from, state) do
    req = %Request{ query: query, consumer: from }
    :ok = Prismic.Ecto.WorkerSupervisor.start_child(req)
    {:noreply, state}
  end
end
