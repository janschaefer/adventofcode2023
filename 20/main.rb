
class Pulse 
  attr_reader :from
  attr_reader :to
  attr_reader :high

  def initialize(from, to, high)
    @from = from
    @to = to
    @high = high
  end
end

class Broadcaster
  attr_reader :name
  attr_reader :highPulseCount
  attr_reader :lowPulseCount
  attr_reader :destinations
  attr_reader :inputs
  
  def initialize(name)
    @name = name
    @destinations = []
    @highPulseCount = 0
    @lowPulseCount = 0
    @inputs = []
  end

  def addDestination(destination) 
    @destinations << destination
  end
  
  def addInput(input)
    @inputs << input
  end

  def process(input, high)
    @destinations.map do |destination|
      Pulse.new(self, destination, high)
    end
  end
end

class FlipFlop < Broadcaster
  def initialize(name)
    super
    @state = false
  end

  def process(input, high)
    if high 
      return []
    end

    @state = ! @state

    super(input, @state)
  end  
end

class Conjunction < Broadcaster 
  def initialize(name)
    super
    @input_states = {}
  end

  def addInput(input)
    super
    @input_states[input.name] = false
  end

  def process(input, high) 
    @input_states[input.name] = high

    # puts @input_states
    all_high = ! @input_states.values.include?(false)

    super(self, ! all_high)    
  end
end


def parse(file)

  modules = {}
  destinationNames = {}
  
  lines = File.open(file, 'r').readlines

  lines.each do |line|
    splitted = line.split(' -> ')
    if splitted[0] == 'broadcaster'
      m = Broadcaster.new(splitted[0])
    elsif splitted[0][0] == '%'
      m = FlipFlop.new(splitted[0][1..])
    else
      m = Conjunction.new(splitted[0][1..])
    end

    destinationNames[m.name] = splitted[1].strip.split(', ')
    modules[m.name] = m
  end

  modules.values.each do |m|
    destinationNames[m.name].each do |destinationName|
      dest = modules[destinationName]
      if dest == nil
        dest = Broadcaster.new(destinationName)
        modules[destinationName] = dest
      end
      m.addDestination(dest)
      dest.addInput(m)
    end
  end

  return modules
end

def solve(modules)
  sumHighPulses = 0
  sumLowPulses = 0

  broadcaster = modules['broadcaster']

  button = Broadcaster.new("button")
  button.addDestination(broadcaster)

  1000.times.each do |i|
    
    pulses = button.process(broadcaster, false)

   # puts "button ==="
    
    while ! pulses.empty? 
      pulse, *rest = pulses

      # puts "#{pulse.from.name} - #{pulse.high} > #{pulse.to == nil ? "nil" : pulse.to.name}"
      
      if pulse.high
        sumHighPulses += 1
      else
        sumLowPulses += 1
      end

      if pulse.to != nil
        newPulses = pulse.to.process(pulse.from, pulse.high)
      else
        newPulses = []
      end
      
      pulses = rest.concat(newPulses)
    end
  end

  modules.values.each do |m|
    sumHighPulses += m.highPulseCount
    sumLowPulses += m.lowPulseCount
  end

  puts (sumHighPulses * sumLowPulses)
end

  
def getButtonPressesUntilHigh(modules, mname)
    broadcaster = modules['broadcaster']

    button = Broadcaster.new("button")
    button.addDestination(broadcaster)
  
    buttonPresses = 0;
  
    while true
      pulses = button.process(broadcaster, false)
      buttonPresses += 1
  
      while ! pulses.empty? 
        pulse, *rest = pulses
  
        if pulse.high
          if pulse.from.name == mname
              return buttonPresses
          end
        end
  
        newPulses = pulse.to.process(pulse.from, pulse.high)
   
        pulses = rest.concat(newPulses)
      end
    end
  
    puts buttonPresses
  
end

def solve2(filename)

    modules = parse(filename)

    # this is actually a solution crafted to the input and not a general solution.
    rx = modules['rx']    
    n = rx.inputs[0]

    buttonPresses = []
    n.inputs.each do |i| 
        freshModules = parse(filename)
        buttonPresses << getButtonPressesUntilHigh(freshModules, i.name)
    end
    puts buttonPresses.reduce(:lcm)
    

end



filename = "input"
solve(parse(filename))
solve2(filename)
