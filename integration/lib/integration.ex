defmodule Integration do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = []
    opts = [strategy: :one_for_one, name: Integration.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Integration.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :integration,
    adapter: Prismic.Ecto
end
