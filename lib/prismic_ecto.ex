defmodule Prismic.Ecto do
  @moduledoc """
  An Ecto adapter for the Prismic.io CMS API.
  """

  alias Prismic.Ecto.{Query, Response}

  @behaviour Ecto.Adapter

  #
  # Worker processes
  #

  @doc false
  def child_spec(_repo, _opts) do
    Supervisor.Spec.supervisor(Prismic.Ecto.Supervisor, [])
  end

  @doc false
  def ensure_all_started(_repo, _type) do
    {:ok, []}
  end


  # Executes a previously prepared query
  #
  # Callback docs
  # https://hexdocs.pm/ecto/Ecto.Adapter.html#c:execute/6
  #
  # Github Ecto example
  # https://github.com/wojtekmach/github_ecto/blob/master/lib/github_ecto.ex#L35-L61
  #
  # Non-caching SQL example
  # https://github.com/elixir-ecto/ecto/blob/v2.0.5/lib/ecto/adapters/sql.ex#L415-L420
  #
  @doc false
  def execute(_repo, query_meta, query, _params, process, _options) do
    IO.inspect query_meta
    IO.inspect process
    res = %Response{} = Prismic.Ecto.WorkerManager.execute(query)
    {res.count, res.items}
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
  def dumpers(:id, _ecto_type),
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
  defmacro __before_compile__(_env), do: []

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
