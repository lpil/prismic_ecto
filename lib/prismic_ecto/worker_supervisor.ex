defmodule Prismic.Ecto.WorkerSupervisor do
  @moduledoc false
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(consumer, query) do
    {:ok, _pid} = Supervisor.start_child(__MODULE__, [consumer, query])
    :ok
  end

  #
  # Callbacks
  #

  def init([]) do
    child_spec = [worker(Prismic.Ecto.Worker, [], restart: :transient)]
    supervise(child_spec, strategy: :simple_one_for_one)
  end
end
