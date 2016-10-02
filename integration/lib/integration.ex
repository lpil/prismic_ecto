defmodule Integration do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Integration.Repo, []),
    ]
    opts = [strategy: :one_for_one, name: Integration.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Integration.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :integration
end

defmodule Integration.Contributor do
  @moduledoc false
  use Ecto.Schema

  schema "contributor" do
    field :color, :string
    field :location, :map
  end
end
