<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>

sr=44100
ksmps=32
nchnls=2

instr 1

gkRvbDryWet		chnget "Mix"
gkfblvl		chnget "Roomsize"
gkfco			chnget "Tone"

gaL inch 1
gaR inch 2

		denorm		gaL, gaR											;...DENORMALIZE BOTH CHANNELS OF AUDIO SIGNAL
		arvbL, arvbR 	reverbsc 	gaL, gaR, gkfblvl, gkfco	;CREATE REVERBERATED SIGNAL (USING UDO DEFINED ABOVE)
		
		asigL = (gaL * (1 - gkRvbDryWet)) + (arvbL  * gkRvbDryWet)
		asigR = (gaR * (1 - gkRvbDryWet)) + (arvbR  * gkRvbDryWet)
		
		outs	asigL, asigR												;SEND REVERBERATED SIGNAL TO AUDIO OUTPUTS

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
 <y>0</y>
 <width>400</width>
 <height>200</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>Mix</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{eef107f6-f870-485e-adeb-0c94b6042479}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>Roomsize</objectName>
  <x>49</x>
  <y>10</y>
  <width>20</width>
  <height>100</height>
  <uuid>{8c57adcf-2a78-4efd-95af-a2e6a3683a51}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.77000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>Tone</objectName>
  <x>98</x>
  <y>12</y>
  <width>20</width>
  <height>100</height>
  <uuid>{24f55c24-c25a-46d8-9b6a-86ba9ad73bb2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>16000.00000000</maximum>
  <value>8480.00000000</value>
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
WindowBounds: 0 61 96 26
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 Mix
ioSlider {49, 10} {20, 100} 0.000000 1.000000 0.770000 Roomsize
ioSlider {98, 12} {20, 100} 0.000000 16000.000000 8480.000000 Tone
</MacGUI>
