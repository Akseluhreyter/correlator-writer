# Andrew Bryant -- abryan39
# 11 November 2019
#
# This program generates C++ code for setting user defined Correlator helper 
# class objects for use in Rivet.

class CorrelatorWriter

  attr_accessor :comment, :name, :coll_system_and_energy, :centrality, 
                :trigger_range, :associated_range, :azimuthal_range

  def initialize(comment: "", name: "", coll_system_and_energy: "", centrality: 0..0, 
                  trigger_range: 0..0, associated_range: 0..0, 
                  azimuthal_range: 0..0)
    @comment = comment
    @name = name
    @coll_system_and_energy = coll_system_and_energy
    @centrality = centrality
    @trigger_range = trigger_range
    @associated_range = associated_range
    @azimuthal_range = azimuthal_range    
  end
  
  # Writes the code to stdout. 
  def write()
    puts "// #{@comment}" unless @comment.empty?
    puts "Correlator #{@name}();"
    puts "#{@name}.SetCollSystemAndEnergy(#{@coll_system_and_energy});"
    puts "#{@name}.SetCentrality(#{@centrality.min}, #{@centrality.max});"
    puts "#{@name}.SetTriggerRange(#{@trigger_range.min}, #{@trigger_range.max});"
    puts "#{@name}.SetAssociatedRange(#{@associated_range.min}, #{@associated_range.max});"
    puts "#{@name}.SetAzimuthalRange(#{@azimuthal_range.min}, #{@azimuthal_range.max});"
    puts "Correlators.push_back(#{@name});"
  end
end

# Holds methods dealing with parsing arguments
class Parser
  # Parses a given line into arguments
  def self.as_args(line, limit=2)
    line.strip.split(" ", limit)
  end  
  
  # Parses string range in the form min..max
  def self.as_range(range_string)
    endpoints = range_string.split("..").map { |e| Float(e) }
    endpoints.first..endpoints.last
  end
  
  def self.as_string(value)
    String(value)
  end
end

if ARGV[0] == "-i"
  puts "Interactive mode!"
  
  parser = Parser.new
  correlator_writer = CorrelatorWriter.new
  
  loop do
    line = STDIN.gets.chomp
  
    command, arg = Parser.as_args(line)
  
    case command
    when ":quit", ":q" 
      puts "Quiting!"
      break
    when ":write", ":w"
      correlator_writer.write()
    when ":x"
      correlator_writer.write()
      break
    when ":h"
      puts "Help: Read the script :^)"
    when ":name"
      correlator_writer.name = Parser.as_string(arg)
    when ":coll_system_and_energy", ":CollSystemAndEnergy", ":cse"
      correlator_writer.coll_system_and_energy = Parser.as_string(arg)
    when ":centrality", ":cen"
      correlator_writer.centrality = Parser.as_range(arg)
    when ":trigger_range", ":trr"
      correlator_writer.trigger_range = Parser.as_range(arg)
    when ":associated_range", ":asr"
      correlator_writer.associated_range = Parser.as_range(arg)
    when ":azimuthal_range", ":azr"
      correlator_writer.azimuthal_range = Parser.as_range(arg)
    when ":comment", "com"
      correlator_writer.comment = Parser.as_string(arg)
    when nil
      # Do nothing. We just want some space.
    else
      puts "#{command} is not a valid command!"
    end
  end
else
  name = Parser.as_string(ARGV[0])
  coll_system_and_energy = Parser.as_string(ARGV[1])
  centrality = Parser.as_range(ARGV[2])
  trigger_range = Parser.as_range(ARGV[3])
  associated_range = Parser.as_range(ARGV[4])
  azimuthal_range = Parser.as_range(ARGV[5])
  comment = Parser.as_string(ARGV[6])

  correlator = CorrelatorWriter.new(name: name, coll_system_and_energy: coll_system_and_energy, centrality: centrality,
                                    trigger_range: trigger_range, associated_range: associated_range,
                                    azimuthal_range: azimuthal_range, comment: comment)                            
  correlator.write()
end
