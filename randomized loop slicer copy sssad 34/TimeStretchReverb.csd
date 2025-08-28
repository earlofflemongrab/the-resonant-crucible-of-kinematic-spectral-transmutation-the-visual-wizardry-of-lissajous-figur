;-----------------------------------------------------------------
;
; Written by Kim Ervik 2011. kimer@stud.ntnu.no
; Some parts of the code (for partikkel parameter handling) 
; borrowed from examples given by Oeyvind Brandtsegg
;
;-----------------------------------------------------------------

<CsoundSynthesizer>

<CsOptions>
-b200 -B400 -odac0 -iadc0 -d
</CsOptions>


<CsInstruments>
	sr		=	44100
	ksmps	=	32
	0dbfs	=	3
	nchnls	=	2

;***************************************************
;ftables
;***************************************************

	; classic waveforms
		giSine			ftgen	0, 0, 65537, 10, 1							; sine wave
		giCosine			ftgen	0, 0, 8193, 9, 1, 1, 90						; cosine wave
		giTri				ftgen	0, 0, 8193, 7, 0, 2048, 1, 4096, -1, 2048, 0		; triangle wave 

	; grain envelope tables
		giSigmoRise 		ftgen	0, 0, 8193, 19, 0.5, 1, 270, 1					; rising sigmoid
		giSigmoFall	 	ftgen	0, 0, 8193, 19, 0.5, 1, 90, 1					; falling sigmoid
		giExpFall			ftgen	0, 0, 8193, 5, 1, 8193, 0.00001				; exponential decay
		giTriangleWin 		ftgen	0, 0, 8193, 7, 0, 4096, 1, 4096, 0				; triangular window 
	
	;Initierer Globale variabler
		gkPlaytablenr		init		-1
		gkRectablenr		init		0
		gktrig			init		0
		gitablelen		init		262144

gkTime			init 0
gkOctaveMix		init 0
gkMix			init 0


	; ------- Trigger instrument -----------
	instr 20

gkTime		init  50
gkrandom		init  0
gkdensity		init  40
gkOctaveMix		init  0

gkTime		chnget "Time"
gkrandom         chnget "random"
gkdensity        chnget "density" 

		gkdelaytime	=	gkTime/8
		gkRecDur		=	gkTime/8
		kratio		= 	(gkTime*2)+gkdelaytime
		gkPlayDur	= 	gkdelaytime*kratio

		kCountSpeed 	=	1/gkRecDur
		
		ktrig metro kCountSpeed
	; ----------- Counting tablenumber for recordinstrument ----------------
		gkRectablenr = gkRectablenr + ktrig
		if gkRectablenr > 8 then
			gkRectablenr = 1
		endif
	; ------------ Counting tablenumber for partikkelinstrumentet ---------------
		gkPlaytablenr = gkPlaytablenr + ktrig
		if gkPlaytablenr > 8 then
			gkPlaytablenr = 1
		endif

		schedkwhen ktrig, 0, 3, 30, 0, gkRecDur + 0.4, gkRectablenr	;Recordingtrigger

		if gkPlaytablenr > 0 then	; Skips first round
			schedkwhen ktrig, 0, 8, 40, 0, gkPlayDur, gkPlaytablenr, gkRecDur, gkPlayDur	;Partikkeltrigger
		endif
	
	endin
	
	;--------------- Recorder -------------------------
	instr 30

		kstart init 0
		asig inch 1

		asig = asig/0dbfs
		kstart tablewa p4, asig, 0

	endin

	;  ------------- Partikkel instrument---------------
	instr 40
		kwaveform1		= p4	; source audio waveform 1
		kwave1Single	= 0			; flag to set if waveform is single cycle (set to zero for sampled waveforms)
#include "PartikkelArgs.txt"

	; Octavfunction
		iwavfreqstarttab	ftgen	0, 0, 16, -2, 0, 3, 1, 2, 2, 1	; GrainPitch per grain table
		iwavfreqendtab	ftgen	0, 0, 16, -2, 0, 3, 1, 2, 2, 1	; GrainPitch per grain table
		igainmasks		ftgen	0, 0, 16, -2, 0, 3, 1, 0, 0, 1	; Amplitude per grain table

tablew gkOctaveMix, 3, igainmasks		; Writes to amplitude per grain table
tablew gkOctaveMix, 4, igainmasks

	; Parametersettings
		ichannelmasks ftgen	0, 0, 16, -2, 0, 1, 0, 1		; Wide Spatialisation
		kamp		= ampdbfs(-5)						; Amp
		kgrainrate	= gkdensity							; Grains per second (Density). Since every other grain is in each channel
													; and two and two grains is pithed, the real grainrate is 37 Hz
		kwavfreq		= 1								; Playbackspeed inside each grain (pitch)
		kduration		= 220							; Grainduration in ms
		ksampleposoffset rand gkrandom						; Random offset on the tima axis
		ksampleposoffset = abs(ksampleposoffset)			
		iEndpoint 	= (p5 * sr)						; Reads only from the recorded part og the buffer
		iEndpoint 	= iEndpoint / gitablelen
		ksamplepos linseg 0.01, p6, iEndpoint
		ksamplepos 	= ksamplepos - 0.01
		asamplepos1	= ksamplepos +ksampleposoffset



a1,a2 partikkel kgrainrate, kdistribution, idisttab, async, kenv2amt, ienv2tab, \
               	  ienv_attack, ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, igainmasks, \
               	  kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, \
               	  ifmamptab, ifmenv, icosine, kTrainCps, knumpartials, \
               	  kchroma, ichannelmasks, krandommask, kwaveform1, kwaveform2, kwaveform3, kwaveform4, \
               	  iwaveamptab, asamplepos1, asamplepos2, asamplepos3, asamplepos4, \
               	  kwavekey1, kwavekey2, kwavekey3, kwavekey4, imax_grains

	; ------- Envelope ---------
		kenv linseg 0, p6/2, 1, p6/2, 0
		a1 = a1*kenv
		a2 = a2*kenv

outs a1, a2
	
	endin



</CsInstruments>
<CsScore>

	f 0	36000
; --- Audio Buffer Slots -------
	f 1	0	262144	2	0	
	f 2	0	262144	2	0
	f 3	0	262144	2	0
	f 4	0	262144	2	0
	f 5	0	262144	2	0
	f 6	0	262144	2	0
	f 7	0	262144	2	0
	f 8	0	262144	2	0

	i	20	0	36000
	i	30	0	36000
	i	40	0	36000


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
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{49684c66-d75d-4478-afb2-2d2b014fa0b1}</uuid>
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
WindowBounds: 72 179 400 200
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
