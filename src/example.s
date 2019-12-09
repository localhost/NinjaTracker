;-------------------------------------------------------------------------------
; Ninjatracker 2 gamemusic example
;-------------------------------------------------------------------------------

                processor 6502
                org $0800

RASTERPOS       = $fc

mode            = $0291
musicdata       = $1000
getin           = $ffe4

clearscreen:    ldx #$00                    ;Clear screen & set colors
clearloop:      lda #$20
                sta $0400,x
                sta $0500,x
                sta $0600,x
                sta $0700,x
                lda #$01
                sta $d800,x
                inx
                bne clearloop

printtext:      lda #22                     ;Set lowercase letters and
                sta $d018                   ;disable case switching
                lda #$80
                sta mode
                ldx #$00
printloop:      lda text,x                  ;Print the message
                beq initmusic
                cmp #96
                bcc printok
                sbc #96
printok:        sta $0400,x
                inx
                bne printloop

initmusic:      lda #<musicdata             ;Make sure playroutine gets music
                ldx #>musicdata             ;data from correct address
                jsr nt_newmusic
                lda #$00                    ;Then init subtune 0
                jsr nt_playsong

initraster:     sei                         ;Init raster interrupt for music
                lda #$7f                    ;playback
                sta $dc0d
                lda #$01
                sta $d01a
                lda #<raster
                sta $0314
                lda #>raster
                sta $0315
                lda #27
                sta $d011
                lda #RASTERPOS
                sta $d012
                lda $dc0d
                dec $d019
                cli

playloop:       ldx curraster               ;Print rastertime meter
                lda hex,x
                sta $0425
                ldx maxraster
                lda hex,x
                sta $0427
                jsr getin
                cmp #"1"                    ;Check for keypress 1-2
                bcc nosubtune
                cmp #"2"+1
                bcs nosubtune
                sec
                sbc #"1"
                jsr nt_playsong             ;Start the corresponding subtune
                jmp playloop
nosubtune:      cmp #"A"                    ;Check for keypress A-D
                bcc nosfx
                cmp #"D"+1
                bcs nosfx
                sec
                sbc #"A"
                asl
                tay                         ;Play the corresponding sound
                lda sfxtbl,y                ;effect on channel 3 (channel
                ldx sfxtbl+1,y              ;index 14)
                ldy #14
                jsr nt_playsfx
nosfx:          jmp playloop


raster:         dec $d019
                nop
                nop
                nop
                nop
                nop
                nop
                inc $d020                   ;Call the playroutine and see
                jsr nt_music                ;how long it took to execute
                lda $d012
                dec $d020
                sbc #RASTERPOS
                sta curraster
                cmp maxraster               ;New rastertime record?
                bcc rasterok
                sta maxraster
rasterok:       jmp $ea31

text:           dc.b "NT2 Gamemusic Player Example          / "
                dc.b "Press 1-2 for subtunes, A-D for SFX     ",0

hex:            dc.b "0123456789ABCDEF",0

curraster:      dc.b 0
maxraster:      dc.b 0

                include ../nt2play.s

                org musicdata

                incbin gamemusic.bin    ;Note: NT2 saves also gamemusic mode data
                                        ;with startaddress included, so the
                                        ;startaddress had to be stripped before
                                        ;incbin could be used

sfxtbl:         dc.w sfx_arp1
                dc.w sfx_arp2
                dc.w sfx_gun
                dc.w sfx_expl

sfx_arp1:       dc.b $89,$00,$04,$a2,$41,$a2,$a2,$a6,$a6,$a6,$40,$a9,$a9,$a9,$a2,$a2
                dc.b $a2,$a6,$a6,$a6,$a9,$a9,$a9,$a2,$a2,$a2,$a6,$a6,$a6,$a9,$a9,$a9
                dc.b $a2,$a2,$a2,$a6,$a6,$a6,$a9,$a9,$a9,$00

sfx_arp2:       dc.b $00,$0a,$02,$a0,$41,$a0,$a0,$a4,$a4,$a4,$a7,$a7,$a7,$a0,$a0,$a0
                dc.b $a4,$a4,$a4,$a7,$a7,$a7,$a0,$a0,$a0,$a4,$a4,$a4,$a7,$a7,$a7,$a0
                dc.b $a0,$a0,$a4,$a4,$a4,$a7,$a7,$a7,$00

sfx_gun:        dc.b $f9,$00,$08,$c4,$81,$a8,$41,$c0,$81,$be,$bc,$80,$ba,$b8,$b6,$b4
                dc.b $b2,$b0,$ae,$ac,$aa,$a8,$a6,$a4,$a2,$a0,$9e,$9c,$9a,$98,$96,$94
                dc.b $92,$90,$00

sfx_expl:       dc.b $f9,$00,$08,$b8,$81,$a4,$41,$a0,$b4,$81,$98,$92,$9c,$90,$95,$9e
                dc.b $92,$80,$94,$8f,$8e,$8d,$8c,$8d,$8e,$8d,$8c,$8d,$8e,$8d,$8c,$8d
                dc.b $8e,$8d,$8c,$00


