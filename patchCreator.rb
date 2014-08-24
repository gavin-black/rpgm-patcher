require 'fileutils'

def forceOverflow(i)
    if i < -2147483648
        i & 0xffffffff 
    elsif i > 2147483647 
        -(-(i) & 0xffffffff)
    else  
        i
    end    
end

def readInt()
  $s.read(4).unpack('l')[0]
end

def intToBytes(input)
    [input].pack("l").unpack('C*')
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
    fkeyBytes = intToBytes(fkey)
    length = key ^ readInt()

    puts "File: -- Offset: #{offset} -- Size: #{size} --" +
         " Key: #{fkey.to_s(16)} -- Length: #{length}"

    nameEnc = $s.read(length)

    nameDec = ""

    for i in 0..(length - 1)
      nameDec += (nameEnc[i].unpack('C')[0] ^ keyBytes[i%4]).chr
    end

    puts "File name: #{nameDec}"

    prevPos = $s.pos
    $s.pos = offset
    rawDataBytes = $s.read(size).unpack('C*')


    FileUtils.mkdir_p(File.dirname(nameDec))
    out = File.new(nameDec, 'wb')
    outData = "" 

    for i in 0..(size-1)
     if i % 4 == 0 && i != 0
        fkey = forceOverflow(fkey*7 + 3)
        fkeyBytes = intToBytes(fkey)
      end
      outData = (rawDataBytes[i] ^ fkeyBytes[i%4]).chr
      out.write(outData)
    end
    out.close()

    $s.pos = prevPos
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
