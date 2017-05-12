-- I modded the included ScoreReader example,
-- so you could pass along a note duration list,
-- and set a global 'note' variable to the number i of notes[i]

local ScoreReader = class('ScoreReader')

function ScoreReader :initialize(wave_type,  notes,  duration)
  self .wave_type = wave_type
  self .notes = notes
  self .duration = duration

  self .looping = false
  self .tempo = 400
  self :stop()
end


function ScoreReader :update(dt)
  if self .playing then
    self .timer = self .timer + dt

    if self .timer > self .duration[self .current_note] / self .tempo then
      self .timer = 0
      self .current_note = self .current_note + 1
      note = note + 1

      if self .current_note > #self .notes then
        self :stop()
        note = 1
        if self .looping then
          self .playing = true
        end
      end
      self :_playNote(self .current_note)
    end
  end
end


function ScoreReader :play()
  self .playing = true
  self :_playNote(self .current_note)
end


function ScoreReader :stop()
  self .timer = 0
  self .current_note = 1
  self .playing = false
end


function ScoreReader :setLooping(l)
  self .looping = l
end


function ScoreReader :setTempo(t)
  self .tempo = t
end


function ScoreReader :_playNote(n)
  local current_sample = denver .get({ waveform = self .wave_type,
                     frequency = self .notes[n],
                     length = self .duration[n] / self .tempo })
  la .play(current_sample)
end

return ScoreReader
