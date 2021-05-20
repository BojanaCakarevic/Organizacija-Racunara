; Modifikovana verzija igrice Zmija

data_seg SEGMENT
 pozX db ?
 pozY db ?
 sirina dw ?
 visina dw ?
 adresa dw ?
 boja db ?
 znak db 177
 smer db ? 
 odgovor db ?       
 x1 dw ?     
 y1 dw ?  
 z1 dw ?     
 k1 dw ?  
 poruka00 db 'SNAKE GAME $'
 poruka01 db 'Pritisnite bilo koji taster da pocnete. $'
 poruka db 'Pritisnite neki taster...$' 
 poruka02 db 'Diskvalifikacija! Niste pokupili hranu.$' 
 poruka03 db 'Igrica se sastoji iz tri nivoa: $'
 poruka04 db  '1. Potrebno je pokupiti svu hranu sa ekrana. $'
 poruka08 db 'OPREZ:Bicete diskvalifikovani ako $'
 poruka10 db 'odete do izlaza pre resavanja zadatka.$'
 poruka05 db '2. U sledecem nivou susrecete se sa preprekama.$'  
 poruka09 db 'Potrebno je doci do obelezenog cilja.$'
 poruka06 db '3. Poslednji nivo objedinjuje prva dva. $'
 poruka07 db 'SRECNO! $'     
 poruka11 db 'Cestitamo! Prelazite na sledeci nivo. $' 
 poruka12 db 'Cestitamo, presli ste igriicu! $' 
 poruka13 db 'Pokusajte ponovo. $' 
 poruka14 db 'Pritisnite tastern "d" da ponovo pokrenete igru. $'  
 poruka15 db 'Pritisnite bilo koji taster da napustite igru. $'
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

; Brisanje znaka
obrisiZnak PROC  
  push ax
  push bx
  push cx
  mov cx, 1  
  mov bh, 0
  mov al, ' '
  mov ah, 0ah
  int 10h
  pop cx
  pop bx
  pop ax  
  ret  
obrisiZnak ENDP   

; Uzimanje pozicije
pozicija PROC
   mov ah, 08h
   mov bh, 0
   int 10h      
   ret
pozicija ENDP

; Postavljanje kursora      
kretanje PROC    
    push ax
    push bx
    push cx
    ; Postavljanje Kursora
     mov ah, 02h
     mov bh, 0
     int 10h 
    ; Provera pozicije u odnosu na znak
     call pozicija
     cmp al, znak
     je kraj  
     cmp al, 004
     je kraj 
     cmp al, 'x'
     je izlaz  
     cmp al, 'K'
     je hrana  
     cmp al, 'C'
     je dalje02
     ; Postavljanje znaka   
     mov cx, 1 
     mov bh, 0
     mov al, 004
     mov ah, 0ah
     int 10h    
     pop cx
     pop bx
     pop ax
     ret    

kretanje ENDP      

; Provera da li je pritisnut neki taster
provera PROC   
     push ax
     mov ah, 0Bh
     int 21h 
     cmp al, 0
     pop ax  
     ret  
provera ENDP

; Brisanje ekrana
macro clrScreen
 LOCAL petlja
 push bx
 push cx
 mov bx, 0
 mov cx, 2000
petlja:
 mov es:[bx], ' '
 mov es:[bx+1], 7
 add bx, 2
 loop petlja
 pop cx
 pop bx
endm          

; Crtanje okvira
nacrtajOkvir proc
 push ax
 push bx
 push cx
 push si
 mov bx, 0
 mov si, 3840
 mov cx, 80
 mov al, znak
 mov ah, boja
 petljaHor:
 mov es:[bx], al
 mov es:[bx+1], ah
 mov es:[bx+si], al
 mov es:[bx+si+1], ah
 add bx, 2
 loop petljaHor
 mov cx, 23
 mov bx, 160
 mov si, 158
 petljaVer: 
 mov es:[bx], al
 mov es:[bx+1], ah
 mov es:[bx+si], al
 mov es:[bx+si+1], ah
 add bx, 160
 loop petljaVer
 pop si
 pop cx
 pop bx
 pop ax
 ret
nacrtajOkvir endp  

; Postavljanje prepreka    
prepreke proc
 push ax
 push bx
 push cx
 mov bx, 0
 mov cx, x1    
 mov si, y1
 mov al, znak
 mov ah, boja  
 horizontalno:
 mov es:[bx+si], al
 mov es:[bx+1+si], ah
 add bx, 2
 loop horizontalno     
 mov cx, z1   
 mov bx, 160  
 mov si, k1
 vertikalno:
 mov es:[bx+si], al
 mov es:[bx+si+1], ah
 add bx, 160 
 loop vertikalno 
 pop cx
 pop bx
 pop ax               
 ret
prepreke endp 
      
    start:
    ASSUME cs: code_seg, ss: stek_seg, ds: data_seg   
    mov ax, data_seg
    mov ds, ax 
 
 pocetak: 
 
    initGraph
    setColor 5
    call nacrtajOkvir
      
 ;   Izbaceno zbog sporog izvrsavanja makroa 'clrScreen' 
