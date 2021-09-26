defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  use Agent

  def start_link(_initial_state) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user) do
    Agent.update(__MODULE__, fn agent_state -> update_state(agent_state, user) end)
  end

  defp update_state(agent_state, %User{cpf: cpf} = user) do
    Map.put(agent_state, cpf, user)
  end

  def get(cpf), do: Agent.get(__MODULE__, fn agent_state -> get_user(agent_state, cpf) end)

  defp get_user(agent_state, cpf) do
    case Map.get(agent_state, cpf) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end
