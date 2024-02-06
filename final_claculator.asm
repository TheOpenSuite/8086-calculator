org 100h
.data
msg:     db      0dh,0ah,"1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide", 0Dh,0Ah,"5-Results", 0Dh,0Ah,"6-Sort(high to low)", 0Dh,0Ah,"7-Sort(low to high)", 0Dh,0Ah,"8-List evens and odds", 0Dh,0Ah,"9-check divisibility", 0Dh,0Ah,"0-Import File", 0Dh,0Ah,"q-exit", 0Dh,0Ah, '$'
msg2:    db      0dh,0ah,"Enter First No: $"
msg3:    db      0dh,0ah,"Enter Second No: $"
msg4:    db      0dh,0ah,"Choice Error $" 
msg5:    db      0dh,0ah,"Result : $" 
msg6:    db      0dh,0ah,"The numbers divisible are: $"
msg7:    db      0dh,0ah,"Results : $"
msgE:    db      0Dh,0Ah,'Even numbers: ',0Dh,0Ah, '$'
msgO:    db      0Dh,0Ah,'Odd numbers: ',0Dh,0Ah, '$'
msgD:    db      0dh,0ah,"Enter a number to check: $"
msgI:    db      0dh,0ah,'Imported Successfully',0dh,0ah,'$' 
results  db      50 dup('$') 
RC       dw      0
results2 db      50 dup('$')
C3       dw      0
C2       dw      0
C1       dw      0
evens    db      50 dup('$')
odds     db      50 dup('$')
divby    db      50 dup('$')
T1       dw      0
file     db      'input.txt',0

.code

start:  
        mov C1,0h
        mov C2,0h
        mov C3,0h
        mov ah,9
        mov dx, offset msg ;first we will display hte first message from which he can choose the operation using int 21h
        int 21h
        mov ah,0                       
        int 16h  ;then we will use int 16h to read a key press, to know the operation he choosed
        cmp al,31h ;the keypress will be stored in al so, we will comapre to 1 addition ..........
        je Addition
        cmp al,32h
        je Multiply
        cmp al,33h
        je Subtract
        cmp al,34h
        je Divide
        cmp al,35h
        je View_Results
        cmp al,36h
        jne a
        call SortLTH        
   a:   
        cmp al,37h
        jne b
        call SortHTL        
   b:   
        cmp al,38h
        jne c
        call even_odd
   c:   
        cmp al,39h
        jne d
        call Div_by
   d:   
        cmp al,51h
        jne e
        call exit
   e:
        cmp al,71h
        jne f
        call exit
   f:   
        cmp al,30h
        jne g
        call import
   g:
        mov ah,09h
        mov dx, offset msg4
        int 21h
        mov ah,0
        int 16h
        jmp start
        
Addition:   mov ah,9  ;then let us handle the case of addition operation
            mov dx, offset msg2  ;first we will display this message enter first no also using int 21h
            int 21h
            mov cx,0 ;we will call InputNo to handle our input as we will take each number seprately
            call InputNo  ;first we will move to cx 0 because we will increment on it later in InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            add dx,bx
            push dx
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx 
            mov si, offset results 
            add si,RC
            mov [si], dx   
            add RC, 2               
            call View  
            jmp start
            
InputNo:    mov ah,0
            int 16h ;then we will use int 16h to read a key press     
            mov dx,0  
            mov bx,1 
            cmp al,0dh ;the keypress will be stored in al so, we will comapre to  0d which represent the enter key, to know wheter he finished entering the number or not 
            je FormNo ;if it's the enter key then this mean we already have our number stored in the stack, so we will return it back using FormNo
            sub ax,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ascii to decimal
            call ViewNo ;then call ViewNo to view the key we pressed on the screen
            mov ah,0 ;we will mov 0 to ah before we push ax to the stack bec we only need the value in al
            push ax  ;push the contents of ax to the stack
            inc cx   ;we will add 1 to cx as this represent the counter for the number of digit
            jmp InputNo ;then we will jump back to input number to either take another number or press enter          
   

;we took each number separatly so we need to form our number and store in one bit for example if our number 235
FormNo:     pop ax; Take the last input from the stack  
            push dx      
            mul bx;Here we are multiplying the value of ax with the value of bx
            pop dx;After multiplication we will remove it from stack
            add dx,ax;After removing from stack add the value of dx with the value of ax
            mov ax,bx;Then set the value of bx in ax       
            mov bx,10
            push dx;push the dx value again in stack before multiplying to resist any kind of accidental effect
            mul bx;Multiply bx value by 10
            pop dx;pop the dx after multiplying
            mov bx,ax;Result of the multiplication is still stored in ax so we need to move it in bx
            dec cx;After moving the value we will decrement the digit counter value
            cmp cx,0;Check if the cx counter is 0
            jne FormNo;If the cx counter is not 0 that means we have multiple digit input and we need to run format number function again
            ret;If the cx counter is 0 that means all of our digits are fully formatted and stored in bx we just need to return the function   


       
       
