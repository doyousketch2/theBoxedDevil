--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  theBoxedDevil - diable en boîte

lo   = love
-- 2 letter
la   = lo .audio
le   = lo .event
lf   = lo .filesystem
lg   = lo .graphics
li   = lo .image
lj   = lo .joystick
lk   = lo .keyboard
lm   = lo .math
lp   = lo .physics
ls   = lo .sound
lt   = lo .timer
lv   = lo .video
lw   = lo .window
-- 3 letter
lfo  = lo .font
lmo  = lo .mouse
lsy  = lo .system
lth  = lo .thread
lto  = lo .touch

HEIGHT = lg .getHeight()
WIDTH  = lg .getWidth()

denver  = require 'libs.denver'  -- waveform gen
class = require 'libs.middleclass'
score = require 'libs.scorereader' -- requires middleclass
song = require 'data.song'
lyrics = require 'data.lyrics'

line = 1
R = 0
W = 0
x = 0
y = 0
wid = 5
quads = {}
frames = 1
frame = 1
note = 1
tempo = 0
previousNote = 1

font = lg .newFont( 15 )
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function lo .load()
  print('Löve App begin')

  lg .setDefaultFilter( 'nearest', 'nearest', 0 )
  karaoke = lg .newText( font,  lyrics[line] )  -- lyrics

  box = lg .newImage('data/box.png')
  lid = lg .newImage('data/lid.png')
  handle = lg .newImage('data/handle.png')

  w = handle :getWidth()
  h = handle :getHeight()
  frames = w / h

  for i = 0,  frames do  -- expects a horizontal strip of animated squares
    quads [#quads + 1] = lg .newQuad( i * h,  0,  h,  h,  handle :getDimensions() )
  end -- i = 0,  frames

  player = score :new('square',  song[1],  song[2])
  player :setLooping(true)
  player :play()
end  -- lo .load

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function lo .update(dt)
  if lmo .isDown(1) or #lto .getTouches() > 0 then

    if lmo .isDown(1) then  -- mouse
      x = lmo .getX()
      y = lmo .getY()
      la .setVolume( x / WIDTH )
      tempo = 800 - y
      player :setTempo( tempo )
    else
      touches = lto .getTouches()  -- phone / tablet
      for i, id in ipairs(touches) do
        x, y = lto .getPosition(id)
        la .setVolume( x / WIDTH )
        tempo = 800 - y
        player :setTempo( tempo )
      end -- i, id in ipairs
    end -- lmo .isDown  mouse

    if note ~= previousNote or lm .random( 1,  HEIGHT * 4 -y ) > lm .random( 1,  (y * y) ) then  -- turn handle
      frame = frame + 1
      if frame > frames then
        frame = 1
      end -- frame > frames
    end -- note ~= previousNote or lm .random

    if note ~= previousNote then  -- update text
      phrases = {1,  10,  17,  26,  31,  40,  47,  54}
      for i = 1, #phrases do
        if note == phrases[i] then
          line = line + 1
          if line > #lyrics then
            line = 1
          end -- line > #lyrics
          karaoke :set( lyrics[line] )
        end -- note > phrases[i]
      end -- i,  #phrases
      previousNote = note
    end -- note ~= previousNote

    player :update(dt)
  end -- lmo or #lto
end -- lo .update(dt)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function lo .draw()
-- handle
  lg .draw( handle,  quads[frame],  WIDTH * .6,  HEIGHT / 2,  0,  6,  6 )

-- box
  lg .draw( box,  WIDTH / 3,  HEIGHT / 2,  0,  14,  14 )

-- pop
  if note == 26 or note == 54 then
    R = 150
    W = 18
    lg .draw( lid,  WIDTH / 3,  HEIGHT / 5,  0,  14,  14 )
  else
    R = 0
    W = 0
  end  -- note ==

-- border
  vol = la .getVolume()
  lg .setLineWidth( wid * 2 + W )
  lg .setColor( R,  vol * tempo,  vol * tempo / 2 )
          -- topL,            topR,           bottomR,           bottomL,         topL again
  lg .line(wid, wid,  WIDTH-wid, wid,  WIDTH-wid, HEIGHT-wid,  wid, HEIGHT-wid,  wid, wid)

-- lyrics
  lg .setColor( 255,  255,  255 )
  lg .draw( karaoke,  WIDTH * .1,  HEIGHT * .05,  0,  2,  2 )
end  -- lo .draw

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function lo .quit()
  print('Löve App exit')
end  -- lo .quit

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
