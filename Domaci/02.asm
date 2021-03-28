;Napisati asembler program koji ucitava niz duzine 10 brojeva
; od korisnika i u njemu pronalazi i ispisuje minimum na ekran.

data_seg SEGMENT       
    niz dw 10 dup(?)
    n dw ?    
    min dw ?
    
    nString db "   "
    minString db " "
  
    unos01 db "Unesite broj u niz: $"
    ispis01 db "Minimum ovog niza je: $"
    ispis02 db "Pritisnite bilo koji taster: $" 
data_seg ENDS   

stek_seg SEGMENT stack
    dw 128 dup(0)
stek_seg ENDS

code_seg SEGMENT   
; ispis stringa na ekran
writeString macro s
    push ax
    push dx  
    mov dx, offset s
    mov ah, 09
    int 21h
    pop dx
    pop ax
endm           
; prebacivanje ispisa u novi red
novired proc
    push ax 
    push bx 
    push cx 
    push dx
    mov ah, 03
    mov bh, 0
    int 10h
    inc dh
    mov dl,0
    mov ah, 02
    int 10h
    pop dx 
    pop cx 
    pop bx 
    pop ax
    ret
novired endp        
    
keypress macro
    push ax
    mov ah, 08
    int 21h
    pop ax
endm
    
; kraj programa
krajPrograma macro
    mov ax, 4c02h
    int 21h
endm    
    
; ucitavanje stringa sa tastature
readString proc
    push ax
    push bx
    push cx
    push dx
    push si
    mov bp, sp
    mov dx, [bp+12]
    mov bx, dx
    mov ax, [bp+14]
    mov byte [bx] ,al
    mov ah, 0Ah
    int 21h
    mov si, dx     
    mov cl, [si+1] 
    mov ch, 0
kopiraj:
    mov al, [si+2]
    mov [si], al
    inc si
    loop kopiraj     
    mov [si], '$'
    pop si  
    pop dx
    pop cx
    pop bx
    pop ax
    ret 4
readString endp

; konvertovanje stringa u intidzer
strtoint proc
    push ax
    push bx
    push cx
    push dx
    push si
    mov bp, sp
    mov bx, [bp+14]
    mov ax, 0
    mov cx, 0
    mov si, 10
petlja1:
    mov cl, [bx]
    cmp cl, '$'
    je kraj1
    mul si
    sub cx, 48
    add ax, cx
    inc bx  
    jmp petlja1
kraj1:
    mov bx, [bp+12] 
    mov [bx], ax 
    pop si  
    pop dx
    pop cx
    pop bx
    pop ax
    ret 4
strtoint endp  

; konvertovanje intidzera u string
inttostr proc
   push ax
   push bx
   push cx
   push dx
   push si
   mov bp, sp
   mov ax, [bp+14] 
   mov dl, '$'
   push dx
   mov si, 10
petlja2:
   mov dx, 0
   div si
   add dx, 48
   push dx
   cmp ax, 0
   jne petlja2   
   mov bx, [bp+12]
petlja2a:      
   pop dx
   mov [bx], dl
   inc bx
   cmp dl, '$'
   jne petlja2a
   pop si  
   pop dx
   pop cx
   pop bx
   pop ax 
   ret 4            
inttostr endp 

; ----------------------------------------------                                        
   start:
   ASSUME cs: code_seg, ss: stek_seg, ds: data_seg
   mov ax, data_seg         
   mov ds, ax
   mov cx, 10
 
unos:
    writeString unos01
    push 4
    push offset nString
    call readString
    push offset nString
    push offset n
    call StrToInt  
    call novired
    
    mov ax, n
    mov niz[si], ax
    add si, 2
    loop unos
    
    mov si, 0
    mov ax, niz[si]
    mov min, ax
    mov cx, 9
    
petlja: 
    add si, 2
    mov bx, niz[si]
    cmp min, bx
    jl next
    mov min, bx

next:
    loop petlja
                         
push min                         
push offset minString    
call inttostr
call novired
writeString ispis01
writeString minString
call novired         

writeString ispis02 
call novired     

keypress
krajprograma
     
code_seg ENDS 
end start