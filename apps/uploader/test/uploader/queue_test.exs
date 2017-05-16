defmodule Uploader.QueueTest do
  use ExUnit.Case

  alias Uploader.Queue

  setup do
    {:ok, _queue} = Queue.start_link
    :ok
  end

  test "push and pop" do
    assert Queue.push("World", 2) == :ok
    Queue.push("Hello", 1)
    Queue.push("!", 4)
    Queue.push("Somewhere", 3)

    assert Queue.pop() == ["Hello"]
    assert Queue.pop(2) == ["World", "Somewhere"]
    assert Queue.pop(2) == ["!"]
    assert Queue.pop() == []
  end
end
