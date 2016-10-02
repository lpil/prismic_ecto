defmodule Prismic.Ecto do
  @moduledoc """
  An Ecto adapter for the Prismic.io CMS API.
  """

  alias __MODULE__.Client

  @behaviour Ecto.Adapter


  #
  # Worker processes
  #

  @doc false
  def child_spec(_repo, _opts) do
    # TODO: Add client process pooling.
    Supervisor.Spec.worker(Client.Worker, [])
  end

  @doc false
  def ensure_all_started(_repo, _type) do
    {:ok, []}
  end


  # Executes a previously prepared query
  @doc false
  def execute(repo, query_meta, query, params, arg4, options) do
    IO.inspect repo
    IO.inspect query_meta
    IO.inspect query
    IO.inspect params
    IO.inspect arg4
    IO.inspect options
    entries_count = 1
    items = []
    {entries_count, items}
  end

  # Commands invoked to prepare a query for all.
  @doc false
  def prepare(:all, query) do
    IO.inspect query
    {:no_cache, :ok}
  end
  def prepare(_execution_type, _query),
    do: raise Prismic.Ecto.WriteError


  #
  # Type conversion
  # Our code requires no special type conversions.
  #

  @doc false
  def dumpers(primitive_type, _ecto_type) do
    [primitive_type]
  end

  @doc false
  def loaders(primitive_type, _ecto_type) do
    [primitive_type]
  end


  #
  # Callback invoked in case the adapter needs to inject code
  #

  @doc false
  defmacro __before_compile__(_env),
    do: []

  #
  # Writing to the API is unsupported
  #

  @doc false
  def autogenerate(_field_type),
    do: raise Prismic.Ecto.WriteError

  @doc false
  def insert(_repo, _schema_meta, _fields, _returning, _options),
    do: raise Prismic.Ecto.WriteError

  @doc false
  def insert_all(_repo, _schema_meta, _header, _list, _returning, _options),
    do: raise Prismic.Ecto.WriteError

  @doc false
  def update(_repo, _schema_meta, _fields, _filters, _returning, _options),
    do: raise Prismic.Ecto.WriteError

  @doc false
  def delete(_repo, _schema_meta, _filters, _options),
    do: raise Prismic.Ecto.WriteError
end
