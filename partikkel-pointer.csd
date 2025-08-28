<CsoundSynthesizer>
<CsOptions>
; activate real-time audio output and suppress note printing 
</CsOptions>
<CsInstruments>

;example by Oeyvind Brandtsegg
sr = 44100 
ksmps = 512 
nchnls = 2 
0dbfs = 1


/*
PartikkelSimpB - The same as PartikkelSimpA, but with a time pointer input

DESCRIPTION
The same as PartikkelSimpA, but with a time pointer input

SYNTAX
apartikkel PartikkelSimpB ifiltab, apnter, kgrainamp, kgrainrate, kgrainsize, kcent, kposrand, kcentrand, icosintab, idisttab, iwin

INITIALIZATION
ifiltab:	function table with the input sound file (usually with GEN01)
icosintab:	function table with cosine (e.g. giCosine ftgen 0, 0, 8193, 9, 1, 1, 90)
idisttab:	function table with distribution (e.g. giDisttab ftgen 0, 0, 32768, 7, 0, 32768, 1)
iwin:		function table with window shape (e.g. giWin ftgen 0, 0, 4096, 20, 9, 1)

PERFORMANCE
apnter:	pointer into the function table (0-1)
kgrainamp:	multiplier of the grain amplitude (the overall amplitude depends also on grainrate and grainsize)
kgrainrate:	number of grains per seconds
kgrainsize:	grain duration in ms
kcent:		transposition in cent
kposrand:	random deviation (offset) of the pointer in ms
kcentrand:	random transposition in cents (up and down)


CREDITS
joachim heintz 2010
*/

  opcode PartikkelSimpB, a, iakkkkkkiii

ifiltab, apnter, kgrainamp, kgrainrate, kgrainsize, kcent, kposrand, kcentrand, icosintab, idisttab, iwin	xin

/*amplitude*/
kamp		= 		kgrainamp * 0dbfs
/*transposition*/
kcentrand	rand 		kcentrand; random transposition
iorig		= 		1 / (ftlen(ifiltab)/sr); original pitch
kwavfreq	= 		iorig * cent(kcent + kcentrand)	
/*pointer*/
apos       linrand     kposrand
asamplepos =           apnter + apos
/* other parameters */
imax_grains	= 		1000; maximum number of grains per k-period
idist		=		1; scattered distribution
async		=		0; no sync input
awavfm		=		0; no audio input for fm

aout		partikkel 	kgrainrate, idist, idisttab, async, 1, iwin, \
				-1, -1, 0, 0, kgrainsize, kamp, -1, \
				kwavfreq, 0, -1, -1, awavfm, \
				-1, -1, icosintab, kgrainrate, 1, \
				1, -1, 0, ifiltab, ifiltab, ifiltab, ifiltab, \
				-1, asamplepos, asamplepos, asamplepos, asamplepos, \
				1, 1, 1, 1, imax_grains
		xout		aout
  endop

;GRAIN ENVELOPE WINDOW FUNCTION TABLE:
giwfn	ftgen	0,  0, 131072,  9,   .5, 1, 	0 				     ; HALF SINE


instr 1
;Sample
Sfile chnget "file"
ir filenchnls Sfile
if ir = 2 then
gifile1 ftgen 0,        0,     0,       1,    Sfile,          0,        0,        1 
gifile2 ftgen 0,        0,     0,       1,    Sfile,          0,        0,        2 
else
gifile1 ftgen 0,        0,     0,       1,    Sfile,          0,        0,        1 
gifile2 ftgen 0,        0,     0,       1,    Sfile,          0,        0,        1 
endif

giCosine ftgen 0, 0, 8193, 9, 1, 1, 90
giDisttab ftgen 0, 0, 32768, 7, 0, 32768, 1
giWin ftgen 0, 0, 4096, 20, 9, 1

endin


instr 2

kgrainamp init 0.5
kcentrand init 0


kgrainrate		chnget "rate"
kgrainsize		chnget "size"
kposrand		chnget "randomisation"
kpnter		chnget "position"
kpitch		chnget "pitch"
koct			chnget "oct" 
kcentA      =     100 * kpitch
apnter = a(kpnter)

krandom  rand 0.5
krand = krandom + 0.5
if koct > 0 then
if krand < koct then 
kcent = kcentA + 1200
else
kcent = kcentA
endif
else
if -krand > koct then 
kcent = kcentA - 1200
else
kcent = kcentA
endif
endif

a1 PartikkelSimpB gifile1, apnter, kgrainamp, kgrainrate, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin
a2 PartikkelSimpB gifile2, apnter, kgrainamp, kgrainrate, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin

	
outch 1, a1
outch 2, a2

endin

</CsInstruments>

<CsScore>
f 0 36000

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
  <objectName>position</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{0526ad18-e635-41ec-89b0-cf16f25bd485}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.57000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>rate</objectName>
  <x>9</x>
  <y>203</y>
  <width>20</width>
  <height>100</height>
  <uuid>{87954a66-0a4f-4824-ad38-2642bbbd543d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>40.00000000</maximum>
  <value>19.60000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>size</objectName>
  <x>112</x>
  <y>207</y>
  <width>20</width>
  <height>100</height>
  <uuid>{1c2146df-0beb-460a-855c-93f76980a908}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>500.00000000</maximum>
  <value>405.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>rand</objectName>
  <x>99</x>
  <y>19</y>
  <width>20</width>
  <height>100</height>
  <uuid>{7715d99a-0d5c-43bc-adf2-59db617b7f37}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.20000000</value>
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
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.570000 position
ioSlider {9, 203} {20, 100} 0.000000 40.000000 19.600000 rate
ioSlider {112, 207} {20, 100} 0.000000 500.000000 405.000000 size
ioSlider {99, 19} {20, 100} 0.000000 1.000000 0.200000 rand
</MacGUI>
