defmodule Prismic.Ecto.Worker do
  @moduledoc false
  use GenServer
  alias Prismic.Ecto.Request

  def start_link(%Request{} = request) do
    GenServer.start_link(__MODULE__, request)
  end

  #
  # Callbacks
  #

  def init(request) do
    {:ok, request, 0}
  end

  def handle_info(:timeout, %Request{ query: q, consumer: consumer }) do
    IO.puts """
    ===
    Prismic.Ecto.Worker #{inspect self()}
    query: #{inspect q}
    consumer: #{inspect consumer}
    ===
    """
    result = execute_query(q)
    GenServer.reply(consumer, result)
    {:stop, :normal, []}
  end

  defp execute_query(_query) do
    [[:ok]]
  end
end
