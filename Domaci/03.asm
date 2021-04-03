data_seg SEGMENT
    string db 'tenet$'
    ispis01 db 'String je palindrom.$'
    ispis02 db 'String nije palindrom.$'
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

palindrom proc
  mov si, offset string
  petlja01:
    mov al, [si] 
    cmp al, '$'
    je vrati
    inc si
    jmp petlja01    
  ; vracamo se na prethodni karakter
  ; kako ne bismo radili sa $
  vrati:
    mov di, offset string
    dec si
  petlja02:
    cmp si, di
    jmp jeste_palindrom
    mov al, [si] 
    mov bl, [di] 
    cmp al, bl
    jmp nije_palindrom
    dec si
    inc di
    jmp petlja02
  jeste_palindrom:
    writeString ispis01
    krajPrograma
  nije_palindrom:
    writeString ispis02
    krajPrograma
endp

   start:
   ASSUME cs: code_seg, ss: stek_seg, ds: data_seg  
   mov ax, data_seg
   mov ds, ax       
   
   call palindrom
    
code_seg ENDS 
end start