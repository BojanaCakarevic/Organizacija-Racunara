; pretpostavimo da je kraj niza obelezen nulom 
; i da negativni brojevi nisu dozvoljeni

data_seg SEGMENT
   niz db 3,2,55,6,1,0
   unos01 db "Niz je sortiran. $" 
data_seg ENDS  
       
       
stek_seg SEGMENT stack
   m dw 128 dup(0)
stek_seg ENDS  
     
     
code_seg SEGMENT  
    writeString macro s
    push ax
    push dx  
    mov dx, offset s
    mov ah, 09
    int 21h
    pop dx
    pop ax
endm        

krajPrograma macro   
    mov ax, 4c02h
    int 21h
endm      
    
   start:
   ASSUME cs: code_seg, ss: stek_seg, ds: data_seg    
   
   mov dx, offset data_seg
   mov ds, dx   
    
   petlja:
    mov al, niz[si]
    inc si 
    mov ah, niz[si]
    cmp ah, 0
    je kraj
    
    cmp al, ah
    je preskoci
    jl manji
    jg veci 
    
   preskoci:
    inc si
    
   veci:   
    mov bl, al
    mov niz[si], bl
    dec si
    mov niz[si], ah 
    dec si      
    mov bl, niz[si]   
    inc si
    mov bh, niz[si] 
    dec si     
    cmp bl, bh     
    jg petlja 
    inc si
    inc si
    jmp petlja
    
   manji: 
    jmp petlja 
    
   kraj:    
    mov si, 0   
    writeString unos01
 ;  mov cl, niz[si] 
 ;  mov cl, niz[si+1]
 ;  mov cl, niz[si+2]  
    krajPrograma
    
code_seg ENDS 
end start    