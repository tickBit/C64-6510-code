// can be compiled with Kick assembler

    * = $c000

    .var minR=-2.0
    .var maxR=1.0
    .var minI=-1.5
    .var maxI=1.5

    .var dr=(maxR-minR) / (20.0*8.0)
    .var di=(maxI-minI) / (20.0*8.0)

    .var y = 0
    .var x = 0
    .for (y = 0; y < 20*8; y+=8) {
    .for (x = 0; x < 20*8; x+=8) {
        lda     #224
        sta     1024+(x/8)+(y*40/8)

        .var    color = mandelbrot(x, y)
        
        lda     #color
        sta     55296+(x/8)+(y*40/8)
    }
    }

    lda #0
    sta 211     // column of cursor
    
    lda #21
    sta 214     // row of cursor

    rts

.function mandelbrot(x, y) {

    .var    cr = minR + x * dr
    .var    ci = minI + y * di

    .var    zr = 0.0
    .var    zi = 0.0
    .var    zr1 = 0.0
    .var    zi1 = 0.0
    .var    z = 0.0

    .for (var i = 0; i < 16; i++) {
        
        .eval   zr1 = zr*zr - zi*zi + cr
        .eval   zi1 = 2.0*zr*zi + ci

        .eval   zr = zr1
        .eval   zi = zi1

        .eval   z = zr*zr+zi*zi

        .if (z > 4) .return 4 - floor(i / 15.0 *4.0)
        
    }
    .return 0
}    


