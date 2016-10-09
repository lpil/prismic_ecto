defmodule Prismic.Ecto.WorkerSupervisor do
  @moduledoc false

  def start_link do
    import Supervisor.Spec, warn: false
    worker_spec = [
      worker(Prismic.Ecto.Worker, [], restart: :transient),
    ]
    options = [
      strategy: :simple_one_for_one,
      name: __MODULE__,
    ]
    Supervisor.start_link(worker_spec, options)
  end

  def start_child(consumer, query) do
    {:ok, _pid} = Supervisor.start_child(__MODULE__, [consumer, query])
    :ok
  end
end
