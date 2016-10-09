defmodule Prismic.Ecto.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  #
  # Callbacks
  #

  def init(_) do
    children = [
      supervisor(Prismic.Ecto.WorkerSupervisor, []),
      worker(Prismic.Ecto.WorkerManager, []),
    ]
    opts = [strategy: :one_for_one, name: __MODULE__]
    supervise(children, opts)
  end
end
