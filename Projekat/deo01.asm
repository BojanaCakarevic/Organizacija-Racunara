; procedure i makroi dobijeni

data_seg SEGMENT
 pozX db ?
 pozY db ?
 sirina dw ?
 visina dw ?
 adresa dw ?
 boja db ?
 znak db 015
 glavaX db 4 
 glavaY db 4
data_seg ENDS 

stek_seg SEGMENT stack
  dw 128 dup(0)
stek_seg ENDS     

code_seg SEGMENT     
    
; Postavljanje pocetnih vrednosti promenljivih
macro initGraph
 push ax
 mov ax, 0B800h
 mov es, ax
 mov pozX, 0
 mov pozY, 0
 mov sirina, 80
 mov visina, 25
 mov adresa, 0
 mov boja, 7
 pop ax
endm
; Postavljanje tekuce pozicije na poziciju (x, y)
macro setXY x y
 push ax
 push dx
 mov pozX, x
 mov pozY, y

 mov dx, sirina
 shl dx, 1
 mov ax, dx
 mov ah, pozY
 mul ah
 mov dl, pozX
 shl dl, 1
 add ax, dx

 mov adresa, ax
 pop dx
 pop ax
endm
; Postavljanje tekuce boje
macro setColor b
 mov boja, b
endm
; Ispis stringa na ekran
writeString macro str
 LOCAL petlja, kraj
 push ax
 push bx
 push si
 mov si, 0
 mov ah, boja
 mov bx, adresa
petlja:
 mov al, str[si]
 cmp al, '$'
 je kraj
 mov es:[bx], al
 mov es:[bx+1], ah
 add bx, 2
 add si, 1
 jmp petlja
kraj:
 mov ax, si
 add al, pozX
 mov ah, pozY
 setXY al ah
 pop si
 pop bx
 pop ax
endm
; Ucitavanje znaka bez prikaza i memorisanja
keyPress macro
 push ax
 mov ah, 08
 int 21h
 pop ax
endm
; Ucitavanje znaka bez prikaza
readkey macro c
 push ax
 mov ah, 08
 int 21h
 mov c, al
 pop ax
endm
; Ispis znaka na tekucu poziciju
macro Write c
 push bx
 push dx
 mov bx, adresa
 mov es:[bx], c
 mov dl, boja
 mov es:[bx+1], dl
 pop dx
 pop bx
endm
; Kraj programa
krajPrograma macro  
 mov ax, 4c02h
 int 21h
endm

    start:
    ASSUME cs: code_seg, ss: stek_seg, ds: data_seg   
    mov ax, data_seg
    mov ds, ax 
    
    ; inicijalizacija grafike
     initGraph
     
    mov dl, 1
    
    petlja:
        mov ah, 02h
        mov bh, 0
        mov dh, 1
        int 10h
        inc dl 
        
        mov cx, 1
        mov al, znak
        mov ah, 0ah
        int 10h
        
        jmp petlja   
        
    krajPrograma 
code_seg ENDS 
end start