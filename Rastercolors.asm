*=$c000 "Program"

// Can be compiled with Kick Assembler cross assembler

        jsr init

        // raster interrupt: https://codebase.c64.org/doku.php?id=base:introduction_to_raster_irqs

        sei

        lda #$7f
        sta $dc0d
        sta $dd0d

        lda $dc0d
        lda $dd0d

        lda #$01
        sta $d01a

        lda #$20
        sta $d012

        lda #$1b
        sta $d011


        lda #$35
        sta $01

        lda #<start
        sta $fffe
        lda #>start
        sta $ffff

        cli

inf:    jmp inf

start:  lda #$ff
        sta $d019

rwait0: lda $d012
        cmp #45
        bne rwait0

        lda #1
        sta 53281
        sta 53280

        ldx line
        lda sinus,x
        adc #67
rwait1: cmp $d012
        bne rwait1

        lda #3
        sta 53281
        sta 53280

        ldx line
        lda sinus,x
        adc #75
rwait2: cmp $d012
        bne rwait2

        lda #14
        sta 53281
        sta 53280

        ldx line
        lda sinus,x
        adc #83
rwait3: cmp $d012
        bne rwait3

        lda #3
        sta 53281
        sta 53280

        ldx line
        lda sinus,x
        adc #91
rwait4: cmp $d012
        bne rwait4

        lda #1
        sta 53281
        sta 53280

        lda #174
jw:     cmp $d012
        bne jw

        lda #14
        sta 53281
        lda #14
        sta 53280

        lda #210
jwait:  cmp $d012
        bne jwait

        lda  #7
        sta  53281

        lda #14
        sta 53280

        inc line

        lda dx
        and #7
        sta 53270
        lda dx
        cmp #0
        beq scroll2
        dec dx
        rti

scroll2:
        lda #7
        sta dx
        lda #7
        and #7
        sta 53270

        ldx #0
sloop:
        lda 1024+(40*22)+1,x
        sta 1024+(40*22),x
        inx
        cpx #38
        bne sloop

        ldy tid
        lda text,y
        cmp #0
        beq restart
        sta 1024+(40*22)+38
        inc tid

skip:   lda $d012
        cmp #230
        bne skip

        lda #7
        sta 53281

        lda #14
        sta 53280
        rti

restart:
        lda #0
        sta tid

        lda #7
        sta dx

skip2:  lda $d012
        cmp #230
        bne skip2

        lda #7
        sta 53281

        lda #14
        sta 53280

        rti


init:   jsr $e544           // clear screen
        rts

line:   .byte 0
stid:   .byte 0
yline:  .byte 0
dx:     .byte 7
tid:    .byte 0
text:   .text " i am nobody in c64 coding too...                            "
        .byte 0

sinus: .for(var i=0;i<256;i++) .byte round(33.5+43.5*sin(toRadians(360*i/256)))