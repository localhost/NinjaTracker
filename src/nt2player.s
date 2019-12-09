;-------------------------------------------------------------------------------
; Playroutine
;-------------------------------------------------------------------------------

                org ((* + $ff) & $ff00)

nt_playd020:    sta $d020
nt_play:        ldx #$00
nt_initsongnum: lda #$00
                bmi nt_filtpos

        ;New song initialization

                asl
                asl
                adc nt_initsongnum+1
                tay
                lda nt_songtbl,y
                sta nt_songaccess1+1
                sta nt_songaccess2+1
                lda nt_songtbl+1,y
                sta nt_songaccess1+2
                sta nt_songaccess2+2
                txa
                sta nt_filtpos+1
                sta $d417
                ldx #21
nt_initloop:    sta nt_chnpattpos-1,x
                dex
                bne nt_initloop
                jsr nt_initchn
                ldx #$07
                jsr nt_initchn
                ldx #$0e
nt_initchn:     lda nt_songtbl+2,y
                iny
                sta nt_chnsongpos,x
                lda #$fe
                sta nt_chncounter,x
                sta nt_initsongnum+1
                rts

        ;Sequencer transpose & jump

nt_songtrans:   sta nt_chntrans,x
                inc nt_chnsongpos,x
                bne nt_songdone
nt_songjump:    iny
nt_songaccess2: lda nt_song,y
                sta nt_chnsongpos,x
                jmp nt_songdone

          ;Filter execution

nt_filtpos:     ldy #$00
                beq nt_filtdone
nt_filttime:    lda #$00
                bne nt_filtmod
nt_newfiltstep: lda nt_filttimetbl-1,y
                bpl nt_newfiltmod
                cmp #$ff
                bcs nt_filtjump
nt_setfilt:     sta $d417
                and #$70
                sta nt_filtdone+1
nt_filtjump:    lda nt_filtspdtbl-1,y
                bcc nt_nextfiltpos
                sta nt_filtpos+1
                bcs nt_filtdone
nt_newfiltmod:  sta nt_filttime+1
nt_filtmod:     lda nt_filtspdtbl-1,y
                clc
nt_filtcutoff:  adc #$00
                dec nt_filttime+1
                bne nt_storecutoff
nt_nextfiltpos: inc nt_filtpos+1
nt_storecutoff: sta nt_filtcutoff+1
                sta $d416
nt_filtdone:    lda #$00
nt_mastervol:   ora #$0f
                sta $d418

        ;Channel execution

                jsr nt_chnexec
                ldx #$07
                jsr nt_chnexec
                ldx #$0e

        ;Get pattern from sequencer

nt_chnexec:     ldy nt_chnsongpos,x
nt_songaccess1: lda nt_song,y
                bmi nt_songtrans
                beq nt_songjump

        ;Update duration counter

nt_songdone:    inc nt_chncounter,x
                bmi nt_jumptopulse

        ;Get data from pattern (split on 2 frames)

nt_neworreload: tay
                lda nt_patttbllo-1,y
                sta nt_temp1
                lda nt_patttblhi-1,y
                sta nt_temp2
                ldy nt_chnpattpos,x
                lda nt_chncounter,x
                bne nt_reload

        ;Pattern frame 1: new note, new instrument, hardrestart

nt_newnotes:    lda (nt_temp1),y
                lsr
                sta nt_chnnewnote,x
                bcc nt_nonewcmd
nt_newcmd:      iny
                inc nt_chnpattpos,x
                lda (nt_temp1),y
                sta nt_chncmd,x
                bcc nt_rest
nt_checkhr:     bmi nt_rest
nt_hrparam:     lda #$00
                sta $d406,x
                lda #$fe
                sta nt_chngate,x
nt_rest:

        ;Execute either wave or pulse, but not both (wave has priority)

nt_waveorpulse: ldy nt_chnwavepos,x
                beq nt_jumptopulse
                jmp nt_wavedirect
nt_jumptopulse: jmp nt_pulseexec

        ;No new instrument

nt_nonewcmd:    cmp #FIRSTNOTE/2
                bcc nt_gatectrl
                lda nt_chncmd,x
                bcs nt_checkhr

        ;Gate control / command only

