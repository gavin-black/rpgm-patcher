require 'fileutils'

desc "List available tasks"
task :default do
  sh %{rake -T}
end

desc "Clean remove any testing files"
task :clean do
  FileUtils.mv('Game.rgss3a.patched', 'Game.rgss3a')
  FileUtils.rm_rf('Data/')
  FileUtils.rm_rf('Graphics/')
end

desc "Run patch applying tool"
task :applyPatch do
  ruby "applyPatch.rb"
end

desc "Run patch creation tool"
task :createPatch do
  ruby "createPatch.rb"
end


desc "Create the tool as an executable"
task :exe do
  sh %{ ocra --windows --icon foo.ico applyPatch.rb}
  sh %{ ocra --windows --icon foo.ico createPatch.rb}
  # TODO: Merge the executables into one
end
