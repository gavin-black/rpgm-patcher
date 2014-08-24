def readInt()
  $s.read(4).unpack('l')[0]
end

def unpackV3
  key = readInt()*9 + 3
  keyBytes = [key].pack("l").unpack('C*')
  puts "Key: #{key.to_s(16)} -- #{keyBytes}"

  loop do
    offset = key ^ readInt()
    break if offset <= 0

    size = key ^ readInt()
    fkey = key ^ readInt()
    length = key ^ readInt()

    puts "File: -- Offset: #{offset} -- Size: #{size} --" +
         " Key: #{fkey.to_s(16)} -- Length: #{length}"

    nameEnc = $s.read(length)

    nameDec = ""

    for i in 0..(length - 1)
      nameDec += (nameEnc[i].unpack('C')[0] ^ keyBytes[i%4]).chr
    end

    puts "File name: #{nameDec}"
  end 
end

version = 0
$s = File.new('Game.rgss3a', 'rb')

if $s.read(6) == "RGSSAD"
   $s.read(1)
   version = $s.read(1).unpack('c')
end
if version == 0
  puts "Unsupported"
  exit
end
puts "Version is: #{version[0]}"

unpackV3()
