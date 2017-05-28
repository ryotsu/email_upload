defmodule Uploader.QueueTest do
  use ExUnit.Case

  alias Uploader.Queue

  setup do
    Application.stop(:uploader)
    :ok = Application.start(:uploader)
  end

  test "queue push" do
    assert Queue.push("World", 2) == :ok
    Queue.push("Hello", 1)
    Queue.push("!", 4_000_000_000_000)
    Queue.push("Somewhere", 30_000_000)
  end
end
