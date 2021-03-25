; Napisati asembler program koji proverava da li je
; rezultat zbira dva broja paran ili ne.
; Parnost sacuvati kao informaciju u registru SI 
; (ako je broj paran postaviti ga na 1, u suprotnom na 0).

data_seg SEGMENT
 br1 dw 5
 br2 dw 2
 rez dw ?
data_seg ENDS
code_seg SEGMENT
 ASSUME cs:code_seg, ds:data_seg

 start: MOV dx, offset data_seg
 MOV ds, dx

 MOV ax, br1
 ADD ax, br2
 MOV rez, ax

 MOV ax, rez
 MOV bl, 2
 DIV bl

 CMP ah, 0
 je paran
 CMP ah, 1
 jmp kraj

 paran:
 mov si, 1

 kraj: jmp kraj
 end start

code_seg ENDS
END