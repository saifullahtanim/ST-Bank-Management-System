; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
include "emu8086.inc"                               
.stack 100h                    
                               
.data
    ;menu message
    menu db 13, 10, 13, 10, 13, 10, "          *********************************    "
         db 13, 10, "         /                                 \   "
         db 13, 10, "        /            ST Bank Menu          \  "
         db 13, 10, "       /                                     \ " 
         db 13, 10, "      /                                       \"
         db 13, 10, "      *****************************************"
         db 13, 10, "      |                                       |"
         db 13, 10, "      | Press 1 to check the personal detail. |"
         db 13, 10, "      | Press 2 to open the new account.      |" 
         db 13, 10, "      | Press 3 to check balance.             |"
         db 13, 10, "      | Press 4 to change pin.                |"
         db 13, 10, "      | Press 5 to deposit amount.            |"
         db 13, 10, "      | Press 6 to withdraw amount.           |"
         db 13, 10, "      | Press 0 to Exit.                      |"
         db 13, 10, "      |                                       |"    
         db 13, 10, "      *****************************************"
         db 13,10, 13,10, "Select any option in this menu : $"
    
    wrong_input   db 13, 10, "******* ( Enter a Correct Input ) *******$"         
    select_option db ?
    
    ;String message
    enter_name    db 13, 10, "Enter your name : $"
    enter_father  db 13, 10, "Enter your Father Name : $"
    enter_balance db 13, 10, "How much amount do you want to deposit into your new account : $"
    enter_pin     db 13, 10, "Enter a Two digit PIN : $"
    account_no    db 13, 10, "This's your account number : $"
    enter_acc_no  db 13, 10, "Enter your account number : $"
    not_fount     db 13, 10, "Not Found$"
    check_bal     db 13, 10, "Your Total amount is : $"
    check_pin     db 13, 10, "Enter your account PIN : $"
    wrong_pin     db 13, 10, "***** ( Wrong PIN! Enter a correct PIN ) *****$"
    new_pin       db 13, 10, "Enter a new PIN : $" 
    enter_amount  db 13, 10, "Enter amount do you want to deposit : $"
    withdraw_amt  db 13, 10, "Enter amount do you want to withdraw : $" 
    u_name        db 13, 10, "your name is : $"
    f_name        db 13, 10, "your Father name is : $"
    
    ;arrays declare and initialize
    name_arr    db 26 dup("$")    
    father_arr  db 26 dup("$")    
    balance_arr dw 50 dup(?)     
    pin_arr     dw 50 dup(?)
    
    index dw -1      
    str_input db 26 dup("$")
    
       
.code
    main proc
        mov ax, @data
        mov ds, ax  

; ----------  Menu  ----------         
        again:
            call menu_print                ;print menu  
       
            mov ah, 1                      ; input from user
            int 21h
            mov select_option, al
            sub select_option, 30h
        
            cmp select_option, 1           ; Compare user input
            je  option_1
            
            cmp select_option, 2
            je  option_2
            
            cmp select_option, 3
            je  option_3
            
            cmp select_option, 4
            je  option_4
            
            cmp select_option, 5
            je  option_5
            
            cmp select_option, 6
            je  option_6
            
            cmp select_option, 0
            je  exit
            
            call newline
            lea dx, wrong_input
            mov ah, 9
            int 21h 
        jmp again
; ----------------------------------------------------

; ----------  1st Option  ----------         
        option_1:
            lea dx, enter_acc_no
            mov ah, 9
            int 21h
            
            mov ah, 1
            int 21h 
            mov bx, 0
            mov bl, al
            
                cmp bl, '9'
            ja skip_a 
                sub bl, 30h
            
            skip_a:
                mov cl, bl            
                and cl, 1
                cmp cl, 0
            jnz  no_even_a
            
            wrong_a:
                ;Check the account PIN
                mov dx, offset check_pin
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h 
                mov cx, 0
                mov ch, al
                sub ch, 30h 
                mov ah, 1
                int 21h
                mov cl, al
                sub cl, 30h
                
                cmp cx, pin_arr[bx]
            je  correct_a
                
                mov dx, offset wrong_pin
                mov ah, 9
                int 21h
            jmp wrong_a 
            
            ;Print Bio-data (name + father only)
            correct_a:
                mov dx, offset u_name
                mov ah, 9
                int 21h 
                
                lea dx, name_arr+2   
                mov ah, 9
                int 21h
                
                mov dx, offset f_name
                mov ah, 9
                int 21h
                
                lea dx, father_arr+2   
                mov ah, 9
                int 21h
            jmp correct
                    
            no_even_a:
                lea dx, not_fount
                mov ah, 9
                int 21h
        jmp again
