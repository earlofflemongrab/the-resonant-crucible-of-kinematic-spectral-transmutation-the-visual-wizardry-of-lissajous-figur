<CsoundSynthesizer>
<CsOptions>
; activate real-time audio output and suppress note printing 
</CsOptions>
<CsInstruments>

;example by Oeyvind Brandtsegg
sr = 44100 
ksmps = 8 
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

 



instr 1

giCosine ftgen 0, 0, 8193, 9, 1, 1, 90
giDisttab ftgen 0, 0, 32768, 7, 0, 32768, 1
giWin ftgen 0, 0, 4096, 20, 9, 1

;Live Buffer
giTablen = 262144
giLive1 ftgen 0,0,giTablen,2,0
giLive2 ftgen 0,0,giTablen,2,0
giLive3 ftgen 0,0,giTablen,2,0

; write live input to buffer (table)
a1 inch 1 
gkstart1 tablewa giLive1, a1, 0 
if gkstart1 < giTablen goto end 
gkstart1 = 0
end:
endin

instr 2
;Live Buffer 2
; write live input to buffer (table)
a1 inch 1 
gkstart2 tablewa giLive2, a1, 0 
if gkstart2 < giTablen goto end 
gkstart2 = 0
end:
endin

instr 3
;Live Buffer 3
; write live input to buffer (table)
a1 inch 1 
gkstart3 tablewa giLive3, a1, 0 
if gkstart3 < giTablen goto end 
gkstart3 = 0
end:
endin


instr 4

kcentrand init 0
kpitch    init 0


kgrainsize		chnget "size"
kposrand	 	chnget "randomisation"
koct			chnget "oct" 

krandom  rand 0.5
krand = krandom + 0.5
if koct > 0 then
if krand < koct then 
kcent = 1200
else
kcent = 0
endif
else
if -krand > koct then 
kcent = -1200
else
kcent = 0
endif
endif


kreadpoint1 = gkstart1 / (giTablen / 0.80)
apnter1 = a(0.15 + kreadpoint1)

kreadpoint2 = gkstart2 / (giTablen / 0.80)
apnter2 = a(0.15 + kreadpoint2)

kreadpoint3 = gkstart3 / (giTablen / 0.80)
apnter3 = a(0.15 + kreadpoint3)

kgrainrate1 = (kreadpoint1 - 1) * -24
kgrainrate2 = (kreadpoint2 - 1) * -24
kgrainrate3 = (kreadpoint3 - 1) * -24

a1 PartikkelSimpB giLive1, apnter1, 1, kgrainrate1, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin
a2 PartikkelSimpB giLive1, apnter1, 1, kgrainrate1, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin
a3 PartikkelSimpB giLive2, apnter2, 1, kgrainrate2, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin
a4 PartikkelSimpB giLive2, apnter2, 1, kgrainrate2, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin
a5 PartikkelSimpB giLive3, apnter3, 1, kgrainrate3, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin
a6 PartikkelSimpB giLive3, apnter3, 1, kgrainrate3, kgrainsize, kcent, kposrand, kcentrand, giCosine, giDisttab, giWin

aout1 = a1 + a3 + a5
aout2 = a2 + a4 + a6

outch 1, aout1
outch 2, aout2


endin

</CsInstruments>

<CsScore>
f 0 3600
i 1 0 3600
i 2 2 3600
i 3 4 3600
i 4 0 3600
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
  <value>31.20000000</value>
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
  <maximum>800.00000000</maximum>
  <value>560.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>randomisation</objectName>
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
  <value>0.80000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>oct</objectName>
  <x>194</x>
  <y>200</y>
  <width>20</width>
  <height>100</height>
  <uuid>{a6dfaed5-1bec-4e8f-90c9-16df157abbbf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <minimum>-1.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>-0.72000000</value>
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
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.570000 position
ioSlider {9, 203} {20, 100} 0.000000 40.000000 31.200000 rate
ioSlider {112, 207} {20, 100} 0.000000 800.000000 560.000000 size
ioSlider {99, 19} {20, 100} 0.000000 1.000000 0.800000 randomisation
ioSlider {194, 200} {20, 100} -1.000000 1.000000 -0.720000 oct
</MacGUI>
