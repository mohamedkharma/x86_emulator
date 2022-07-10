.model calender
.data  

    days        db " SUN MON TUE WED THU FRI SAT$"
    
    Jan         db "          January$           "
    str1        db "|                     1   2|$" 
    str2        db "| 3   4   5   6   7   8   9|$"
    str3        db "|10  11  12  13  14  15  16|$"
    str4        db "|17  18  19  20  21  22  23|$"
    str5        db "|24  25  26  27  28  29  30|$"
    str6        db "|31                        |$"
    
    Feb         db "         February$         "
    str7        db "|     1   2   3   4   5   6|$" 
    str8        db "| 7   8   9  10  11  12  13|$"
    str9        db "|14  15  16  17  18  19  20|$"
    str10       db "|21  22  23  24  25  26  27|$"
    str11       db "|28                        |$"
                                               
    Mar         db "           March$           "
    ;str7        db "     1   2   3   4   5   6$" 
    ;str8        db " 7   8   9  10  11  12  13$"
    ;str9        db "14  15  16  17  18  19  20$"
    ;str10       db "21  22  23  24  25  26  27$"
    str12       db "|28  29  30  31            |$" 
    
    Apr         db "           April$          "
    str13       db "|                 1   2   3|$"
    str14       db "| 4   5   6   7   8   9  10|$"
    str15       db "|11  12  13  14  15  16  17|$"
    str16       db "|18  19  20  21  22  23  24|$"
    str17       db "|25  26  27  28  29  30    |$"
                                               
    Mayy        db "           May$            "
    str18       db "|                         1|$"
    str19       db "| 2   3   4   5   6   7   8|$"
    str20       db "| 9  10  11  12  13  14  15|$"
    str21       db "|16  17  18  19  20  21  22|$"
    str22       db "|23  24  25  26  27  28  29|$"
    str23       db "|30  31                    |$"
    
    Jun         db "           June$           " 
    str24       db "|         1   2   3   4   5|$"
    str25       db "| 6   7   8   9  10  11  12|$"
    str26       db "|13  14  15  16  17  18  19|$"
    str27       db "|20  21  22  23  24  25  26|$"
    str28       db "|27  28  29  30            |$"
                                              
    Jul         db "           July$           "
    ;str13       db "                 1   2   3$"
    ;str14       db " 4   5   6   7   8   9  10$"
    ;str15       db "11  12  13  14  15  16  17$"
    ;str16       db "18  19  20  21  22  23  24$"
    str29       db "|25  26  27  28  29  30  31|$"
    
    Aug         db "          August$          "
    str30       db "| 1   2   3   4   5   6   7|$" 
    str31       db "| 8   9  10  11  12  13  14|$"
    str32       db "|15  16  17  18  19  20  21|$"
    str33       db "|22  23  24  25  26  27  28|$"
    str34       db "|29  30  31                |$"
                                              
    Sep         db "        September$         "
    str35       db "|             1   2   3   4|$"
    str36       db "| 5   6   7   8   9  10  11|$"
    str37       db "|12  13  14  15  16  17  18|$"
    str38       db "|19  20  21  22  23  24  25|$"
    str39       db "|26  27  28  29  30        |$" 
                                               
    Oct         db "         October$          "
    ;str1        db "                     1   2$" 
    ;str2        db " 3   4   5   6   7   8   9$"
    ;str3        db "10  11  12  13  14  15  16$"
    ;str4        db "17  18  19  20  21  22  23$"
    ;str5        db "24  25  26  27  28  29  30$"
    ;str6        db "31                        $"
 
    Nov         db "         November$         "
    ;str7        db "     1   2   3   4   5   6$" 
    ;str8        db " 7   8   9  10  11  12  13$"
    ;str9        db "14  15  16  17  18  19  20$"
    ;str10       db "21  22  23  24  25  26  27$"
    str40       db "|28  29  30                |$" 
    
    Dece        db "         December$         " 
    ;str35       db "             1   2   3   4$"
    ;str36       db " 5   6   7   8   9  10  11$"
    ;str37       db "12  13  14  15  16  17  18$"
    ;str38       db "19  20  21  22  23  24  25$"
    str41       db "|26  27  28  29  30  31    |$" 
    
    
    fastExit    db "Press any key other than N or P to exsit the Calendar $"  ;fast exit
    navigation1 db "Press N for Next or p for Previous month: $"         ;navigation between months january to december
    cal2021     db "        Calender (2021)$      "

.code    
        mov ax,@data             ;move data to ax
        mov ds,ax                ;store ax into ds                                                              
        mov ax, 0300H            ;set the screen screen to  80*25
        
        call january             ;prints the month of January on screen  
        mov cx,1                 ;counter for navigation
        

; This function will be used to take user input        
input:                    
        mov ah,00h               ;take user input
        int 16h                  ;Since the code is using DOS functions, we call the interrupt handler of 16h
                                    
        cmp al,6Eh               ;comparing if user pressed n 
        jz next                  ;jumping to next function to increase cx value by 1
                                    
        cmp al,70h               ;comparing if user pressed p
        jz previous              ;jumping to up function to decrease cx value by 1        
                                                                                       
