defmodule PlugRedisSessionTest do
  use Amrita.Sweet

  alias Plug.Session.Redis, as: RedisStore

  @default_opts [
    store: RedisStore,
    key: "_my_key",
    namespace: "plug_redis_store:"
  ]

  before_each do
    :ok
  end

  describe "redis_key" do
    it "concatenates namespace and session_id" do
      store = RedisStore.init(@default_opts)

      assert RedisStore.redis_key("abcdefgh", store) == "plug_redis_store:abcdefgh"
    end
  end

  describe "decode_session" do
    it "returns object if object can be decoded" do
      payload = "{\"user_token\":\"KANc0Sjleb2qfWRRxi99Tw\",\"_csrf_token\":\"csrf_token123\"}"

      expected = %{user_token: "KANc0Sjleb2qfWRRxi99Tw", _csrf_token: "csrf_token123"}
      assert RedisStore.decode_session(payload) == expected
    end
  end

  describe "get" do
    it "returns object if found in redis" do
      payload = {:ok, "{\"user_token\":\"KANc0Sjleb2qfWRRxi99Tw\"}"}
      provided [ExredisPool.get(_) |> payload] do
        assert RedisStore.get(nil, "1234", @default_opts) == {"1234", %{user_token: "KANc0Sjleb2qfWRRxi99Tw"}}
      end
    end

    it "returns empty object if not found in redis" do
      payload = {:ok, :undefined}
      provided [ExredisPool.get(_) |> payload] do
        RedisStore.get(nil, "1234", @default_opts) == {nil, %{}}
      end
    end

    it "returns empty object for error in redis" do
      payload = {:error, %{}}
      provided [ExredisPool.get(_) |> payload] do
        RedisStore.get(nil, "1234", @default_opts) == {nil, %{}}
      end
    end
  end
end
