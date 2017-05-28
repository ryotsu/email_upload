defmodule Uploader.StoreTest do
  use ExUnit.Case

  alias Uploader.Store

  setup do
    Application.stop(:uploader)
    Store.start_link()
    :ok
  end

  test "store get and set" do
    assert Store.set(:key, :some_value) == :ok
    assert Store.get(:key) == {:ok, :some_value}
    assert Store.get(:wrong_key) == {:error, :not_found}
  end
end
