defmodule Elixir_Intro do 

  require Enum

  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end

  def area(:rectangle,{width, height}) do width*height end
  def area(:square, width) do width*width end
  def area(:circle, radius) do :math.pi*radius*2 end
  def area(:triangle, {base, height}) do base*height/2 end

  def sqrList(nums) do Enum.map(nums, fn x -> x * x end) end

  def calcTotals(inventory) do Enum.map(inventory, fn x -> {elem(x,0), elem(x,1)*elem(x,2)} end) end

  def map(function, vals) do Enum.map(vals,function) end

  def qsort([]) do [] end
  def qsort(list) do
    pivot=:lists.nth(:rand.uniform(length list), list)
    smaller=for n <- list, n < pivot do n end
    larger=for n <- list, n > pivot do n end
    pivots= for n <- list, n == pivot do n end
    qsort(smaller) ++ pivots ++ qsort(larger)
  end

  def quickSortServer() do
    receive do
      {unsorted, pid} -> send(pid,{qsort(unsorted),self()})
    end
    quickSortServer()
  end

end

defmodule Client do
    def callServer(pid,nums) do
        send(pid, {nums, self()})
        listen()
    end
    def listen() do
        receive do
            {sorted, _} -> sorted
        end
    end
end

#IO.puts Elixir_Intro.fib(0)
#IO.puts Elixir_Intro.fib(1)
#IO.puts Elixir_Intro.fib(2)
#IO.puts Elixir_Intro.fib(3)

#IO.puts Elixir_Intro.area(:rectangle,{5,2})
#IO.puts Elixir_Intro.area(:square,5)
#IO.puts Elixir_Intro.area(:circle,5)
#IO.puts Elixir_Intro.area(:triangle,{5,5})

#IO.inspect [1,4,9,16]
#IO.inspect Elixir_Intro.sqrList([1,2,3,4])

#IO.inspect [{:yo, 2},{:yo1,12},{:yo2,30},{:yo3,56}]
#IO.inspect Elixir_Intro.calcTotals([{:yo,1,2},{:yo1,3,4},{:yo2,5,6},{:yo3,7,8}])

#IO.inspect Elixir_Intro.map(&Elixir_Intro.fib/1,[0,1,2,3,4,5])

#pid = spawn &Elixir_Intro.quickSortServer/0
#IO.inspect Client.callServer(pid,[5,1,23,4,5])
#IO.inspect Client.callServer(pid,[5,1,3,6,8,4,6,8,0,4,3,3,4,5])