; This function will be used to stop the program
stop:                               
        mov ax,4C00h    
        int 21h     

; This function will be used to increase cx value by 1
next:           
        inc cx                  ;added one to cx for the next month
        jmp change            ;jump to navigate function to display the next month on the calendar

; This function will be used to decrease cx value by 1
previous:               
        dec cx                  ;subtracting one to cx for watching the previous month
        jmp change            ;jump to navigate function to display the previous month on the calendar

; This function will be used to navigate between the months based on cx value   
change: 
        cmp cx,0     
        jz stop                 ;end the program if cx is less than 1
   
        cmp cx,1 
        jz month1               ;jump to month1 function to print if cx is 1
        
        cmp cx,2                
        jz month2               ;jump to month2 function to print if cx is 2
        
        cmp cx,3                
        jz month3               ;jump to month3 function to print if cx is 3
        
        cmp cx,4
        jz month4               ;jump to month4 function to print if cx is 4
        
        cmp cx,5
        jz month5               ;jump to month5 function to print if cx is 5
        
        cmp cx,6
        jz month6               ;jump to month6 function to print if cx is 6 
        
        cmp cx,7
        jz month7               ;jump to month7 function to print if cx is 7
        
        cmp cx,8
        jz month8               ;jump to month8 function to print if cx is 8
        
        cmp cx,9
        jz month9               ;jump to month9 function to print if cx is 9
        
        cmp cx,10
        jz month10              ;jump to month10 function to print if cx is 10
        
        cmp cx,11
        jz month11              ;jump to month11 function to print if cx is 11
        
        cmp cx,12
        jz month12              ;jump to month12 function to print if cx is 12
        
        cmp cx,13     
        jz stop                 ;end the program if cx is larger than 12
                  
; This function will be used to print the 1 month (Jan)
month1:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call january            ;call the january function to print the month     
        jmp input

; This function will be used to print the 2 month (Feb)        
month2:              
        call clear              ;call the clear function to clear out the screen
        call newline            ;call the newline function to print the next line
        call february           ;call the february function to print the month  
        jmp input

; This function will be used to print the 3 month (Mar)
month3:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call march              ;call the march function to print the month      
        jmp input   
        
; This function will be used to print the 4 month (Apr)
month4:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call april              ;call the april function to print the month      
        jmp input
        
; This function will be used to print the 5 month (may)
month5:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call may                ;call the may function to print the month     
        jmp input
        
; This function will be used to print the 6 month (Jun)       
month6:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call june               ;call the june function to print the month     
        jmp input

; This function will be used to print the 7 month (Jul)       
month7:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call july               ;call the june function to print the month     
        jmp input

; This function will be used to print the 8 month (Aug)       
month8:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call august             ;call the june function to print the month     
        jmp input

; This function will be used to print the 9 month (Sep)       
month9:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call september          ;call the june function to print the month     
        jmp input

; This function will be used to print the 10 month (Oct)       
month10:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call october            ;call the june function to print the month     
        jmp input

; This function will be used to print the 11 month (Nov)       
month11:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call november           ;call the june function to print the month     
        jmp input

; This function will be used to print the 12 month (Dec)       
month12:              
        call clear              ;call the clear function to clear out the screen  
        call newline            ;call the newline function to print the next line 
        call december           ;call the june function to print the month     
        jmp input
                                                       
; This function will be used to clear the screen
clear:                              
        mov ax,0003h            ;this will clear the screen
        int 10h 
        ret
        
; This function will be used to move to the next line
newline:                       
        MOV dl, 10
        MOV ah, 02h
        INT 21h
        MOV dl, 13
        MOV ah, 02h
        INT 21h         
        ret 
               
; This function will be used to print the strings 
print:      
        mov ah,9 
        int 21h 
        ret 
        
; This function will be used to color the string with gray and red      
myColor1:                       ;This is always the default              
        mov ax,0920h            ;Call instruction, 09 (AH) - display string; 20 (AL) - space character.         
        mov bx,008ch            ;Gray and red   
        mov cx,28               ;number of characters to be colored          
        int 10h
        ret

; This function will be used to color the string with white and blue
myColor2:                                    
        mov ax,0920h            ;This is always the default        
        mov bx,0079h            ;White and blue    
        mov cx,28               ;number of characters to be colored          
        int 10h
        ret
        
; This function will be used to color the string with Yellow and green
myColor3:                                    
        mov ax,0920h            ;This is always the default        
        mov bx,002eh            ;Yellow and green    
        mov cx,28               ;number of characters to be colored        
        int 10h
        ret

; This function will be used to print the whole month of january                        
january:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
                                                        
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Jan              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str1            ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str2            ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str3            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str4            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str5            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line  

        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,10    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str6            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 1               ;set the value of cx to match the value of the month
        ret  
                
