defmodule NameServer do
  use GenServer
  require Map
 
  # Start Helper Functions (Don't Modify)
  def start_link() do
    GenServer.start_link(__MODULE__, [], [])
  end
 
  def start() do
    GenServer.start(__MODULE__, [],  [])
  end
 
  def register(name_server, name) do
    GenServer.call(name_server, {:register, name})
  end
 
  def register(name_server, name, pid) do
    GenServer.cast(name_server, {:register, name, pid})
  end
 
  def resolve(name_server, name) do
    GenServer.call(name_server, {:resolve, name})
  end
  #End Helper Functions
 
  def init(_) do
    mymap=%{}
    {:ok, mymap}
  end
 
  def handle_call({:register, name}, pid, mymap) do
    Map.put_new(mymap, name, pid)
    {:reply, :ok, mymap}
  end
 
  def handle_call({:resolve, name}, _, mymap) do
    result=Map.fetch(mymap, name)
    if is_tuple(result) do
      {:reply, elem(result,0), mymap}
    else
      {:reply, result, mymap}
    end
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end
 
  def handle_cast({:register, name}, pid, mymap) do
    spawn fn -> Map.put_new(mymap, name, pid) end
  end
 
  def handle_cast(request, state) do
    super(request, state)
  end
 
  def hande_info(_msg, state) do
    {:noreply, state}
  end
end

defmodule TopSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(Database, [ns]),
      worker(CustomerService, [ns]),
      supervisor(Slave1, [ns])
    ]
 
    supervise(children, strategy: :one_for_all)
  end
end

defmodule Slave1 do
  use Supervisor

  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end

  def init(ns) do
    children = [
      worker(Shipper, [ns]),
      worker(Info, [ns]),
      supervisor(Slave2, [ns])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

defmodule Slave2 do
  use Supervisor

  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end

  def init(ns) do
    children = [
      worker(Order, [ns]),
      worker(User, [ns])
    ]

    supervise(children, strategy: :one_for_all)
  end
end

