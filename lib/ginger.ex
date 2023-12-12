defmodule Ginger do
  use Application

  def start(_type, _args) do
    main()
    Supervisor.start_link([], [strategy: :one_for_one])
  end

  def main do
    # coming soon
  end

end
