;----------------Application Credits----------------
;Parking Fee Management System
;COAL Lab Final Project
;Nabeel Sohail
;2021F-BCS-211
;Sec E Alpha
;Intructor: Sir Faisal Yazdani                      


;------------------------------Macros Start--------------------------

;Macro to clear screen
clrscr macro
    ;code to clear screen
    mov ah, 0h
    mov al, 06h
    mov bh, 07
    mov cx, 0
    mov dx, 184fh
    int 10h
    
    ;call macro for cusrsor
    cursor
endm

;macro to set cursor
cursor macro
    ;set cursor position at top left
    mov ah, 02h
    mov bh, 0
    mov dl, 0
    mov dh, 0
    int 10h
endm    
   
;macro to print new line
newLine macro
    mov ah, 02h
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h
endm 
                        
;macro to exit program to dos
exitToDos macro
    mov ah, 4ch
    int 21h
endm

;------------------------------Macros Ends----------------------

.model small    ;model directive

;initialize stack memory
.stack 100h

;------------------------------data segment starts--------------------------------     

;data segment, all the variables are declared here
.data

    ;general prompts
    outPromt db "Your Parking Fee is: $"
    inPrompt db "Enter the following details: $"
    appName db "Parking Fee Calculator$"
    exitPrompt db "Press any key to exit...$"
    thanksMsg db "Thank you for using the Parking Fee Calculator!$"
    continuePrompt db "Press any key to continue, Press 1 to exit the program: $"
    
    ;input data prompts
    arrivalPrompt db "Enter the arrival time (0-9): $"
    departurePrompt db "Enter the departure time (0-9): $"
    vehiclePrompt db "Enter Vehicle Number: $"
    typePrompt db "Enter Vehicle Type: $"
    
    ;output data prompts
    durationStr db "Your Total Duration: $"
    vehicleStr db "Vehicle Number: $"
    arrivalStr db "Arrival Time: $"
    departureStr db "Departure Time: $"
    feeStr db "Parking Fee: $"    
    typestr db "Vehicle Type: $"
    
    ;variables to hold input and output data
    arrivalTime dw 0
    departureTime dw 0     
    type db 32 dup('$')
    vehicleNumber db 32 dup('$')
    duration dw 0
    hourlyRate db 5 ;five dollar per hour
    parkingfee dw 0
    op db ?
    
;------------------------------data segment ends--------------------------------

          
;------------------------------code segment starts--------------------------------
.code

;------------------------------main proc start--------------------------------
app proc
    
    ;initialize data segment
    mov ax,@data
    mov ds,ax
    
    ;start label for the app
    start:
    
    ;call clear screen macro
    clrscr

    ;display app name
    call displayAppName

    ;call newline macro
    newline
    
    ;call newline macro
    newline
    
    ;call procedure for input data
    call inputData
    
    mov ah, 1
    int 21h
    
    ;call macro for clrscr
    clrscr

    ;display app name
    call displayAppName
    
    ;call newline macro
    newline
    
    ;call newline macro
    newline
    
    ;call newline macro
    newline

    ;display data
    call displayData
    
    ;call new line macro
    newline
    
    ;call new line macro
    newline
    
    ;call new line macro
    newline
    
    ;call proc for continue
    call continue
    
    ;validate exit option
    mov bl, op
    cmp bl, 1
    jnz endProgram
    jmp start
    
    endProgram:
    ;prompt thanks msg
    call thanks

    ;exit to dos macro
    exitToDos
app endp

;------------------------------main proc ends--------------------------------


;------------------------------thanks proc ends--------------------------------

thanks proc
    ;push into stack
    push ax
    push bx
    push cx
    push dx
    
    ;call new line macro
    newline
    
    ;call new line macro
    newline
    
    ;display msg
    mov ah, 9h
    lea dx, thanksMsg
    int 21h
    
    ;pop from stack
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
thanks endp                                                 

;------------------------------thanks proc ends--------------------------------


;------------------------------continue proc ends--------------------------------