nt_gatectrl:    lsr
                ora #$fe
                sta nt_chngate,x
                bcc nt_newcmd
                sta nt_chnnewnote,x
                bcs nt_rest

        ;Pattern frame 2: duration, end of pattern, new note init / command exec

nt_noendpatt:   tya
                bne nt_storepattpos
nt_reload:      iny
                lda (nt_temp1),y
                cmp #$c0
                bcs nt_newdur
nt_nonewdur:    lda nt_chnduration,x
                bcc nt_durdone
nt_newdur:      iny
                sta nt_chnduration,x
nt_durdone:     sta nt_chncounter,x
                lda (nt_temp1),y
                bne nt_noendpatt
nt_endpatt:     inc nt_chnsongpos,x
nt_storepattpos:sta nt_chnpattpos,x

        ;Check for new note

nt_checknewnote:lda nt_chnnewnote,x
                bmi nt_waveorpulse
                cmp #FIRSTNOTE/2
                bcc nt_skipnote
                adc nt_chntrans,x
                asl
                sta nt_chnnote,x
                sec
nt_skipnote:    ldy nt_chncmd,x
                bmi nt_legatocmd
                lda nt_cmdad-1,y
                sta $d405,x
                bcc nt_skipgate
nt_firstwave:   lda #$09
                sta $d404,x
                lda #$ff
                sta nt_chngate,x
nt_skipgate:    lda nt_cmdsr-1,y
                sta $d406,x
nt_skipadsr:    lda nt_cmdwavepos-1,y
                beq nt_skipwave
                sta nt_chnwavepos,x
                lda #$00
                sta nt_chnwavetime,x
nt_skipwave:    lda nt_cmdpulsepos-1,y
                beq nt_skippulse
                sta nt_chnpulsepos,x
                lda #$00
                sta nt_chnpulsetime,x
nt_skippulse:   lda nt_cmdfiltpos-1,y
                beq nt_skipfilt
                sta nt_filtpos+1
                lda #$00
                sta nt_filttime+1
nt_skipfilt:    rts
nt_legatocmd:   tya
                and #$7f
                tay
                bpl nt_skipadsr

        ;Pulse execution

nt_pulseexec:   ldy nt_chnpulsepos,x
                beq nt_pulsedone
                lda nt_chnpulsetime,x
                bne nt_pulsemod
nt_newpulse:    lda nt_pulsetimetbl-1,y
                bpl nt_newpulsemod
                cmp #$ff
                lda nt_pulsespdtbl-1,y
                bcc nt_nextpulse
nt_pulsejump:   sta nt_chnpulsepos,x
                bcs nt_pulsedone
nt_newpulsemod: sta nt_chnpulsetime,x
nt_pulsemod:    lda nt_pulsespdtbl-1,y
                clc
                adc nt_chnpulse,x
                adc #$00
nt_pulsenotover:dec nt_chnpulsetime,x
                bne nt_storepulse
nt_nextpulse:   inc nt_chnpulsepos,x
nt_storepulse:  sta nt_chnpulse,x
                sta $d402,x
                sta $d403,x
nt_pulsedone:

        ;Wavetable execution

nt_waveexec:    ldy nt_chnwavepos,x
                beq nt_wavedone
nt_wavedirect:  lda nt_wavetbl-1,y
                cmp #$c0
                bcs nt_slideorvib
                cmp #$90
                bcc nt_wavechange

        ;Delayed wavetable

nt_wavedelay:   sbc #$8f
                inc nt_chnwavetime,x
                sbc nt_chnwavetime,x
                bne nt_wavedone
                sta nt_chnwavetime,x
                beq nt_nowavechange

        ;Wave change + arpeggio

nt_wavechange:  sta nt_chnwave,x
nt_nowavechange:tya
                sta nt_chnwaveold,x
                lda nt_wavetbl,y
                cmp #$ff
                bcs nt_wavejump
nt_nowavejump:  inc nt_chnwavepos,x
                bcc nt_wavejumpdone
nt_wavejump:    lda nt_notetbl,y
                sta nt_chnwavepos,x
nt_wavejumpdone:lda nt_notetbl-1,y
                asl
                bcs nt_absfreq
                adc nt_chnnote,x
nt_absfreq:     tay
                jmp nt_notenum

        ;Slide finished

nt_slidedone:   lda nt_chnwaveold,x
                sta nt_chnwavepos,x