;    setXY 30 6
;    writeString poruka00 
;    setXY 15 8
;    writeString poruka01
;    setXY 20 9
;    writeString poruka03 
;    setXY 25 10          
;    writeString poruka04
;    setXY 25 11
;    writeString poruka08
;    setXY 25 12    
;    writeString poruka10
;    setXY 25 13
;    writeString poruka05
;    setXY 25 14
;    writeString poruka09
;    setXY 25 15
;    writeString poruka06  
;    setXY 30 18
;    writeString poruka07
;    keyPress              
 ;   clrScreen
     
     setxy 20 12
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'     
     
     setXY 22 16
     mov bx, adresa
     mov al, es:[bx]   
     mov es:[bx], 'x'  
     
     setXY 76 15
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'  
     
     setXY 36 3
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'
     
     setXY 47 17
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'  
     
     mov dl, 5   
     mov dh, 5 
    
 petljaGl:  
    call provera
    je petlja
    jne petlja02
   
    petlja:    
    call obrisiZnak 
    inc dl  
    call kretanje
    jmp petljaGl
     
    petlja02:    
    readKey smer
    cmp smer, '2'
    je dole  
    cmp smer, '4'
    je levo
    cmp smer, '6'
    je desno
    cmp smer, '8'
    je gore
    
    dole: 
    call obrisiZnak   
    inc dh
    call kretanje 
    call provera  
    call obrisiZnak
    je dole
    jne petlja02
   
    levo:  
    call obrisiZnak 
    dec dl   
    call kretanje  
    call provera
    je levo        
    jne petlja02
    
    desno:
    call obrisiZnak 
    inc dl         
    call kretanje
    call provera
    je desno      
    jne petlja02
    
    gore:
    call obrisiZnak 
    dec dh
    call kretanje
    call provera
    je gore       
    jne petlja02   
 
izlaz:
   setXY 72 22
   mov bx, adresa
   mov al, es:[bx]
   mov es:[bx], 'K' 
   jmp petlja
 
hrana:
   mov al, 20
   mov ah, 12
   setXY al ah
   mov bx, adresa
   mov al, es:[bx]  
   mov ah, ' '
   cmp al, ah
   je hrana02 
   jne diskvalifikacija  
     
   hrana02:
   setxy 36 3
   mov bx, adresa         
   mov al, es:[bx]
   cmp al, ' '
   je hrana03 
   jne diskvalifikacija
     
   hrana03:
   setxy 76 15
   mov bx, adresa
   mov al, es:[bx]
   cmp al, ' '
   je hrana04   
   jne diskvalifikacija
     
   hrana04:
   setxy 47 17   
   mov bx, adresa
   mov al, es:[bx]
   cmp al, ' ' 
   je hrana05  
   jne diskvalifikacija
     
   hrana05:
   setxy 22 16
   mov bx, adresa
   mov al, es:[bx]
   cmp al, ' '
   je dalje
   jne diskvalifikacija 
 
diskvalifikacija:  
    setXY 5 5
    writeString poruka02
    jmp kraj
    
dalje: 
    setxy 28 4
    mov bx, adresa         
    mov al, es:[bx]
    cmp al, znak
    je pobeda   
    setXY 5 5
    writeString poruka11 
    clrScreen     
    mov dl, 5   
    mov dh, 5 
    call nacrtajOkvir
   
petlja03:
    mov y1, 680
    mov x1, 10 
    mov z1, 10
    mov k1, 80           
    call prepreke
    mov y1, 2960
    mov x1, 15
    mov z1, 3
    mov k1, 2340
    call prepreke 
    mov y1, 2100
    mov x1, 16
    call prepreke 
    
    setxy 60 13
    mov bx, adresa
    mov al, es:[bx]
    mov es:[bx], 'C'  
    jmp petljaGl      
    
dalje02:
    setXY 5 5
    writeString poruka11 
    clrScreen    
    mov dl, 5   
    mov dh, 5 
    call nacrtajOkvir   
    
    setxy 20 12
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'     
     
     setXY 22 16
     mov bx, adresa
     mov al, es:[bx]   
     mov es:[bx], 'x'  
     
     setXY 76 15
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'  
     
     setXY 36 3
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'
     
     setXY 47 17
     mov bx, adresa
     mov al, es:[bx]
     mov es:[bx], 'x'    
     
     mov y1, 680
     mov x1, 10 
     mov z1, 10
     mov k1, 80           
     call prepreke
     mov y1, 2960
     mov x1, 15 
     mov z1, 3
     mov k1, 2340
     call prepreke 
     mov y1, 2100
     mov x1, 16
     call prepreke 
    
     jmp petljaGl      

   pobeda:   
    setXY 5 5
    writeString poruka12 
    setXY 5 6
    writeString poruka14    
    setXY 5 7
    writeString poruka15
    readKey odgovor 
    cmp odgovor, 'd'
    je pocetak
    krajPrograma
      
   kraj:   
    setXY 5 5
    writeString poruka13  
    clrScreen
    jmp pocetak   
    
code_seg ENDS 
end start                                                                                                                          
