# Creates a patching tool for rpgmaker games

require 'Digest'

ignoreList = ["Save/", "Game.rgss3a.patched"]

orig = '../orig/'
patched = '../patched/'
pSize = patched.length

Dir.glob(patched + '**/*') { |f|
  patchF = f.clone
  f.slice!(0, pSize)
  origF = orig + f
  if File.file?(origF)
    md5A = Digest::MD5.file(patchF).hexdigest
    md5B = Digest::MD5.file(origF).hexdigest
    if md5A != md5B
      puts f
    end
  end 
}

