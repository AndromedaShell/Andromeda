section .text
    bits 64

    global _start
_start:
    xor eax, eax
    mov ds, eax
    mov es, eax
    mov ss, eax
    mov rsp, 0x7c00

    mov ax, 0x55AA
    cmp word [0x7DFE], ax
    jne .error

    call clear_screen
    call print_welcome_message

    lea rsi, [message]
    mov dl, 0x80
    mov ebx, 0x0000
    mov cx, 0x0002
    mov ax, 0x0201
    int 0x13

    mov ax, 0x0013
    int 0x10

    mov ah, 0x0E
    mov bl, 0x07

.loop:
    lodsb
    cmp al, 0
    je .done
    mov bh, 0x00
    cmp byte [rsi - 1], 'W'
    je .pink_color
    mov bl, 0x07
    int 0x10
    jmp .continue

.pink_color:
    mov bl, 0xD
    int 0x10

.continue:
    jmp .loop

.done:
    call print_user_prompt
    call get_user_input

    hlt

.error:
    call clear_screen
    lea rsi, [error_message]
    jmp .loop

clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ret

print_welcome_message:
    mov si, welcome_message
    call print_string
    ret

print_user_prompt:
    mov si, prompt_message
    call print_string
    ret

print_string:
    mov ah, 0x0E
.loop_print:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .loop_print
.done_print:
    ret

get_user_input:
    mov ah, 0x00
    int 0x16
    ret

section .data
    message db 'You will soon arrive..', 0
    error_message db 'Boot sector signature error.', 0
    welcome_message db 'Welcome to Andromeda.', 0
    prompt_message db 'Press any key to continue...', 0
