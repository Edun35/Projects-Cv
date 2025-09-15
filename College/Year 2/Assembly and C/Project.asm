;-----------------------------------------------------------------------
; Title:        Project
; Written by:   Evan Dunphy
; Date:         24-04-2025
; Description:  3 Loops. User enters 2 numbers to add. 7 digits max. 
;               Then display sum. Display final sum after the 3 loops.
;----------------------------------------------------------------------

;Vars for messages
section .data
	entermsg:       db 'Enter number: '    
	entermsgLen:    equ $-entermsg           
	summsg:         db 'The sum is: '  
	summsgLen:      equ $-summsg           	
	finalmsg:       db 'Final sum is: '
	finalmsgLen:    equ $-finalmsg

    startmsg:       db '3 Loops. Enter 2 numbers to add. 7 digits max. Display sum. Display final sum after loops.',0x0A
    startmsgLen:    equ $-startmsg

    invalidmsg:       db 'Invalid entry. Exiting.'
    invalidmsgLen:    equ $-invalidmsg

;Empty spaces for input and conversion
section .bss
    input resb 16     ; Reserve bits for input
    num resb  16  
    final resb 8

;Start the Program
section .text
	global _start

_start:
    mov qword [final], 0    ;set final to 0
    call _displaystart
    mov r10, 4              ;set counter
    ;enter loop

;main loop 
_loopnum:
    call _displaynum    ;display prompt
    call _getinput      ;get input
    mov  r9, [input]    ;put input in register
    
    ;repeat above with different register
    call _displaynum
    call _getinput
    mov  r8, [input]

    ;register adder 
    add  r9, r8
    add [final], r9     ;add sum to final sum
  
    call _displaysum    ;display the sum

    dec r10             ;decrement the loop counter
    mov rcx, r10
    loop _loopnum       ;loop

    ;exit loop
    call _displayfinal  ;display final and exit program

;messages to display
_displaystart:              ;user instructions
	mov rax,1               ;sys_write
	mov rdi,1               ;stdout
	mov rsi,startmsg        ;msg
	mov rdx,startmsgLen     ;msg length
    syscall
    ret

_displayinvalid:            ;invalid entry
    mov rax,1               ;sys_write
    mov rdi,1               ;stdout
    mov rsi,invalidmsg      ;msg
    mov rdx,invalidmsgLen   ;msg length
    syscall
    ret

_displaynum:                ;display enter number prompt
	mov rax,1               ;sys_write
	mov rdi,1               ;stdout
	mov rsi,entermsg        ;msg
	mov rdx,entermsgLen     ;msg length
    syscall
    ret

_displaysum:                ;display sum message and sum
	mov rax,1               ;sys_write
	mov rdi,1               ;stdout
	mov rsi,summsg          ;msg
	mov rdx,summsgLen       ;msg length
    syscall    
    
    ;set up for convert sum integer to string
    mov rax, r9
    mov rbx, 10
    lea rdi, [num + 15]
    mov byte [rdi], 0xA 
    dec rdi    
    ;convert sum integer to string
    call _contostr
    ret

_displayfinal:              ;display final message and final sum
	mov rax,1               ;sys_write
	mov rdi,1               ;stdout
	mov rsi,finalmsg        ;msg
	mov rdx,finalmsgLen     ;msg length
	syscall   
    
    ;set up for convert final sum integer to string
    mov rax, [final]
    mov rbx, 10
    lea rdi, [num + 15]
    mov byte [rdi], 0xA 
    dec rdi
    ;convert final sum integer to string
    call _contostr
    ; Exit program
    call _exit

;Read input
_getinput:
    mov rax, 0              ;sys_read
    mov rdi, 0              ;stdin
    lea rsi, [input]        ;where to store input
    mov rdx, 8              ;max bytes 
    syscall

    ;clear registers and prep to convert string into integer
    xor rax, rax
    xor rcx, rcx
    lea r8, [input]    

    ;convert string to integer
    call _contoint
    ret


;convert to int
_contoint:
    movzx rbx, byte [r8]
    cmp bl, 0x0A            ;newline character
    je _done
    imul rax,rax, 10
    sub rbx, '0'
    ;security check
    ;check if not a number
    cmp rbx, 9
    jg _invalid
    cmp rbx, 0
    jl _invalid

    ;add converted int to register 
    add rax, rbx
    inc r8
    jmp _contoint

_done:                      ;conversion finished
    mov [input], rax
    ret

_contostr:                  ;convert integer to string
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz _contostr
    lea rsi, [rdi + 1]

    ; Write result to console
    mov rax, 1
    mov rdi, 1
    lea rdx, [num + 16]
    sub rdx, rsi
    syscall
    ret

_invalid:                   ;invalid input 
    call _displayinvalid
    call _exit

_exit:                      ;exit program
    mov rax, 60              ;sys_exit
    xor rdi, rdi
    syscall 