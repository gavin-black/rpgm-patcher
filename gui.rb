require 'tk'

#require 'tkextlib/bwidget'
require 'tkextlib/tile' 

def updatedLoc
  if $origLoc.value.length > 0
    $extractButton.state = "normal"
    if $patchLoc.value.length > 0
      $patchButton.state = "normal"
    else
      $patchButton.state = "disabled"
    end
  else
    $extractButton.state = "disabled"
    $patchButton.state = "disabled"
  end
  
 
  
end

def browse(loc)
     
  loc.value = Tk.chooseDirectory
  #Thread.new {
  #  puts "HELLO"
  #  $origLoc = Tk.getOpenFile
  #  $btn_OK.state = "disabled"
  #  $btn_OK.state = "normal"
  #  puts "WORLD"
  #}
end


window = TkRoot.new() do
  title "Patch tool"
  geometry "360x247"
end

window['resizable'] = false, false

pTotal = TkVariable.new
pFile = TkVariable.new

isOrig = true 
if isOrig

  yOffs = 140

  $origLoc = TkVariable.new
  TkButton.new(window) do
    place('height' => 25, 'width' => 80, 'x' => 275, 'y' => 10 )
    text "Browse..."
    command (proc {browse $origLoc})
  end

  $patchLoc = TkVariable.new
  $patchLoc.trace('w', proc{ updatedLoc })
  TkButton.new(window) do
    place('height' => 25, 'width' => 80, 'x' => 275, 'y' => 50 )
    text "Browse..."
    command (proc {browse patchLoc})
  end

  TkEntry.new(window) do
    textvariable $origLoc
    place('width' => 180, 'x' => 80, 'y' => 10)
  end

  TkEntry.new(window) do
    textvariable $patchLoc
    place('width' => 180, 'x' => 80, 'y' => 50)
  end

  TkLabel.new(window) do
    text "Original:"
    justify "left"
    place('width' => 70, 'x' => 5, 'y' => 10)
  end

  TkLabel.new(window) do
    text "Patched:"
    justify "left"
    place('width' => 70, 'x' => 5, 'y' => 50)
  end

  $extractButton = TkButton.new(window) do
    place('height' => 35, 'width' => 130, 'x' => 33, 'y' => 90 )
    text "Extract"
    state "disabled"
  end
  $patchButton = TkButton.new(window) do
    place('height' => 35, 'width' => 130, 'x' => 197, 'y' => 90 )
    text "Create Patch"
    state "disabled"
  end
end

totalBar = Tk::Tile::Progressbar.new(window) do
  place('height' => 25, 'width' => 300, 'x' => 50, 'y' => 10 + yOffs)
  maximum 100
  variable pTotal
end

fileBar = Tk::Tile::Progressbar.new(window) do
  place('height' => 25, 'width' => 300, 'x' => 50, 'y' => 50 + yOffs)
  maximum 100
  variable pFile
end

$statusVar = TkVariable.new
TkLabel.new(window) do
  textvariable $statusVar
  borderwidth 3
  relief  "groove"
  place('height' => 25, 'width' => 362, 'x' => -1, 'y' => 85 + yOffs)
  justify 'left'
end

$statusVar.value = "Status"

pTotal.value = 44
pFile.value = 26

Tk::Tile::Separator.new(window) do
   orient 'horizontal'
   place('width' => 350, 'x' => 5, 'y' => 140)
end

TkLabel.new(window) do
  text "Total:"
  justify "left"
  place('width' => 40, 'x' => 5, 'y' => 10 + yOffs)
end

TkLabel.new(window) do
  text "File:"
  justify "left"
  place('width' => 40, 'x' => 5, 'y' => 50 + yOffs)
end


=begin
$resultsVar = TkVariable.new
fileLabel = TkLabel.new(window) do
  #textvariable $resultsVar
  text "HEL"
  pack("side" => "right",  "padx"=> "50", "pady"=> "50")
end

$resultsVar.value = 'New value to display'

=end

Tk.mainloop
