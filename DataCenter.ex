defmodule Database do
  use GenServer
 
  def start_link(name_server, opts \\ []) do
    GenServer.start_link(__MODULE__, name_server, [])
  end
 
  def start(name_server) do
    GenServer.start(__MODULE__, name_server,  [])
  end
 
  def call(mod) do
    GenServer.call(mod, "Message")
  end
 
  def kill(mod) do
    Process.exit(mod, "killed")
  end
 
  def init(ns) do
    # DB has no Depends
    IO.puts Atom.to_string(__MODULE__) <> " has started"
    NameServer.register(ns, :Database, self())
    {:ok, []}
  end
 
  def handle_call(_request, _From, state) do
    #check Depends
    {:reply, :ok, state}
  end
 
 
  def handle_cast(_request, state) do
    #check Depends (none)
    {:noreply, state}
  end
 
  def handle_info(_, state) do
    #checkDepends (none)
    {:noreply, state}
  end
end
 
 
 
 
defmodule CustomerService do
  use GenServer
 
  def start_link(name_server, opts \\ []) do
    GenServer.start_link(__MODULE__, name_server, [])
  end
 
  def start(name_server) do
    GenServer.start(__MODULE__, name_server,  [])
  end
 
  def call(mod) do
    GenServer.call(mod, "Message")
  end
 
  def kill(mod) do
    Process.exit(mod, "killed")
  end
 
  def init(ns) do
    # DB has no Depends
    IO.puts Atom.to_string(__MODULE__) <> " has started"
    NameServer.register(ns, :CustomerService, self())
    {:ok, []}
  end
 
  def handle_call(_request, _From, state) do
    #check Depends
    {:reply, :ok, state}
  end
 
  def handle_cast(_request, state) do
    #check Depends (none)
    {:noreply, state}
  end
 
  def handle_info(_, state) do
    #checkDepends (none)
    {:noreply, state}
  end
end
 
 
defmodule Info do
  use GenServer
 
  def start_link(name_server, opts \\ []) do
    GenServer.start_link(__MODULE__, name_server, [])
  end
 
  def start(name_server) do
    GenServer.start(__MODULE__, name_server,  [])
  end
 
  def call(mod) do
    GenServer.call(mod, "Message")
  end
 
  def kill(mod) do
    Process.exit(mod, "killed")
  end
 
  def init(ns) do
    # DB has no Depends
    IO.puts Atom.to_string(__MODULE__) <> " has started"
    NameServer.register(ns, :Info, self())
    send self(), {:start, ns}
    {:ok, []}
  end
 
  def handle_call(_request, _From, state) do
    if ! check_alive(state) do
      {:stop, "dependency not found", "dependency not found", state}
    end
    {:reply, :ok, state}
  end
 
  def check_alive(processes) do
    x = Enumerable.map(processes, &Process.alive/0)
    reducer =  fn l, r -> l and r end
    Enumberable.reduce(x, true, reducer)
  end
 
  def handle_cast(_request, state) do
    #check Depends (none)
    {:noreply, state}
  end
 
  def handle_info({:start, ns}, _state) do
    :timer.sleep(500)
    case NameServer.resolve(ns, :Database) do
      :error -> {:stop, "No Database Found", []}
      x -> {:noreply, [x]}
    end
  end
 
  def handle_info(_, state) do
    #checkDepends (none)
    {:noreply, state}
  end
end
 
defmodule Order do
  use GenServer
 
  def start_link(name_server, opts \\ []) do
    GenServer.start_link(__MODULE__, name_server, [])
  end
 
  def start(name_server) do
    GenServer.start(__MODULE__, name_server,  [])
  end
 
  def call(mod) do
    GenServer.call(mod, "Message")
  end
 
  def kill(mod) do
    Process.exit(mod, "killed")
  end
 
  def init(ns) do
    # DB has no Depends
    IO.puts Atom.to_string(__MODULE__) <> " has started"
    NameServer.register(ns, :Order, self())
    send self(), {:start, ns}
    {:ok, []}
  end
 
  def handle_call(_request, _From, state) do
    if ! check_alive(state) do
      {:stop, "dependency not found", "dependency not found", state}
    end
    {:reply, :ok, state}
  end
 
  def check_alive(processes) do
    x = Enumerable.map(processes, &Process.alive/0)
    reducer = fn l, r -> l and r end
    Enumberable.reduce(x, true, reducer)
  end
 
  def handle_cast(_request, state) do
    #check Depends (none)
    {:noreply, state}
  end
 
  def handle_info({:start, ns}, _state) do
    :timer.sleep(500)
    case NameServer.resolve(ns, :Database) do
      :error -> {:stop, "No Database Found", []}
      x ->
        case NameServer.resolve(ns, :User) do
          :error -> {:stop, "User Module not Found", []}
          y -> {:noreply, [x, y]}
        end
    end
  end
 
  def handle_info(_, state) do
    #checkDepends (none)
    {:noreply, state}
  end
end
 
