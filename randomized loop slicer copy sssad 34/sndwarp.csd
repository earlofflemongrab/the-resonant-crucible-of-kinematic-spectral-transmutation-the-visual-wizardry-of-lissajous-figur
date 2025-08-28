<CsoundSynthesizer>

<CsOptions>

</CsOptions>

<CsInstruments>



sr 		     =    44100	;SAMPLE RATE
ksmps 		= 	16	;NUMBER OF AUDIO SAMPLES IN EACH CONTROL CYCLE
nchnls 		= 	2	;NUMBER OF CHANNELS (2=STEREO)
0dbfs		     =      1    	;MAXIMUM AMPLITUDE



giporttime = 0.5
gkamp init 0.4



;GRAIN ENVELOPE WINDOW FUNCTION TABLES:
giwfn1	ftgen	0,  0, 131072,  9,   .5, 1, 	0 				     ; HALF SINE
giwfn2	ftgen	0,  0, 131072,  7,    0, 3072,  1, 128000,     0		; PERCUSSIVE - STRAIGHT SEGMENTS
giwfn3	ftgen	0,  0, 131072,  5, .001, 3072,  1, 128000, 0.001		; PERCUSSIVE - EXPONENTIAL SEGMENTS
giwfn4	ftgen	0,  0, 131072,  7,    0, 1536,  1, 128000,     1, 1536, 0	; GATE - WITH ANTI-CLICK RAMP UP AND RAMP DOWN SEGMENTS
giwfn5	ftgen	0,  0, 131072,  7,    0, 128000,1, 3072,       0		; REVERSE PERCUSSIVE - STRAIGHT SEGMENTS
giwfn6	ftgen	0,  0, 131072,  5, .001, 128000,1, 3072,   0.001		; REVERSE PERCUSSIVE - EXPONENTIAL SEGMENTS


instr 1

Sfile   chnget "file"
ichnls filenchnls Sfile
gilength filelen Sfile
ilengthinsamples = gilength * sr
gitablesize = 2 ^ ceil(log(ilengthinsamples) / log (2)) 
; THE SOUND FILES USED IN THE GRANULATION
;              NUM | INIT_TIME | SIZE | GEN_ROUTINE |     FILE_PATH        | IN_SKIP | FORMAT | CHANNEL

gifileL ftgen 0,        0,     gitablesize,      1,            Sfile        ,    0,        0,        1 
gifileR ftgen 0,        0,     gitablesize,      1,            Sfile        ,    0,        0,        2 ;STEREO FILE SO USE RIGHT CHANNEL

endin


instr	2

gkwsize chnget "wsize"
gkolap  chnget "olap"
gkptr   chnget "position"
gkrnd   chnget "randomisation"
gkwfn   chnget "envelope"
gkpch   chnget "pitch"

	iporttime 	= 	.1				;PORTAMENTO TIME
	iwfn       =      1
	kporttime	linseg	0,.1,(iporttime)		;USE OF A RAMPING UP ENVELOPE PREVENTS GLIDING PARAMETERS EACH TIME A NOTE IS RESTARTED
	kporttime	=		kporttime * giporttime	;FLTK SLIDER FOR PORTAMENTO TIME MULTIPLIED TO kporttime FUNCTION


		kpch		portk	gkpch, kporttime		;PORTAMENTO APPLIED TO PARAMETER TO SMOOTH CHANGES

	kSwitch	changed	gkolap, gkwsize, gkrnd, gkwfn	; IF ANY OF THE INPUT VARIABLES CHANGE GENERATE A MOMETARY '1' TRIGGER AT THE OUTPUT
	if	kSwitch=1	then						; IF ANY OF THE INPUT VARIABLES ABOVE HAVE CHANGED SINCE THE PREVIOUS K-RATE PASS...
		reinit	START							; BEGIN A REINITIALISATION PASS FROM LABEL NAMED 'START'
	endif									; END OF CONDITIONAL BRANCH
	START:									; LABEL CALLED 'START'

		iwsize		=	i(gkwsize)		;WINDOW SIZE (CONVERTED TO I-RATE)
	kptr		portk	 gkptr,kporttime		;PORTAMENTO APPLIED TO PARAMETER TO SMOOTH CHANGES
	imode 	= 	1 		;ENTER WARP MODE: 1=POINTER / 0=PLAYBACK SPEED WARP
	ibeg 		= 	0		;INSKIP (0=BEGINNING OF FILE)
	iwfn 		= 	giwfn1 + i(gkwfn)
	iolap 		= 	i(gkolap)		;NUMBER OF OVERLAPS (CONVERTED TO I-RATE)
	kptr	 	=	kptr*gilength		;DERIVE POINTER POSITION RELATIVE TO THE ACTUAL DURATION OF THE FILE USED
	irnd		=	i(gkrnd)		;RANDOMIZATION OF WINDOW SIZE
	asigL 		sndwarp gkamp, kptr, kpch, gifileL, ibeg, iwsize, irnd, iolap, iwfn, imode
	asigR 		sndwarp gkamp, kptr, kpch, gifileR, ibeg, iwsize, irnd, iolap, iwfn, imode
	rireturn
		outs 	asigL, asigR				;SEND AUDIO TO OUTPUTS
endin


</CsInstruments>

<CsScore>
f 0 3600
f 1 0 128 2 0
</CsScore>

</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>61</y>
 <width>283</width>
 <height>425</height>
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
  <uuid>{287db5fa-1f46-4080-b14b-ec286d1d738d}</uuid>
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
WindowBounds: 0 61 283 425
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
