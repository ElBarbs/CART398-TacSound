use_bpm 120

freq = 120
amp = 0
index = 0
fx = 1
release = 1
phase = 0.5

live_loop :main do
  freq, amp, index, fx, release, phase = sync "/osc*/wek/outputs"
  if freq < 30
    freq = 30
  end
  if amp < 0
    amp = 0
  end
  if release < 0
    release = 0
  end
  if phase < 0
    phase = 0.1
  end
end

BUZZ_SLEEP = 0.5
live_loop :ambi do
  with_fx :slicer do
    with_fx :ring_mod, freq: freq, amp: amp do
      sample :ambi_soft_buzz, release: rrand(0.1, release)
    end
  end
  sleep BUZZ_SLEEP
end

HAT_TIMES = [1,2,3,6]
live_loop :hat do
  HAT_TIMES[index].times do
    sample :hat_gem, amp: amp
    sleep 0.25
  end
  sleep 0.75
end

HAT2_SLEEP_TIME = HAT_TIMES[index] * 0.25
live_loop :hat2 do
  sample :hat_cats, amp: amp
  sleep HAT2_SLEEP_TIME
end

live_loop :bass do
  2.times do
    sample :bd_klub, amp: amp, release: release
    sleep 0.25
  end
  sleep 1
end

live_loop :bass2 do
  sample :bd_ada, amp: amp, release: release
  sleep 2
end

SNARE_PULSE_WIDTH = 0.75
live_loop :snare do
  if fx == 1
    with_fx :slicer, pulse_width: SNARE_PULSE_WIDTH, phase: phase, amp: 0.75 do
      sample :sn_dolf, amp: amp
    end
  else
    sample :sn_dolf, amp: amp
  end
  sleep 2
end

TABLA_TIMES = [2,4]
live_loop :tabla do
  choose(TABLA_TIMES).times do
    sample :tabla_te2, amp: amp
    sleep 0.25
  end
  sleep 2
end

DRUM_TIMES = [1, 2, 4, 8]
live_loop :drum do
  DRUM_TIMES[index].times do
    sample :drum_tom_hi_hard, amp: amp
    sleep 0.25
  end
  sleep 4
end

SYNTH_BASS_PULSE = 0.85
SYNTH_BASS_PHASE = 0.25
live_loop :synth_bass do
  use_synth :bass_foundation
  with_fx :wobble, wave: 1, pulse_width: SYNTH_BASS_PULSE, phase: SYNTH_BASS_PHASE do
    play :e3, attack: 0.85, release: release, amp: amp
  end
  sleep 4
end

PERC_PHASE = 0.5
live_loop :perc do
  3.times do
    with_fx :echo, phase: PERC_PHASE do
      sample :perc_snap, release: rrand(0.1, release), amp: amp
    end
    sleep 0.25
  end
  sleep 7.25
end

live_loop :wood do
  with_fx :ping_pong do
    sample :elec_wood, rate: 0.5, amp: amp
  end
  sleep 8
end

live_loop :snare do
  if fx == 1
    sample :elec_lo_snare, amp: amp
  end
  sleep 1
end

live_loop :ambi_glass do
  if release >= 0.25
    sample :ambi_glass_hum, amp: amp
  end
  sleep choose([2, 4])
end

live_loop :ambi_buzz do
  if phase <= 0.4
    sample :ambi_soft_buzz, amp: amp
  end
  sleep 1
end

live_loop :ambi_dark do
  if phase >= 0.45
    sample :ambi_dark_woosh, amp: amp
  end
  sleep 4
end
