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

    rawData = $s.read(size)
    outData = "" 

    j = 0
    for i in 0..(size-1)
      if j == 4
        fkey = fkey*7 + 3
        fkeyBytes = intToBytes(fkey)
        j = 0
      end
      outData += (rawData[i].unpack('C')[0] ^ fkeyBytes[j]).chr
      j += 1
    end
      
    out = File.new(nameDec, 'wb')
    out.write(outData)
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


=begin
    Private Function DecryptFileData(ByVal bFileData As Byte(), ByVal key As Integer) As Byte()
        Dim fDecrypt(bFileData.Length - 1) As Byte

        Dim iTempKey As Integer = key
        Dim bTempKey As Byte() = BitConverter.GetBytes(key)
        Dim j As Integer = 0

        For i As Integer = 0 To bFileData.Length - 1

            If j = 4 Then
                j = 0
                iTempKey *= 7
                iTempKey += 3
                bTempKey = BitConverter.GetBytes(iTempKey)
            End If

            fDecrypt(i) = bFileData(i) Xor bTempKey(j)

            j += 1
        Next i

        Return fDecrypt
    End Function

    Private Sub ExtractFile(ByVal fnmb As Integer)
        If sOpenPath <> "" Then
            Dim fData As Byte()
            Dim sOutFile As String = sExtract & FILE_Name(fnmb)

            Dim br As New BinaryReader(File.OpenRead(sOpenPath))
            br.BaseStream.Seek(FILE_Offset(fnmb), SeekOrigin.Begin)
            fData = br.ReadBytes(FILE_Size(fnmb))
            br.Close()

            If Directory.Exists(Path.GetDirectoryName(sOutFile)) = False Then
                Directory.CreateDirectory(Path.GetDirectoryName(sOutFile))
            End If

            DeleteFileIfExist(sOutFile)

            Dim bw As New BinaryWriter(File.OpenWrite(sOutFile))

            If bVersion = 1 Or bVersion = 3 Then
                bw.Write(DecryptFileData(fData, FILE_Key(fnmb)))
            End If

            bw.Close()

        End If
    End Sub

=end
