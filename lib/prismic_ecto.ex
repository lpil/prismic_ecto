defmodule Prismic.Ecto do
  @moduledoc """
  An Ecto adapter for the Prismic.io CMS API.
  """

  alias Prismic.Ecto.Query

  @behaviour Ecto.Adapter

  #
  # Worker processes
  #

  @doc false
  def child_spec(_repo, _opts) do
    # TODO: Add client process pooling.
    Supervisor.Spec.worker(Prismic.Ecto.Worker, [])
  end

  @doc false
  def ensure_all_started(_repo, _type) do
    {:ok, []}
  end


  # Executes a previously prepared query
  @doc false
  def execute(repo, query_meta, query, params, arg4, options) do
    IO.puts """
    ============================
    Inside Prismic.Ecto.execute/6
      repo: #{inspect repo}
      query_meta: #{inspect query_meta}
      query: #{inspect query}
      params: #{inspect params}
      arg4: #{inspect arg4}
      options: #{inspect options}
    ============================
    """
    entries_count = 1
    items = []
    {entries_count, items}
  end

  # Commands invoked to prepare a query for all.
  @doc false
  def prepare(:all, query) do
    {:nocache, Query.build(query)}
  end
  def prepare(_execution_type, _query) do
    raise Prismic.Ecto.WriteError
  end


  #
  # Type conversion
  #

  @doc false
  def dumpers(:id, ecto_type),
    do: [&{:ok, &1}]
  def dumpers(_primitive_type, ecto_type),
    do: [ecto_type]

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
