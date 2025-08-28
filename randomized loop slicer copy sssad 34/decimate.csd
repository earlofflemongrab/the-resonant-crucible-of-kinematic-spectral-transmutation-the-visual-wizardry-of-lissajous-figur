<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

opcode	LoFi,a,akk
	ain,kbits,kfold	xin									;READ IN INPUT ARGUMENTS
	kfold		port		kfold,0.008
	kfold		expcurve	kfold,500						;CREATE AN EXPONENTIAL REMAPPING OF kfold
	kfold		scale	kfold,1024,1							;RESCALE 0 - 1 VALUE TO 1 - 1024	
	kvalues		pow	2, ((1-(kbits^0.25))*15)+1					;RAISES 2 TO THE POWER OF kbitdepth. THE OUTPUT VALUE REPRESENTS THE NUMBER OF POSSIBLE VALUES AT THAT PARTICULAR BIT DEPTH
	k16bit		pow	2, 16								;RAISES 2 TO THE POWER OF 16
	aout		=	(int((ain*32768*kvalues)/k16bit)/32768)*(k16bit/kvalues)	;BIT DEPTH REDUCE AUDIO SIGNAL
	aout		fold 	aout, kfold							;APPLY SAMPLING RATE FOLDOVER
		xout	aout									;SEND AUDIO BACK TO CALLER INSTRUMENT
endop

instr 1
kbits chnget "bits"
kfold chnget "fold"
a1,a2	ins
a1	LoFi	a1,kbits*0.6,kfold
a2	LoFi	a2,kbits*0.6,kfold
	outs	a1,a2
endin

</CsInstruments>

<CsScore>
i 1 0 36000
</CsScore>

</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>72</x>
 <y>179</y>
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
  <objectName>bits</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{98eba60f-d42a-49b9-bd3b-254d17d32b9d}</uuid>
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
  <objectName>fold</objectName>
  <x>46</x>
  <y>10</y>
  <width>20</width>
  <height>100</height>
  <uuid>{fe3e943f-fd11-4247-a258-5fdba831609f}</uuid>
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
  <objectName>level</objectName>
  <x>14</x>
  <y>157</y>
  <width>20</width>
  <height>100</height>
  <uuid>{6b86ced0-16eb-4702-bcc9-9ce332857f2a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>1.00000000</value>
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
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 bits
ioSlider {46, 10} {20, 100} 0.000000 1.000000 0.000000 fold
ioSlider {14, 157} {20, 100} 0.000000 1.000000 1.000000 level
</MacGUI>
