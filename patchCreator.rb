puts "Start"

version = 0
s = File.new('Game.rgss3a', 'rb')
if s.read(6) == "RGSSAD"
   s.read(1)
   version = s.read(1).unpack('c')
end
if version == 0
  puts "Unsupported"
  exit
end
puts "Version is: #{version[0]}"