View:       mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne View
            ret


ViewNo:    push ax ;we will push ax and dx to the stack because we will change there values while viewing then we will pop them back from
           push dx ;the stack we will do these so, we don't affect their contents
           mov dx,ax ;we will mov the value to dx as interrupt 21h expect that the output is stored in it
           add dl,30h ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h
           pop dx  
           pop ax
           ret
      
   
exit:    

        mov ah, 0
        int 21h
               
            
                       
Multiply:   mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,dx
            mul bx 
            mov dx,ax
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            mov si, offset results 
            add si,RC
            mov [si], dx   
            add RC, 2
            call View 
            jmp start

Subtract:   mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            sub bx,dx
            mov dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            mov si, offset results 
            add si,RC
            mov [si], dx   
            add RC, 2
            call View 
            jmp start
    
            
Divide:     mov ah,9
            mov dx, offset msg2
            int 21h
            mov cx,0
            call InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call InputNo
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            mov bx,0
            div cx
            mov bx,dx
            mov dx,ax
            push bx 
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            mov si, offset results 
            add si,RC
            mov [si], dx   
            add RC, 2
            call View
            pop bx
            cmp bx,0
            je start      
            
inc_res:    
            mov ah,2h
            mov dl,','
            int 21h
            add si, 2
            mov dx,[si]
            mov cx,10000
            jmp ViewR:  
            
View_Results:
            mov ah,9
            mov dx, offset msg7
            int 21h    
            mov si, offset results
            mov dx, [si]
            mov cx, 10000 
ViewR:      
                        
            cmp dx,2424h
            je start
            mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne ViewR  
            jmp inc_res
            
;--------------------------------------------------------

SortLTH PROC 
    
    mov SI,offset results
    mov DI,offset results2
    FILL:
    cmp [si],2424h
    je  S 
    mov AX,[SI]
    mov [DI],AX
    add SI,2
    add DI,2
    jmp FILL
    
    
    
    
    
    
    S:
    MOV AX,RC 
    MOV BH,2
    DIV BH
    MOV CL,AL
    mov CH,00h
    mov C2,CX
    dec cx
           
    NEXTSCAN:
    mov AH,00
    mov BH,00
    mov DH,00
    MOV BX,C2
    mov DI,offset results2  
    dec BX
    NEXTCOMP:
    MOV AL,[DI]
    add DI,2
    MOV DL,[DI]
    sub DI,2
    CMP AL,DL
    JC NOSWAP 
    MOV [DI],DL
    inc DI
    mov [DI],00h
    inc DI
    MOV [DI],AL
    inc DI
    mov [DI],00h
    dec DI
    NEXT:
    dec BX
    JNZ NEXTCOMP
    LOOP NEXTSCAN
    
    jmp View_Results2  
    NOSWAP:
    MOV [DI],AL
    inc DI
    mov [DI],00h
    inc DI
    MOV [DI],DL
    inc DI
    mov [DI],00h
    dec DI
    jmp NEXT
    

inc_res2:    
            mov ah,2h
            mov dl,','
            int 21h
            add si, 2
            mov dx,[si]
            mov cx,10000
            jmp ViewR2:  
            
View_Results2:    
            mov si, offset results2
            mov dx, [si]
            mov cx, 10000 
ViewR2:      
                        
            cmp dx,2424h
            je start
            mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne ViewR2  
            jmp inc_res2 
EndP          

;--------------------------------------------------

SortHTL PROC 
    
    mov SI,offset results
    mov DI,offset results2
    FILL1:
    cmp [si],2424h
    je  S1 
    mov AX,[SI]
    mov [DI],AX
    add SI,2
    add DI,2
    jmp FILL1
    
    
    
    
    
    
    S1:
    MOV AX,RC 
    MOV BH,2
    DIV BH
    MOV CL,AL
    mov CH,00h
    mov C2,CX
    dec cx
           
    NEXTSCAN1:
    mov AH,00
    mov BH,00
    mov DH,00
    MOV BX,C2
    mov DI,offset results2  
    dec BX
    NEXTCOMP1:
    MOV AL,[DI]
    add DI,2
    MOV DL,[DI]
    sub DI,2
    CMP AL,DL
    JB  NOSWAP1 
    MOV [DI],AL
    inc DI
    mov [DI],00h
    inc DI
    MOV [DI],DL
    inc DI
    mov [DI],00h
    dec DI
    NEXT1:
    dec BX
    JNZ NEXTCOMP1
    LOOP NEXTSCAN1
    
    jmp View_Results21  
    NOSWAP1:
    MOV [DI],DL
    inc DI
    mov [DI],00h
    inc DI
    MOV [DI],AL
    inc DI
    mov [DI],00h
    dec DI
    jmp NEXT1
    

