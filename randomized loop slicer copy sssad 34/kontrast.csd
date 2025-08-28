<CsoundSynthesizer>
<CsOptions>

</CsOptions>
<CsInstruments>


sr=44100
ksmps=16
nchnls=1
0dbfs = 1
	
	
kdepth	init 0.5
kaver init 1
ksmooth init 1.5

kthreshHigh init 0.00408059
kthreshLow init 0.000146961

khighGain init 8
kmidGain init 5
klowGain init 2

	opcode thresh, 0, kkkkkkiii
	
		
klowgain,kmidgain,khighgain,kthreshlow, kthreshhigh, kband, inumbins, iampout, iampinsmooth xin


iclear 	ftgen 0, 0, inumbins, 2, 0
	tablecopy iampout, iclear

kcount = 0
kvol = 0

kbandfixed = kband

loop:
kamp 	table kcount, iampinsmooth

kvol = kvol + kamp
kcount = kcount + 1

if (kcount == kband) kgoto thresh
		kgoto loop

thresh:

	kband2 = kband
	kband = kband + kbandfixed
	kvol = kvol / kbandfixed
	if (kvol < kthreshlow) kgoto low
		kgoto high
		
	low:	
		kband3 = kband2-kbandfixed
 
		vadd  iampout, klowgain, kbandfixed, kband3
		kgoto contin

	high:
	 		;printk2 kvol 

	kband3 = kband2-kbandfixed			
	if (kvol < kthreshhigh) then
		vadd  iampout, kmidgain, kbandfixed, kband3

	else
		vadd  iampout, khighgain, kbandfixed, kband3

	endif

		kgoto contin

contin:	
kvol = 0
	
	if (kcount < inumbins) kgoto loop

endop
	
instr 1

iampout ftgen 0,0,32769,2,0
iampinsmooth ftgen 0,0,32769,2,0


kfftsize 	init 4096
kol 		init 4
kwindmult 	init 2
kwindtype 	init 0
kBand	 	init 512

kfftsize	chnget "fftsize"
kol		chnget "ol"
kwindmult	chnget "window"
kwindtype	chnget "windtype"
kBand		chnget "bands"

ktrig           changed     kfftsize,kol, kwindmult, kwindtype, kBand
if ktrig = 1 then
                reinit      pass
endif

pass:

ifftsize =  i(kfftsize)
iol =  i(kol)
iNumBins = ifftsize/2 + 1
ihop = ifftsize/iol
iwindow = ifftsize*i(kwindmult)
iwindtype = i(kwindtype)
ibands = i(kBand)
;

if (ihop >= ifftsize) then
ihop          =           ihop / 2
endif

if (ihop < 16) then
ihop          =           16
endif

klowcut invalue "low"
klowfull = klowcut + 10

khighcut invalue "high"
khighfull = khighcut - 50

kdepth	invalue "depth"
kdepth	port kdepth, 0.01

kaver invalue	"aver"
ksmooth invalue "smooth"

kthreshHigh invalue "threshH"
kthreshLow invalue "threshL"

khighGain invalue "gainH"
khighGain	port khighGain, 0.01
khighGain = khighGain+0.000000001

kmidGain invalue "gainM"
kmidGain	port kmidGain, 0.01
kmidGain = kmidGain+0.000000001

klowGain invalue "gainL"
klowGain	port klowGain, 0.01
klowGain = klowGain+0.000000001



ain1	inch 1

fsig1 pvsanal ain1, ifftsize, ihop, iwindow, iwindtype

fsig1copy	pvsmix	fsig1, fsig1
;fsigblur pvsmooth fsig1, ksmooth, ksmooth

kflag pvsftw  fsig1copy, iampinsmooth

if (kflag > 0) then ; only proc when frame is ready

	thresh  klowGain,kmidGain,khighGain,kthreshLow, kthreshHigh, ibands, iNumBins, iampout, iampinsmooth

	pvsftr fsig1copy, iampout

endif

fsigsmooth pvsmooth fsig1copy, ksmooth, 1

fsigkontrast pvsfilter fsig1, fsigsmooth, kdepth

fsigout pvsbandp fsigkontrast, klowcut, klowfull , khighfull, khighcut

aout1 pvsynth fsigout


out aout1

endin	


	
	
</CsInstruments>
<CsScore>

i1 0 36000

e

</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>30</width>
 <height>105</height>
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
  <uuid>{6bc8a4d4-47b1-4a13-b8c1-6f41b7a257d4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
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
WindowBounds: 72 179 96 26
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
