// Assembler used: Kick Assembler

// Just a short test code for combining Koala picture and SID music

:BasicUpstart2(start)
// sys 49152
* = $c000

// The music is from HVSC

.var music = LoadSid("End.sid")

.var picture = LoadBinary("queen.kla", BF_KOALA)

// https://csdb.dk/forums/?roomid=11&topicid=106753&firstpost=2
.macro set_bank(screenram,bitmap) {
    .var cur_dd00   = [ >screenram >> 6 ] ^ %00000011
    .eval screenram = screenram & $3fff
    .eval bitmap    = bitmap & $3fff
    .var cur_d018   = [ [ >screenram << 2 ] + [ >bitmap >> 2 ] ]

    lda $dd00
    and #%1111100
    ora #cur_dd00
    sta $dd00
    lda #cur_d018
    sta $d018
}

// show picture
start:
	:set_bank(screen, koala)
	lda #$18
	sta $d016
	lda #$3b
	sta $d011
	
	lda #picture.getBackgroundColor()
	sta $d021
	lda #1
	sta $d020
	
	ldx #0

loop:
	.for (var i=0; i<4; i++) {
		lda colorRam+i*$100,x
		sta $d800+i*$100,x
	}

	inx
	bne loop

// SID related code
	
			ldx #0
			ldy #0
			lda #music.startSong-1
			jsr music.init
			sei
			lda #<irq1
			sta $0314
			lda #>irq1
			sta $0315
			asl $d019
			lda #$7b
			sta $dc0d
			lda #$81
			sta $d01a
			lda #$80
			sta $d012
			cli
			jmp *
//---------------------------------------------------------
			irq1:
			asl $d019
			jsr music.play
			pla
			tay
			pla
			tax
			pla
			rti
//---------------------------------------------------------
*=music.location "Music"
.fill music.size, music.getData(i)

*=$0c00 "ScreenRam"; screen:	.fill picture.getScreenRamSize(), picture.getScreenRam(i)
*=$4000	"ColorRam:"; colorRam: 	.fill picture.getColorRamSize(), picture.getColorRam(i)
*=$2000 "Bitmap"; koala:    	.fill picture.getBitmapSize(), picture.getBitmap(i)