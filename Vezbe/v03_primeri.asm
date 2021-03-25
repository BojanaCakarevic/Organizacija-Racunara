; Napisati proceduru koja prebacuje 
; ispis na ekranu u novi red  

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


; Napisati makro koji ucitava jedan znak sa 
; tastature i prikazuje ga na ekranu    

read macro c
    push ax
    mov ah, 01
    int 21h
    mov c, al
    pop ax
endm


; Napisati makro koji ispisuje jedan znak na ekran

read macro c   
    push ax, dx
    mov ah, 02
    mov dl, c
    int 21h
    pop dx, ax
endm   


; Napisati makro koji ucitava jedan znak sa tastature
; i NE prikazuje ga na ekranu

read macro c
    push ax
    mov ah, 08
    int 21h
    mov c, al
    pop ax
endm     


; Napisati makro koji ispisuje string na ekran    

writeString macro s
    push ax
    push dx  
    mov dx, offset s
    mov ah, 09
    int 21h
    pop dx
    pop ax
endm
 
 
; Napisati proceduru koja ucitava string sa tastature

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
    mov byte [bx], al
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
    ret
readString endp
    
    
    
    