; ----------------------------------------------------

; ----------  2nd Option  ----------             
        option_2:
            inc index 
            lea dx, enter_name          ;User name
            mov ah, 9
            int 21h 
             
            lea dx, name_arr
            mov ah, 10
            mov name_arr, 20
            int 21h            
                      
            lea dx, enter_father        ;User Father Name
            mov ah, 9
            int 21h
            
            lea dx, father_arr
            mov ah, 10
            mov father_arr, 20
            int 21h
            
            ; **CNIC part removed**
             
            lea dx, enter_balance       ;user deposit amount
            mov ah, 9
            int 21h  
            
            mov ah, 1
            int 21h
            mov bh, al
            sub bh, 30h
            mov ah, 1
            int 21h
            mov bl, al
            sub bl, 30h
            
            mov si, index 
            mov balance_arr[si], bx
                       
            lea dx, enter_pin           ;user enter a PIN
            mov ah, 9
            int 21h  
            
            mov ah, 1
            int 21h
            mov bh, al
            sub bh, 30h
            mov ah, 1
            int 21h
            mov bl, al
            sub bl, 30h
            
            mov si, index 
            mov pin_arr[si], bx
            
            lea dx, account_no         ;User account number
            mov ah, 9
            int 21h
            mov dx, 0
            mov dx, [index] 
            add dx, 30h
            mov ah, 2
            int 21h
            
            inc index
                                       
        jmp again
; ----------------------------------------------------
        
; ----------  3rd Option  ----------                        
        option_3:  
            lea dx, enter_acc_no
            mov ah, 9
            int 21h
            
            mov ah, 1
            int 21h 
            mov bx, 0
            mov bl, al
            
                cmp bl, '9'
            ja skip 
                sub bl, 30h
            
            skip:
                mov cl, bl            
                and cl, 1
                cmp cl, 0
            jnz  no_even
            
            wrong:
                ;Check the account PIN
                mov dx, offset check_pin
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h 
                mov cx, 0
                mov ch, al
                sub ch, 30h 
                mov ah, 1
                int 21h
                mov cl, al
                sub cl, 30h
                
                cmp cx, pin_arr[bx]
            je  correct
                
                mov dx, offset wrong_pin
                mov ah, 9
                int 21h
            jmp wrong 
            
            ;Print Current balance
            correct:
                mov dx, offset check_bal
                mov ah, 9
                int 21h
                
                mov cx, balance_arr[bx]
                mov dl, ch
                add dl, 30h
                mov ah, 2
                int 21h
                mov dl, cl
                add dl, 30h
                mov ah, 2
                int 21h
        jmp again 
            no_even:
                lea dx, not_fount
                mov ah, 9
                int 21h
        jmp again
; ----------------------------------------------------

; ----------  4th Option  ----------            
        option_4:
            lea dx, enter_acc_no
            mov ah, 9
            int 21h
            
            mov ah, 1
            int 21h 
            mov bx, 0
            mov bl, al
            
                cmp bl, '9'
            ja skip1 
                sub bl, 30h
            
            skip1:
                mov cl, bl            
                and cl, 1
                cmp cl, 0
            jnz  no_even1
            
            wrong1:
                ;Check the account PIN
                mov dx, offset check_pin
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h 
                mov cx, 0
                mov ch, al
                sub ch, 30h 
                mov ah, 1
                int 21h
                mov cl, al
                sub cl, 30h
                
                cmp cx, pin_arr[bx]
            je  correct1
                       
                mov dx, offset wrong_pin
                mov ah, 9
                int 21h
            jmp wrong1 
            
            ;change PIN
            correct1:
                mov dx, offset new_pin
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h 
                mov cx, 0
                mov ch, al
                sub ch, 30h 
                mov ah, 1
                int 21h
                mov cl, al
                sub cl, 30h
                
                xchg cx, pin_arr[bx]
        jmp again 
            no_even1:
                lea dx, not_fount
                mov ah, 9
                int 21h     
        jmp again