defmodule Shipper do
  use GenServer
 
  def start_link(name_server, opts \\ []) do
    GenServer.start_link(__MODULE__, name_server, [])
  end
 
  def start(name_server) do
    GenServer.start(__MODULE__, name_server,  [])
  end
 
  def call(mod) do
    GenServer.call(mod, "Message")
  end
 
  def kill(mod) do
    Process.exit(mod, "killed")
  end
 
  def init(ns) do
    # DB has no Depends
    IO.puts Atom.to_string(__MODULE__) <> " has started"
    NameServer.register(ns, :Shipper, self())
    send self(), {:start, ns}
    {:ok, []}
  end
 
  def handle_call(_request, _From, state) do
    if ! check_alive(state) do
      {:stop, "dependency not found", "dependency not found", state}
    end
    {:reply, :ok, state}
  end
 
  def check_alive(processes) do
    x = Enumerable.map(processes, &Process.alive/0)
    reducer = fn l, r -> l and r end
    Enumberable.reduce(x, true, reducer)
  end
 
  def handle_cast(_request, state) do
    #check Depends (none)
    {:noreply, state}
  end
 
  def handle_info({:start, ns}, _state) do
    :timer.sleep(500)
    case NameServer.resolve(ns, :Database) do
      :error -> {:stop, "No Database Found", []}
      x ->{:noreply, [x]}
 
    end
  end
 
  def handle_info(_, state) do
    #checkDepends (none)
    {:noreply, state}
  end
end
 
defmodule User do
  use GenServer
 
  def start_link(name_server, opts \\ []) do
    GenServer.start_link(__MODULE__, name_server, [])
  end
 
  def start(name_server) do
    GenServer.start(__MODULE__, name_server,  [])
  end
 
  def call(mod) do
    GenServer.call(mod, "Message")
  end
 
  def kill(mod) do
    Process.exit(mod, "killed")
  end
 
  def init(ns) do
    # DB has no Depends
    IO.puts Atom.to_string(__MODULE__) <> " has started"
    NameServer.register(ns, :User, self())
    send self(), {:start, ns}
    {:ok, []}
  end
 
  def handle_call(_request, _From, state) do
    if ! check_alive(state) do
      {:stop, "dependency not found", "dependency not found", state}
    end
    {:reply, :ok, state}
  end
 
  def check_alive(processes) do
    x = Enumerable.map(processes, &Process.alive/0)
    reducer = fn l, r -> l and r end
    Enumberable.reduce(x, true, reducer)
  end
 
  def handle_cast(_request, state) do
    #check Depends (none)
    {:noreply, state}
  end
 
  def handle_info({:start, ns}, _state) do
    :timer.sleep(500)
    case NameServer.resolve(ns, :Database) do
      :error -> {:stop, "No Database Found", []}
      x ->
        case NameServer.resolve(ns, :Order) do
          :error -> {:stop, "User Module not Found", []}
          y -> {:noreply, [x, y]}
        end
    end
  end
 
  def handle_info(_, state) do
    #checkDepends (none)
    {:noreply, state}
  end
 
end
 
defmodule Crasher do
 
  def crash(ns, name) do
    IO.puts("Crashing the module...")
    pid = GenServer.call(ns, {:resolve, name})
    Process.exit(pid, :kill)
  end
 
end








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
      {:reply, elem(result,1), mymap}
    else
      {:reply, result, mymap}
    end
  end

  def handle_call(request, from, state) do
    super(request, from, state)
  end
 
  def handle_cast({:register, name}, pid, mymap) do
    mymap=Map.put(mymap,name,pid)
    {:reply, :ok, mymap}
  end
 
  def handle_cast({:register, name, pid}, mymap) do
    mymap=Map.put(mymap, name, pid)
    {:noreply, mymap}
    # spawn fn -> Map.put_new(mymap, name, pid) end
  end

  def handle_cast(request, state) do
    super(request, state)
  end
end

defmodule TopSupervisor do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(CustomerService, [ns]),
      supervisor(Slave0, [ns])
    ]
 
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Slave0 do
  use Supervisor
 
  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns )
  end
 
  def init(ns) do
    children = [
      worker(Database, [ns]),
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

#{response1,name_server} = NameServer.start_link()
#response2 = TopSupervisor.start_link( name_server )
#IO.puts("Crashing Info (Dependencies: Null)")
#Crasher.crash(name_server, :Info)
#:timer.sleep(3000);
#IO.puts("Crashing Order (Dependencies: User)")
#Crasher.crash(name_server, :Order)
#:timer.sleep(3000);
#IO.puts("Crashing User (Dependencies: Order)")
#Crasher.crash(name_server, :User)
#:timer.sleep(3000);
#IO.puts("Crashing CustomerService (Dependencies: Null)")
#Crasher.crash(name_server, :CustomerService)
#:timer.sleep(3000);
#IO.puts("Crashing Shipper (Dependencies: Null)")
#Crasher.crash(name_server, :Shipper)
#:timer.sleep(3000);
#IO.puts("Crashing Database (Dependencies: Info, Order, Shipper, User)")
#Crasher.crash(name_server, :Database)




