#!/bin/env ruby
# encoding: utf-8
# Creates a patching tool for rpgmaker games

require 'Digest'
require 'fileutils'
load './archive.rb'

def createPatch
  ignoreList = ["Save/", "Game.rgss3a.patched"]
  orig = '../orig/'
  patched = '../patched/'
  pSize = patched.length

  s = makeExe

  Dir.glob(patched + '**/*') { |f|
    patchF = f.clone
    f.slice!(0, pSize)
    origF = orig + f
    if File.file?(origF)
      md5A = Digest::MD5.file(patchF).hexdigest
      md5B = Digest::MD5.file(origF).hexdigest
      if md5A != md5B
        archive(patchF, f, s)
      end
    end 
  }
  s.close
end

def makeExe
  FileUtils.cp('createPatch.exe', 'patch.exe')
  s = File.new('patch.exe','ab')
  s
end

createPatch
