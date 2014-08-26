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
  sh %{ ocra createPatch.rb --windows C:\\Ruby193\\lib\\tcltk\\ --no-autoload --add-all-core --icon shanghai.ico }
end