inc_res21:    
            mov ah,2h
            mov dl,','
            int 21h
            add si, 2
            mov dx,[si]
            mov cx,10000
            jmp ViewR21:  
            
View_Results21:    
            mov si, offset results2
            mov dx, [si]
            mov cx, 10000 
ViewR21:      
                        
            cmp dx,2424h
            je start
            mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne ViewR21  
            jmp inc_res21 
EndP  

;----------------------------------------------

even_odd PROC 
    
rst:
    
    mov si, offset Results 
    add si, C1
    mov ax, [si]
    push ax
    add C1, 2
    cmp ax, 2424h
    je ViewE 

    mov bl, 02h
    div bl

    cmp ah, 0h
    pop ax
    
    jnz odd

    mov si, offset Evens
    add si, C3
    add C3, 2
    mov [si], ax
    inc si
    mov [si], 0h

    jmp Even

Odd:  

    mov si, offset odds
    add si, C2
    add C2, 2
    mov [si], ax
    inc si
    mov [si], 0h
                

Even: 

    jmp rst 
     

ViewE: 
    
    mov dx, offset msgE 
    mov ah, 09H
    int 21H
    jmp View_ResultsE  
    
inc_resE:    
            mov ah,2h
            mov dl,','
            int 21h
            add si, 2
            mov dx,[si]
            mov cx,10000
            jmp ViewRE:  
            
View_ResultsE:    
            mov si, offset Evens
            mov dx, [si]
            mov cx, 10000 
ViewRE:      
                        
            cmp dx,2424h
            je ViewO
            mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne ViewRE 
            jmp inc_resE  
            
ViewO: 
    
    mov dx, offset msgO 
    mov ah, 09H
    int 21H
    jmp View_ResultsO   
    
inc_resO:    
            mov ah,2h
            mov dl,','
            int 21h
            add si, 2
            mov dx,[si]
            mov cx,10000
            jmp ViewRO:  
            
View_ResultsO:    
            mov si, offset Odds
            mov dx, [si]
            mov cx, 10000 
ViewRO:      
                        
            cmp dx,2424h
            je start
            mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne ViewRO 
            jmp inc_resO

EndP  

;------------------------------------------

Div_by Proc
    mov ax, 0h
    mov dx, offset msgD
    mov ah,09h
    int 21h
    mov ah,0                       
    int 16h
    sub ax,'0'
    push ax
    mov bl, al 
rest:
    
    mov si, offset results
    add si, C1
    add C1, 2
    cmp [si], 2424h
    je ViewD 

    mov ax, [si]
    div bl

    cmp ah, 0h
    jne rest       
    
    mov ax, [si]
    mov si, offset divby
    add si, C2
    add C2, 2
    mov [si],ax 
    inc si
    mov [si],0h
    jmp rest

ViewD: 
    
    mov dx, offset msg6 
    mov ah, 09H
    int 21H
    jmp View_ResultsD   
    
inc_resD:    
            mov ah,2h
            mov dl,','
            int 21h
            add si, 2
            mov dx,[si]
            mov cx,10000
            jmp ViewRO:  
            
View_ResultsD:    
            mov si, offset divby
            mov dx, [si]
            mov cx, 10000 
ViewRD:      
                        
            cmp dx,2424h
            je start
            mov ax,dx
            mov dx,0
            div cx 
            call ViewNo
            mov bx,dx 
            mov dx,0
            mov ax,cx 
            mov cx,10
            div cx
            mov dx,bx 
            mov cx,ax
            cmp ax,0
            jne ViewRD 
            jmp inc_resD

    
EndP  

;--------------------------------------------------

Import Proc
mov dx,offset file
mov al,0 ;openfile (read-only)
mov ah,3dh
int 21h ;call the interupt    
mov RC,0
mov bx,ax


mov cx,2 ;read one character at a time
printi:
mov ax,0
mov ah,3fh ;read from the opened file (its handler in bx)
int 21h 
mov di,dx
mov ax,[di] ;char is in dl, send to ax for printing (char is in al) 
cmp ax,2424h
je redmsg
cmp ax,2020h
je printi
sub ah,'0' 
sub al,'0'
push bx   ;to save the handler 
mov bx,0
mov bl,ah
mov ah,0
mov T1,10
mul T1
add ax,bx 
mov si, offset results
add si, RC
mov [si] , ax
add RC,2
pop bx     ;restoring the handler
jmp printi ;repeat if not end of file 

redmsg:
mov ah,9
mov dx, offset msgi 
int 21h 
jmp start

             
Endp