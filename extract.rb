# Extracts encrypted rpgmaker archives and applies patches
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
  total = 16
  loop do
    offset = key ^ readInt()
    if defined? updateStatus
    end
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
    if defined? updateStatus
      updateStatus("Extract: #{nameDec}", 0, (100*total / $s.size).ceil)
    end

    prevPos = $s.pos
    $s.pos = offset
    rawDataBytes = $s.read(size).unpack('C*')


    FileUtils.mkdir_p(File.dirname(nameDec))
    out = File.new(nameDec, 'wb')
    outData = "" 
    percentCount = 0
    updateMod = (size/100).ceil | 1 # only update 100 times
    
    for i in 0..(size-1)
     if i % 4 == 0 && i != 0
        fkey = forceOverflow(fkey*7 + 3)
        fkeyBytes = intToBytes(fkey)
      end
      if i % updateMod == 0
        percentCount += 1
        if defined? updateStatus
          updateStatus(nil, percentCount, nil)
        end
      end
      outData = (rawDataBytes[i] ^ fkeyBytes[i%4]).chr
      out.write(outData)
    end
    out.close()
    total += size + length + 12
    $s.pos = prevPos
  end 
end

def checkVersion()
  version = 0

  if $s.read(6) == "RGSSAD"
    $s.read(1)
    version = $s.read(1).unpack('c')
  end
  if version == 0
    puts "Unsupported"
    exit
  end
  puts "Version is: #{version[0]}"
end

def extract(dir)
#  puts Encoding.aliases
  puts dir.encoding
  dir.force_encoding("SHIFT_JIS").encode!
  puts dir.encoding
  puts dir
  if File.file?(dir + '/Game.rgss3a.patched')
    puts "TODO: Call extract portion"
  else
    $s = File.new(dir + '/Game.rgss3a', 'rb')
    puts (dir + '/Game.rgss3a')
    puts $s
    checkVersion()
    unpackV3()
    $s.close
    if defined? updateStatus
      updateStatus("Completed", 0, 100)
    end
    FileUtils.mv('Game.rgss3a', 'Game.rgss3a.patched')
  end
end

#extract "C:\\AeSoft\\rpgt"
