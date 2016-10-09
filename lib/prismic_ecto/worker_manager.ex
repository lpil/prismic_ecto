defmodule Prismic.Ecto.WorkerManager do
  @moduledoc false
  use GenServer

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
    :ok = Prismic.Ecto.WorkerSupervisor.start_child(from, query)
    {:noreply, state}
  end
end
