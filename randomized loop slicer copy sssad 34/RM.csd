<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>

sr=176400
ksmps=16
nchnls=2

	opcode antialias,aa,aa
ain1,ain2	xin
aout1		butterlp	ain1, sr/2					; left channel low-pass (antialias)
aout1		butterhp	aout1, 20					; left channel high-pass
aout2		butterlp	ain2, sr/2					; left channel low-pass (antialias)
aout2		butterhp	aout2, 20					; left channel high-pass
			xout		aout1, aout2
	endop

gisine	ftgen 0, 0, 4096, 10, 1
giWet		ftgen 0, 0, 1024, -7, 0, 512, 1, 512, 1
giDry		ftgen 0, 0, 1024, -7, 1, 512, 1, 512, 0

instr 1 ; RING MODULATOR

kmix		chnget	"freqshifter_mix"
kfreq		chnget	"freqshifter_freq"
kfreq scale		kfreq, 1000, -1000
kfeedback	chnget	"freqshifter_feedback"
kfeedback scale	kfeedback, 0.7, 0

kWet        table		kmix, giWet, 1
kDry        table		kmix, giDry, 1

gaL, gaR ins

aOutL       init 0
aOutR       init 0
aInL        =	gaL + (aOutL * kfeedback)
aInR        =	gaR + (aOutR * kfeedback)

arealL, aimagL hilbert aInL
arealR, aimagR hilbert aInR

kporttime linseg 0, 0.001, 0.02
kfshift   portk    kfreq, kporttime

asinL       oscili 1, kfshift, gisine, 0
asinR       oscili 1, kfshift, gisine, 0
acosL       oscili 1, kfshift, gisine, .25
acosR       oscili 1, kfshift, gisine, .25

amod1L      = arealL * acosL
amod1R      = arealR * acosR
amod2L      = aimagL * asinL
amod2R      = aimagR * asinR

aOut1L       = (amod1L - amod2L)
aOut1R       = (amod1R - amod2R)

aOutL dcblock2 aOut1L
aOutR dcblock2 aOut1R

gaL         sum aOutL * kWet, gaL * kDry
gaR         sum aOutR * kWet, gaR * kDry

gaL, gaR antialias gaL, gaR

outs gaL, gaR
endin


</CsInstruments>
<CsScore>

i 1 0 36000

</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>517</y>
 <width>634</width>
 <height>188</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>freqshifter_freq</objectName>
  <x>162</x>
  <y>16</y>
  <width>20</width>
  <height>100</height>
  <uuid>{384187be-abd0-4525-a70c-5573c8ab6265}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.01000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>freqshifter_mix</objectName>
  <x>64</x>
  <y>14</y>
  <width>20</width>
  <height>100</height>
  <uuid>{3d0d3180-864b-4e23-9481-f9fac0595ce4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.84000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>freqshifter_mult</objectName>
  <x>243</x>
  <y>17</y>
  <width>20</width>
  <height>100</height>
  <uuid>{fac6b8a0-d3cc-44d3-a373-fc3ddb6daa5f}</uuid>
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
 <bsbObject version="2" type="BSBVSlider">
  <objectName>freqshifter_feedback</objectName>
  <x>321</x>
  <y>16</y>
  <width>20</width>
  <height>100</height>
  <uuid>{882203e8-888e-431a-947e-b1767a62ce80}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.03000000</value>
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
WindowBounds: 0 517 634 188
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {162, 16} {20, 100} 0.000000 1.000000 0.010000 freqshifter_freq
ioSlider {64, 14} {20, 100} 0.000000 1.000000 0.840000 freqshifter_mix
ioSlider {243, 17} {20, 100} 0.000000 1.000000 1.000000 freqshifter_mult
ioSlider {321, 16} {20, 100} 0.000000 1.000000 0.030000 freqshifter_feedback
</MacGUI>
