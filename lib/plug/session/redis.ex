defmodule Plug.Session.Redis do
  @behaviour Plug.Session.Store
  @max_tries 100

  def init(opts) do
    namespace = Keyword.get(opts, :namespace) || ""

    %{namespace: namespace}
  end

  def get( _conn, session_id, opts) do
    case redis_key(session_id, opts) |> ExredisPool.get do
      {:ok, object} when is_binary(object) ->
        {session_id, decode_session(object)}
      {:ok, :undefined} ->
        {nil, %{}}
      _ ->
        {nil, %{}}
    end
  end

  def decode_session(object) do
    case Poison.Parser.parse(object, keys: :atoms) do
      {:ok, object} ->
        object
      {:error, _} ->
        %{}
    end
  end

  def redis_key(session_id, opts) when is_binary(session_id) do
    [opts[:namespace], session_id] |> Enum.join
  end

  def put( _conn, sid, _data, _opts) do
    sid
  end

  def delete( _conn, _sid, _opts) do
    :ok
  end
end