; ----------------------------------------------------

; ----------  5th Option  ----------
        option_5: 
            lea dx, enter_acc_no
            mov ah, 9
            int 21h
            
            mov ah, 1
            int 21h 
            mov bx, 0
            mov bl, al
            
                cmp bl, '9'
            ja skip2 
                sub bl, 30h
            
            skip2:
                mov cl, bl            
                and cl, 1
                cmp cl, 0
            jnz  no_even2
            
            wrong2:
                ;Check the account PIN
                mov dx, offset check_pin
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h 
                mov cx, 0
                mov ch, al
                sub ch, 30h 
                mov ah, 1
                int 21h
                mov cl, al
                sub cl, 30h
                
                cmp cx, pin_arr[bx]
            je  correct2
                
                mov dx, offset wrong_pin
                mov ah, 9
                int 21h
            jmp wrong2 
            
            ;Deposit amount
            correct2:
                mov dx, offset enter_amount
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h
                mov dx, 0
                mov dh, al
                sub dh, 30h
                mov ah, 1
                int 21h
                mov dl, al
                sub dl, 30h
                
                mov cx, balance_arr[bx]
                
                add cl, dl
                aaa
                add ch, dh
                aaa
                
                mov balance_arr[bx], cx      
            jmp correct                 
        jmp again 
            no_even2:
                lea dx, not_fount
                mov ah, 9
                int 21h        
        jmp again
; ----------------------------------------------------

; ----------  6th Option  ----------        
        option_6:
            lea dx, enter_acc_no
            mov ah, 9
            int 21h
            
            mov ah, 1
            int 21h 
            mov bx, 0
            mov bl, al
            
                cmp bl, '9'
            ja skip3 
                sub bl, 30h
            
            skip3:
                mov cl, bl            
                and cl, 1
                cmp cl, 0
            jnz  no_even3
            
            wrong3:
                ;Check the account PIN
                mov dx, offset check_pin
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h 
                mov cx, 0
                mov ch, al
                sub ch, 30h 
                mov ah, 1
                int 21h
                mov cl, al
                sub cl, 30h
                
                cmp cx, pin_arr[bx]
            je  correct3
                
                mov dx, offset wrong_pin
                mov ah, 9
                int 21h
            jmp wrong3 
            
            ;withdraw amount
            correct3:
                mov dx, offset withdraw_amt
                mov ah, 9
                int 21h
                
                mov ah, 1
                int 21h
                mov dx, 0
                mov dh, al
                sub dh, 30h
                mov ah, 1
                int 21h
                mov dl, al
                sub dl, 30h
                
                mov cx, balance_arr[bx]
                
                sub cl, dl
                aas
                sub ch, dh
                aas
                
                mov balance_arr[bx], cx      
            jmp correct                 
        jmp again 
            no_even3:
                lea dx, not_fount
                mov ah, 9
                int 21h 
        jmp again
; ----------------------------------------------------

; ----------  EXIT  ----------                 
        exit:
            mov ah, 4ch
            int 21h        
    main endp 
    
    ;Procedure declare & initialized
    newline proc                       ;newline Fnc
        mov dl, 13
        mov ah, 2
        int 21h
        mov dl, 10
        mov ah, 2
        int 21h 
        ret
    newline endp
    
    space proc                         ;Space Fnc
        mov dl, 20h
        mov ah, 2
        int 21h
        ret
    space endp
        
    menu_print proc                     ;menu_print Fnc
        mov dx, offset menu             
        mov ah, 9
        int 21h
        ret
    menu_print endp    
end main
ret
