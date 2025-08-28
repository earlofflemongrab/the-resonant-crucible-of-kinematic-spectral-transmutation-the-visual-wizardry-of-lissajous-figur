<CsoundSynthesizer>

<CsOptions>

</CsOptions>

<CsInstruments>

sr	= 	44100
ksmps	= 	16
nchnls	= 	1

instr 1

aptr in

ktrans    chnget "trans"
Sfile	    chnget  "file"                                            ;RECEIVE THE SOUNDFILE PATH FROM PD

ifilen   filelen Sfile
atimpt = ifilen * aptr

	iFile        ftgen    0, 0, 0, 1, Sfile, 0, 0, 1    ;soundfile for source waveform L
	ktab = iFile
	asig mincer atimpt, 5500, ktrans, ktab, 1, 4096

			out		asig
endin

</CsInstruments>

<CsScore>

i 1 0 36000

</CsScore>

</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>22</y>
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
  <objectName>position</objectName>
  <x>32</x>
  <y>123</y>
  <width>20</width>
  <height>100</height>
  <uuid>{adc57364-a7c2-4c0e-8152-d651ea4cd185}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.60000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>trans</objectName>
  <x>165</x>
  <y>94</y>
  <width>20</width>
  <height>100</height>
  <uuid>{7d14a5a9-0a03-4869-af71-a8a8a83d65e2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.13000000</value>
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
WindowBounds: 72 179 400 200
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {32, 123} {20, 100} 0.000000 1.000000 0.600000 position
ioSlider {165, 94} {20, 100} 0.000000 1.000000 0.130000 trans
</MacGUI>
