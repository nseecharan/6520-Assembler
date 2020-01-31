 define WIDTH 	8 ; width of graphic
 define HEIGHT 	8 ; height of graphic

	lda #$00	;number count
	sta $13

 	lda #$21	; create a pointer at $10
 	sta $10		;   which points to where
 	lda #$02	;   the graphic should be drawn
 	sta $11
 
 	lda #$00	; number of rows we've drawn
 	sta $12		;   is stored in $12

 
 	ldx #$00	; index for data
 	ldy #$00	; index for screen column
 
	
 left:	
	
	
	jsr numD

	;lda nine,x	
 	;sta ($10),y

 	inx
 	iny
 	cpy #WIDTH
 	bne left	; ****draw horizontally until max width
   
			; test for max height
 	inc $12		; increment row counter
 	lda #HEIGHT	; are we done yet?
 	cmp $12
 	beq reset	; ...exit if we are

 			; ****move to next row if not max height

 	lda $10		; load pointer
 	clc
 	adc #$20	; add 32 to drop one row
 	sta $10
 	lda $11		; carry to high byte if needed
 	adc #$00
 	sta $11
 
 	ldy #$00
 	beq left	; ****run draw again to load next line

reset: 

 	lda #$21	; create a pointer at $10
 	sta $10		;   which points to where
 	lda #$02	;   the graphic should be drawn
 	sta $11
 
	lda #$00	; number of rows we've drawn
 	sta $12		;   is stored in $12
 
 	ldx #$00	; index for data
 	ldy #$00	; index for screen column

	

 getkey:lda $ff		; get a keystroke
 
 	ldx #$00	; clear out the key buffer
 	stx $ff

	cmp #$80
	beq plus

	cmp #$82
	beq minus
	
 	jmp getkey

plus:

	inc $13
	jmp left

minus:	
	
	dec $13
	lda $13
	cmp #$00
	bmi loadNine
	jmp left


brk

loadNine:
	lda #$09
	sta $13
	dec $14
	jmp left

numD:

	lda $13
	cmp #$00
	beq z0

 z0:
	;need to also check if beq to zero
	lda $13
	cmp #$01
	bpl z1
	lda zero,x	
 	sta ($10),y
	rts
	
 z1:

	lda $13
	cmp #$02
	bpl z2
	lda one,x	
 	sta ($10),y
	rts
 z2:

	lda $13
	cmp #$03
	bpl z3
	lda two,x	
 	sta ($10),y
	rts

 z3:

	lda $13
	cmp #$04
	bpl z4
	lda three,x	
 	sta ($10),y
	rts
 z4:

	lda $13
	cmp #$05
	bpl z5
	lda four,x	
 	sta ($10),y
	rts

 z5:

	lda $13
	cmp #$06
	bpl z6
	lda five,x	
 	sta ($10),y
	rts
 z6:

	lda $13
	cmp #$07
	bpl z7
	lda six,x	
 	sta ($10),y
	rts

 z7:
	lda $13
	cmp #$08
	bpl z8
	lda seven,x	
 	sta ($10),y
	rts
 z8:
	lda $13
	cmp #$09
	bpl z9
	lda eight,x	
 	sta ($10),y
	rts

 z9:
	lda $13
	cmp #$0a
	beq cReset
	lda nine,x	
 	sta ($10),y
	rts
	
rts 

cReset:

	inc $14		;will be used to track powers 
			;first check $13 if higher than 9 or lower
			;than 0 to either increment or decrement.
	lda #$00
	sta $13
rts
	
 done:	clc	
	jmp getkey		; ****stop when finished

brk

zero:

 dcb 00,00,01,01,01,01,00,00,

 dcb 00,01,00,00,00,00,01,00,

 dcb 00,01,00,00,00,01,01,00,

 dcb 00,01,00,00,01,00,01,00,

 dcb 00,01,00,01,00,00,01,00,

 dcb 00,01,01,00,00,00,01,00,

 dcb 00,01,00,00,00,00,01,00,

 dcb 00,00,01,01,01,01,00,00



one:

 dcb 00,00,01,01,00,00,00,00

 dcb 00,01,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,01,01,01,01,01,00,00



two:

 dcb 00,01,01,01,01,01,00,00

 dcb 01,00,00,00,00,00,01,00

 dcb 00,00,00,00,00,00,01,00

 dcb 00,00,00,00,00,01,00,00

 dcb 00,00,00,01,01,00,00,00

 dcb 00,00,01,00,00,00,00,00

 dcb 00,01,00,00,00,00,00,00

 dcb 01,01,01,01,01,01,01,00



three:

 dcb 00,00,01,01,01,01,01,00

 dcb 00,01,00,00,00,00,00,01

 dcb 00,00,00,00,00,00,00,01

 dcb 00,00,00,00,00,01,01,00

 dcb 00,00,00,00,00,00,00,01

 dcb 00,00,00,00,00,00,00,01

 dcb 00,01,00,00,00,00,00,01

 dcb 00,00,01,01,01,01,01,00



four:

 dcb 00,01,00,00,00,01,00,00

 dcb 00,01,00,00,00,01,00,00

 dcb 00,01,00,00,00,01,00,00

 dcb 00,01,00,00,00,01,00,00

 dcb 00,01,00,00,00,01,00,00

 dcb 00,01,01,01,01,01,01,01

 dcb 00,00,00,00,00,01,00,00

 dcb 00,00,00,00,00,01,00,00



five:

 dcb 00,01,01,01,01,01,01,00

 dcb 00,01,00,00,00,00,00,00

 dcb 00,01,00,00,00,00,00,00

 dcb 00,01,01,01,01,01,00,00

 dcb 00,00,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,00,01,01,01,01,00,00



six:

 dcb 00,00,01,01,01,01,00,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,00,00

 dcb 00,01,01,01,01,01,00,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,00,01,01,01,01,00,00



seven:

 dcb 00,01,01,01,01,01,01,00

 dcb 00,00,00,00,00,00,01,00

 dcb 00,00,00,00,00,01,00,00

 dcb 00,00,00,00,01,00,00,00

 dcb 00,00,00,00,01,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00

 dcb 00,00,00,01,00,00,00,00



eight:

 dcb 00,00,01,01,01,01,00,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,00,01,01,01,01,00,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,00,01,01,01,01,00,00



nine:

 dcb 00,00,01,01,01,01,00,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,00,01,01,01,01,01,00

 dcb 00,00,00,00,00,00,01,00

 dcb 00,01,00,00,00,00,01,00

 dcb 00,00,01,01,01,01,00,00
