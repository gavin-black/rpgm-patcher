def archive(file, arc)
  append = File.read(file)
  arc.write([file.length].pack('N'))
  arc.puts file
  arc.write([append.length].pack('N'))
  arc.puts append
end


def extract(arc)
  aSize = arc.size

  loop do
    break if arc.pos == aSize
    fileNameLen = arc.read(4).unpack('N');
    puts fileNameLen
    fileName = arc.read(fileNameLen[0])
    arc.read(1)
    fileLen = arc.read(4).unpack('N');
    puts fileLen
    outFile = arc.read(fileLen[0])

    puts File.dirname(fileName)
    tmp = File.new(File.basename(fileName), 'wb')
    tmp.puts outFile
    tmp.close
  end

end

#s = File.new('archiver', 'wb')
#archive("tes", s)
#s.close  

#y = File.new('archiver', 'rb')
#extract(y)
#y.close