continue proc
    ;push into stack
    push ax
    push bx
    push cx
    push dx
    
    ;display msg
    mov ah, 9h
    lea dx, continuePrompt
    int 21h
    
    ;read character
    mov ah, 1
    int 21h
    mov op, al
    
    ;pop from stack
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
continue endp                                                 

;------------------------------continue proc ends--------------------------------


;------------------------------display data proc start--------------------------------
                                             
displayData proc
    ;push into stack
    push ax
    push bx
    push cx
    push dx
    
    ;display vehicle number
    mov ah, 9
    lea dx, vehicleStr
    int 21h
    mov ah, 9
    lea dx, vehicleNumber+2
    int 21h

    ;call newline macro
    newline

    ;display vehicle type
    mov ah, 9
    lea dx, typestr
    int 21h
    mov ah, 9
    lea dx, type+2
    int 21h

    ;call newline macro
    newline

    ;display arrival time
    mov ah, 9
    lea dx, arrivalStr
    int 21h
    mov bx, arrivalTime
    mov ah, 2
    mov dl, bh
    int 21h
    mov dl, bl
    int 21h

    ;call newline macro
    newline

    ;display departure time
    mov ah, 9
    lea dx, departureStr
    int 21h
    mov bx, departureTime
    mov ah, 2
    mov dl, bh
    int 21h
    mov dl, bl
    int 21h

    ;call newline macro
    newline
    
    ;calculate total duration
    mov ax, departureTime
    sub ax, arrivalTime
    aas
    or ax, 3030h  
    mov duration, ax

    ;display total duration
    mov bx, duration
    mov ah, 9
    lea dx, durationStr
    int 21h
    mov ah, 2
    mov dl, bh
    int 21h
    mov dl, bl
    int 21h
    
    ;call newline macro
    newline

    ;calculate total parking fee
    mov ax, duration
    mov dl, hourlyRate
    and ax, 0f0fh
    and dl, 0fh
    mul dl
    aam
    or ax, 3030h
    mov parkingfee, ax

    ;display total parking fee
    mov bx, parkingfee
    mov ah, 9
    lea dx, feeStr
    int 21h
    mov ah, 2
    mov dl, bh
    int 21h
    mov dl, bl
    int 21h
    
    ;pop from stack
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
displayData endp

;------------------------------display data proc ends--------------------------------


;------------------------------input data proc start--------------------------------

inputData proc
    
    ;push reg into stack
    push ax
    push bx
    push cx
    push dx
    
    ;display prompt for input
    mov ah, 9
    lea dx, inPrompt
    int 21h

    newLine

    ;vehicle number
    mov ah, 9
    lea dx, vehiclePrompt
    int 21h
    mov ah, 0ah
    lea dx, vehicleNumber
    int 21h

    newLine

    ;vehicle type
    mov ah, 9
    lea dx, typePrompt
    int 21h
    mov ah, 0ah
    lea dx, type
    int 21h

    newLine

    ;input arrival time
    mov ah, 9
    lea dx, arrivalPrompt
    int 21h
    mov ah, 1
    int 21h
    mov bh, ah
    mov ah, 1
    int 21h
    mov bl, al
    mov arrivalTime, bx

    newLine

    ;input departure time
    mov ah, 9
    lea dx, departurePrompt
    int 21h
    mov ah, 1
    int 21h
    mov bh, ah
    mov ah, 1
    int 21h
    mov bl, al
    mov departureTime, bx

    newLine
    
    ;pop from stack
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
            
inputData endp

;------------------------------input data proc ends--------------------------------
                                                                              
                                                                              
;------------------------------display app name proc start--------------------------------

displayAppName proc
    
    ;push into stack
    push ax
    push bx
    push cx
    push dx
    
    ;dislay app name
    mov ah, 09h
    lea dx, appName
    int 21h
    
    ;pop values from stack
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
displayAppName endp
                                                                              
;------------------------------display app name proc ends--------------------------------
                                                                              
end app

;------------------------------------end of code-------------------------------------