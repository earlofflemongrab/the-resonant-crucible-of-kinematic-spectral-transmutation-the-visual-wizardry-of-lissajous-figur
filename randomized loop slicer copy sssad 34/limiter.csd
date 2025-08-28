<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>

sr=44100
ksmps=32
nchnls=2

instr 1
gaL inch 1
gaR inch 2

; DC BLOCK
gaL         dcblock2     gaL
gaR         dcblock2     gaR

; LIMITER
kthresh init 0 
klowknee init 80
khighknee init 80
kratio init 100
kattack init 0.001
krel init 0.06
ilook init 0.090 
gaL compress gaL, gaL, kthresh, klowknee, khighknee, kratio, kattack, krel, ilook
gaR compress gaR, gaR, kthresh, klowknee, khighknee, kratio, kattack, krel, ilook

gaL = gaL * 0.5
gaR = gaR * 0.5

outs gaL, gaR 
endin

</CsInstruments>
<CsScore>

i 1 0 36000

e

</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>61</y>
 <width>283</width>
 <height>644</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{eef107f6-f870-485e-adeb-0c94b6042479}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.33000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: 0 61 283 644
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.330000 slider1
</MacGUI>
