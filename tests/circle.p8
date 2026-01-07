pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
  print("Starting game...")
  print("Hello world!")
end

x = 64  y = 64
function _update()
  if (btn(0)) then x=x-1 end
  if (btn(1)) then x=x+1 end
  if (btn(2)) then y=y-1 end
  if (btn(3)) then y=y+1 end
end

function _draw()
  cls(5)
  circfill(x,y,7,14)
end

__gfx__

__gff__

__label__

__map__

__sfx__

__music__
