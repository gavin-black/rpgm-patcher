#!/bin/env ruby
# encoding: utf-8
# Creates a patching tool for rpgmaker games

require 'Digest'
require 'tk'

def createPatch
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
  exit
end

root = TkRoot.new
btn_OK = TkButton.new(root) do
  text "東方"
  command (proc {createPatch})
  pack("side" => "right",  "padx"=> "50", "pady"=> "10")
end
Tk.mainloop