; This function will be used to print the whole month of february                        
february: 
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Feb              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str7            ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str8            ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str9            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str10           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str11            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 2               ;set the value of cx to match the value of the month 
        ret  
                
          
; This function will be used to print the whole month of march                        
march:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
                     
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Mar              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str7            ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str8            ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str9            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str10            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str12           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 3               ;set the value of cx to match the value of the month
        ret  
                
          
; This function will be used to print the whole month of april                        
april:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Apr              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str13            ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str14            ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str15            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str16            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str17           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 4               ;set the value of cx to match the value of the month
        ret  
                          
; This function will be used to print the whole month of may                        
may:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Mayy              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str18           ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str19           ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str20           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str21           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str22           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,10    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str23           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 5               ;set the value of cx to match the value of the month
        ret  
                
; This function will be used to print the whole month of june                        
june:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Jun              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str24           ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str25           ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str26           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str27           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str28           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 6               ;set the value of cx to match the value of the month
        ret  

; This function will be used to print the whole month of july                        
july:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                ;down shiftd 
        mov dl,25               ;right shifted
        
        int 10h                 ;16 int   
        call myColor3           ;call myColor3 to color the string
        lea dx,cal2021          ;load the welcome string
        call print              ;call print fucntion to print the loaded string
        call newline            ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Jul              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str13           ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str14           ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str15           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str16           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str29           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 7               ;set the value of cx to match the value of the month
        ret  

; This function will be used to print the whole month of june                        
august:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                 ;down shiftd 
        mov dl,25                ;right shifted
        
        int 10h                  ;16 int   
        call myColor3            ;call myColor3 to color the string
        lea dx,cal2021           ;load the welcome string
        call print               ;call print fucntion to print the loaded string
        call newline             ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Aug              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str30           ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str31           ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str32           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str33           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str34           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 8               ;set the value of cx to match the value of the month
        ret  

; This function will be used to print the whole month of june                        
september: 
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                 ;down shiftd 
        mov dl,25                ;right shifted
        
        int 10h                  ;16 int   
        call myColor3            ;call myColor3 to color the string
        lea dx,cal2021           ;load the welcome string
        call print               ;call print fucntion to print the loaded string
        call newline             ;function to move to next line after the string
        
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Sep              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str35           ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str36           ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str37           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str38           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str39           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 9               ;set the value of cx to match the value of the month
        ret  

; This function will be used to print the whole month of june                        
october: 
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                 ;down shiftd 
        mov dl,25                ;right shifted
        
        int 10h                  ;16 int   
        call myColor3            ;call myColor3 to color the string
        lea dx,cal2021           ;load the welcome string
        call print               ;call print fucntion to print the loaded string
        call newline             ;function to move to next line after the string
        
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Oct              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str1            ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str2            ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str3            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str4            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str5            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,10    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str6            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 10              ;set the value of cx to match the value of the month
        ret  

; This function will be used to print the whole month of june                        
november:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                 ;down shiftd 
        mov dl,25                ;right shifted
        
        int 10h                  ;16 int   
        call myColor3            ;call myColor3 to color the string
        lea dx,cal2021           ;load the welcome string
        call print               ;call print fucntion to print the loaded string
        call newline             ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Nov              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str7            ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str8            ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str9            ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str10           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str40           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 11              ;set the value of cx to match the value of the month
        ret  

; This function will be used to print the whole month of june                        
december:
        ; Position the string to the middle 
        mov ah,02h  
        mov bh,00   
        mov dh,1                 ;down shiftd 
        mov dl,25                ;right shifted
        
        int 10h                  ;16 int   
        call myColor3            ;call myColor3 to color the string
        lea dx,cal2021           ;load the welcome string
        call print               ;call print fucntion to print the loaded string
        call newline             ;function to move to next line after the string
         
        ; Position of the string to the center shifted down          
        mov ah,02h  
        mov bh,00   
        mov dh,3    
        mov dl,25
        
        int 10h 
        call myColor1           ;call myColor1 
        lea dx,Dece              ;load Jan string into dx 
        call print              ;call print to display the string
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,4    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                          
        lea dx, days            ;load string into dx                
        call print              ;call print to display the string                                                                             
        call newline            ;call new line to print the next line  
         
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,5    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str35           ;load string into dx                 
        call print              ;call print to display the string                                                                
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h              
        mov bh,00   
        mov dh,6                
        mov dl,25
                       
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str36           ;load string into dx                 
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,7    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str37           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,8    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str38           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
        
        ; Position of the string to the center shifted down
        mov ah,02h  
        mov bh,00   
        mov dh,9    
        mov dl,25
        
        int 10h
        call myColor2           ;call myColor2                       
        lea dx, str41           ;load string into dx                  
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line
                            
        call newline            ;call new line for extra line
         
        lea dx,fastExit         ;load string into dx
        call print              ;call print to display the string    
        call newline            ;call new line to print the next line 
        
        lea dx,navigation1      ;load string into dx                   
        call print              ;call print to display the string      
        mov cx, 12              ;set the value of cx to match the value of the month
        ret  
                                                                             