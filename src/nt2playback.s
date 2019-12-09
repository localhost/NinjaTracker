;-------------------------------------------------------------------------------
; Play/stop music
;-------------------------------------------------------------------------------

playstart:      jsr getsongindex
                lda #$00
                sta nt_songtbl+2,x
                adc worktracklen
                sta nt_songtbl+3,x
                adc worktracklen+1
                sta nt_songtbl+4,x
playcommon:     jsr stop
                lda #$00
                sta timemin
                sta timesec
                sta timeframe
                sta fastfwd
                sta maxraster
                lda songnum
                sta nt_initsongnum+1
                inc playflag
                rts

playpos:        jsr getsongindex
                lda worktrackstart
                sta nt_songtbl+2,x
                lda worktracklen
                clc
                adc worktrackstart+1
                sta nt_songtbl+3,x
                lda worktracklen
                clc
                adc worktracklen+1
                adc worktrackstart+2
                sta nt_songtbl+4,x
                jmp playcommon

stop:           lda #$00
                sta playflag
                sta timeframe
                sta nt_initsongnum+1
                lda #$ff
                sta nt_chnnewnote
                sta nt_chnnewnote+7
                sta nt_chnnewnote+14
                rts

togglefastfwd:  lda fastfwd
                eor #$01
                sta fastfwd
                rts

;-------------------------------------------------------------------------------
; Play test note (when music has been stopped)
;-------------------------------------------------------------------------------

playtestnote:   cmp #KEYOFF
                beq silencetestnote
                cmp #FIRSTNOTE
                bcc ptnskip
                ldx playflag
                bne ptnskip
                pha
ptnwait:        lda $d011
                bpl ptnwait
ptnwait2:       lda $d011
                bmi ptnwait2
ptnwait3:       lda $d012
                cmp #RASTERPOS
                bcc ptnwait3
                pla
                ldy tracknum
                ldx chnregindex,y
                lsr
                sta nt_chnnewnote,x
                lda testnotecmd
                sta nt_chncmd,x
                bmi ptnskiphr
                lda hrparam
                sta $d406,x
                pha
                pla
                pha
                pla
                pha
                pla
                lda #$fe
                sta nt_chngate,x
                and nt_chnwave,x
                sta $d404,x
ptnskiphr:      lda #$00
                sta nt_chncounter,x
ptnwait4:       lda nt_chncounter,x
                beq ptnwait4
                lda #$ff
                sta nt_chnnewnote,x
ptnskip:        rts

silencetestnote:lda playflag
                bne ptnskip
                ldy tracknum
                ldx chnregindex,y
                lda #$fe
                sta nt_chngate,x
                rts

silenceall:     lda #$fe
                sta nt_chngate
                sta nt_chngate+7
                sta nt_chngate+14
                lda #$00
                sta $d406
                sta $d406+7
                sta $d406+14
                rts


