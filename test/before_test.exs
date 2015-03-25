defmodule BeforeTest do

  use ExUnit.Case

  defmodule SomeSpec do
    use ESpec

    before do: {:ok, a: 1}
    it do: "#{__[:a]} is defined"

    context "Context" do
      before do: {:ok, a: 10, b: 2}
      it do: "#{__[:a]} and #{__[:b]} is defined"

      describe "Describe" do
        before do: {:ok, b: fn(a) -> a*2 end}
        it do: "__[:b] is a function"
      end
    end
  end

  setup_all do
    {:ok,
      ex1: Enum.at(SomeSpec.examples, 0),
      ex2: Enum.at(SomeSpec.examples, 1),
      ex3: Enum.at(SomeSpec.examples, 2)
    }
  end

  test "check map in ex1", context do
    map = ESpec.Runner.run_befores(context[:ex1], SomeSpec)
    assert(map[:a] == 1)
  end

  test "run ex1", context do
    example = ESpec.Runner.run_example(context[:ex1], SomeSpec)
    assert(example.result == "1 is defined")
  end

  test "check map in ex2", context do
    map = ESpec.Runner.run_befores(context[:ex2], SomeSpec)
    assert(map[:a] == 10)
    assert(map[:b] == 2)
  end

  test "run ex2", context do
    example = ESpec.Runner.run_example(context[:ex2], SomeSpec)
    assert(example.result == "10 and 2 is defined")
  end

  test "check map in ex3", context do
    map = ESpec.Runner.run_befores(context[:ex3], SomeSpec)
    assert(map[:b].(10) == 20)
  end

end