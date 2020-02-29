define		SCINIT		$ff81 ; initialize/clear screen
define		CHRIN		$ffcf ; input character from keyboard
define		CHROUT		$ffd2 ; output character to screen
define		SCREEN		$ffed ; get screen size
define		PLOT		$fff0 ; get/set cursor coordinates
define		cur_pos		$13	;cursor position

	lda #$00	;set pointer at $10 to $0200
	sta $10
	lda #$02	;page position and store it in $11
	sta $11		   
	lda #$00	;set position at 0 and store at cur_pos ($13)
	sta cur_pos	
	jsr SCINIT
	ldy #$00

char:     
	lda text,y	;will output the list of colors
	beq getkey	;begin checking for input if list is done
	jsr CHROUT	;else print the character, increment y, and loop until done
	iny
	bne char

 getkey:
	lda $ff		;get a keystroke
	beq getkey	;fixes input lag	
	ldx #$00	;clear out the key buffer
 	stx $ff
	cmp #$80	;up
	beq dec_color
	cmp #$82	;donw
	beq inc_color
 	jmp getkey

clear_cursor:

	lda #$2d             ; character - / $ad is the reverse version
	jsr print_cursor
	rts

print_cursor:
	
	clc                  ; clearing the carry triggers "set" function for PLOT
	ldx #$00
	ldy cur_pos          
	pha                  ; push whats in the accumulator, onto the stack
	jsr PLOT             ; set the cursor position
	pla                  ; pull the accumulator value that was pushed on the stack
	jsr CHROUT           ; print the char
	rts

max_reset:
	lda  #$00
	sta cur_pos
	rts

min_reset:
	lda  #$0f
	sta cur_pos
	rts

max_bound:		;check if cursor position exceeds the list of 16 colors

	lda  cur_pos
	cmp #$10
	beq max_reset	;adjust if out of bounds
	rts

min_bound:

	lda cur_pos
	cmp #$ff
	beq min_reset
	rts

inc_color:
	
	jsr clear_cursor
	inc cur_pos
	jsr max_bound
	lda cur_pos
	lda #$2d
	ora #$80	;makes #$2d negative/ alternatively $ad could have been used            
	jsr print_cursor
	ldy #$00	;reset pixel index
	lda #$02	;reset page count and store in $11
	sta $11
	lda cur_pos ; load page number as color
	jmp fill

dec_color:
	 
	jsr clear_cursor
	dec cur_pos
	jsr min_bound
	lda cur_pos
	lda #$2d
	ora #$80             ; character black box
	jsr print_cursor
	
	ldy #$00
	lda #$02
	sta $11
	lda cur_pos ; load page number as color
	jmp fill

fill: 
	sta ($10),y  ; store color
      	iny          ; increment index
      	bne fill     ; branch until page done    
      	inc $11      ; increment high byte of pointer
	ldx $11
      	cpx #$06     ; compare with max value
      	bne fill     ; continue if not done      
	jmp getkey

done:     
	brk

 text:
 
    dcb $ad,"B","l","a","c","k",13 

    dcb "-","W","h","i","t","e",13 

    dcb "-","R","e","d",13 

    dcb "-","C","y","a","n",13 

    dcb "-","P","u","r","p","l","e",13 

    dcb "-","G","r","e","e","n",13 

    dcb "-","B","l","u","e",13 

    dcb "-","Y","e","l","l","o","w",13 

    dcb "-","O","r","a","n","g","e",13 

    dcb "-","B","r","o","w","n",13 

    dcb "-","L","i","g","h","t",32,"r","e","d",13 

    dcb "-","D","a","r","k",32,"g","r","e","y",13 

    dcb "-","G","r","e","y",13 

    dcb "-","L","i","g","h","t",32,"g","r","e","e","n",13 

    dcb "-","L","i","g","h","t",32,"b","l","u","e",13 

    dcb "-","L","i","g","h","t",32,"g","r","e","y",00
