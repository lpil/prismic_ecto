defmodule Prismic.Ecto.Worker do
  @moduledoc false
  use GenServer

  def start_link(consumer, query) do
    GenServer.start_link(__MODULE__, {consumer, query})
  end

  #
  # Callbacks
  #

  def init({consumer, query}) do
    {:ok, {query, consumer}, 0}
  end

  def handle_info(:timeout, {query, consumer}) do
    IO.puts "Worker #{inspect self()} to to execute #{inspect query} for #{inspect consumer}"
    result = execute_query(query)
    GenServer.reply(consumer, result)
    {:stop, :normal, []}
  end

  defp execute_query(_query) do
    [[:ok]]
  end
end