nt_notenum:     lda nt_freqtbl-24,y
                sta nt_chnfreqlo,x
                sta $d400,x
                lda nt_freqtbl-23,y
nt_storefreqhi: sta $d401,x
                sta nt_chnfreqhi,x
nt_wavedone:    lda nt_chngate,x
                and nt_chnwave,x
                sta $d404,x
                rts

        ;Slide or vibrato

nt_slideorvib:  sbc #$e0
                sta nt_temp1
                lda nt_notetbl-1,y
                sta nt_temp2
                bcc nt_vibrato

        ;Slide (toneportamento)

nt_slide:       ldy nt_chnnote,x
                lda nt_chnfreqlo,x
                sbc nt_freqtbl-24,y
                pha
                lda nt_chnfreqhi,x
                sbc nt_freqtbl-23,y
                sta nt_temp3
                pla
                bcs nt_slidedown
nt_slideup:     adc nt_temp2
                lda nt_temp3
                adc nt_temp1
                bcs nt_slidedone
nt_freqadd:     lda nt_chnfreqlo,x
                adc nt_temp2
                sta nt_chnfreqlo,x
                sta $d400,x
                lda nt_chnfreqhi,x
                adc nt_temp1
                jmp nt_storefreqhi
nt_slidedown:   sbc nt_temp2
                lda nt_temp3
                sbc nt_temp1
                bcc nt_slidedone
nt_freqsub:     lda nt_chnfreqlo,x
                sbc nt_temp2
                sta nt_chnfreqlo,x
                sta $d400,x
                lda nt_chnfreqhi,x
                sbc nt_temp1
                jmp nt_storefreqhi

          ;Vibrato

nt_vibrato:     lda nt_chnwavetime,x
                bpl nt_vibnodir
                cmp nt_temp1
                bcs nt_vibnodir2
                eor #$ff
nt_vibnodir:    sec
nt_vibnodir2:   sbc #$02
                sta nt_chnwavetime,x
                lsr
                lda #$00
                sta nt_temp1
                bcc nt_freqadd
                bcs nt_freqsub

nt_freqtbl:     dc.w $022d,$024e,$0271,$0296,$02be,$02e8,$0314,$0343,$0374,$03a9,$03e1,$041c
                dc.w $045a,$049c,$04e2,$052d,$057c,$05cf,$0628,$0685,$06e8,$0752,$07c1,$0837
                dc.w $08b4,$0939,$09c5,$0a5a,$0af7,$0b9e,$0c4f,$0d0a,$0dd1,$0ea3,$0f82,$106e
                dc.w $1168,$1271,$138a,$14b3,$15ee,$173c,$189e,$1a15,$1ba2,$1d46,$1f04,$20dc
                dc.w $22d0,$24e2,$2714,$2967,$2bdd,$2e79,$313c,$3429,$3744,$3a8d,$3e08,$41b8
                dc.w $45a1,$49c5,$4e28,$52cd,$57ba,$5cf1,$6278,$6853,$6e87,$751a,$7c10,$8371
                dc.w $8b42,$9389,$9c4f,$a59b,$af74,$b9e2,$c4f0,$d0a6,$dd0e,$ea33,$f820,$ffff

nt_chnpattpos:  dc.b 0
nt_chnsongpos:  dc.b 0
nt_chnwavepos:  dc.b 0
nt_chnwavetime: dc.b 0
nt_chnwave:     dc.b 0
nt_chnpulsepos: dc.b 0
nt_chnpulsetime:dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0,0,0,0

nt_chngate:     dc.b $fe
nt_chntrans:    dc.b $ff
nt_chncmd:      dc.b $01
nt_chncounter:  dc.b 0
nt_chnduration: dc.b 0
nt_chnnote:     dc.b 0
nt_chnnewnote:  dc.b 0

                dc.b $fe,$ff,$01,0,0,0,0
                dc.b $fe,$ff,$01,0,0,0,0

nt_chnfreqlo:   dc.b 0
nt_chnfreqhi:   dc.b 0
nt_chnpulse:    dc.b 0
nt_chnwaveold:  dc.b 0
                dc.b 0
                dc.b 0
                dc.b 0

                dc.b 0,0,0,0,0,0,0
                dc.b 0,0,0,0


