global _start

BITS 32

; Christmas Pattern, Vintage Computing Christmas Challenge 2023 entry by alx/brainwave.
; This source file is under BSD 2-Clause License. You can obtain them here:
; https://github.com/alexanderbazhenoff/vc3-2023-christmas-pattern/blob/main/LICENSE

; To compile from source and run:
; nasm -f bin -o vc3_alx main.asm; chmod +x vc3_alx; ./vc3_alx

; To show total length of a binary:
; wc -c vc3_alx

; To disassemble:
; ndisasm vc3_alx -e 32 -b 32

; To hexdump:
; hd vc3_alx

; Set to 1 if you wish to compile for maximum compatibility (larger size of binary), e.g.:
; nasm -f elf32 -o vc3_alx.o main.asm; ld -m elf_i386 compatibility_mode_binary vc3_alx.o
compatibility_mode  equ     0

                    org     0x00010000
                    %if compatibility_mode == 0

                    ; tiny elf32 header (36 bytes total)
                    db      0x7f, "ELF"         ; e_ident
                    dd      1                   ; p_type
                    dd      0                   ; p_offset
                    dd      $$                  ; p_vaddr
                    dw      2                   ; e_type, p_paddr
                    dw      3                   ; e_machine
                    dd      _start              ; e_version, p_filesz
                    dd      _start              ; e_entry, p_memsz
                    dd      4                   ; e_phoff, p_flags

_start:
                    nop                         ; e_shoff, p_align, e_flags, e_ehsize
                    %endif
                    mov     si, 28 * 19         ; total number of characters to print
                    mov     bp, 6               ; number of characters to shift between figures
print_loop:
                    mov     ecx, dword 0x30020  ; e_phentsize, e_phnum (part of ELF header)
                    shr     ecx, 16
                    mov     ax, 28 * 19 - 6

segment_main_loop:
                    push    ecx
                    mov     cx, 0x42a
                    mov     dl, 27
segment_loop:
                    %if compatibility_mode != 0
                    push    ebp
                    pop     ebx
                    %endif
                    push    eax
line_main_loop:
                    mov     bl, 3
line_inner_loop:
                    cmp     eax, esi
                    jz      no_newline
                    sub     eax, edx
                    dec     bl
                    jnz     line_inner_loop
                    xor     edx, ebp
                    dec     bh                  ; wasn't set, this done by mistake and this decreased a size
                    jnz     line_main_loop
                    pop     eax
                    xor     edx, ebp
                    dec     ch
                    jnz     segment_loop
                    sub     eax, ebp
                    pop     ecx
                    loopnz  segment_main_loop
                    mov     cl, 0x20            ; ASCII code of space

                    ; processing newlines
                    mov     eax, esi
                    mov     bh, 28              ; line width

                    div     bh
                    or      ah, ah
                    jnz     no_newline
                    mov     cl, 0x0a            ; ASCII code of newline

no_newline:
                    ; print character or syscall exit
                    xor     eax, eax
                    inc     eax
                    mov     ebx, eax
                    mov     edx, eax

                    push    ecx
                    dec     si
                    jz      no_print            ; skip when si=0 to syscall exit
                    add     al, 3
                    mov     ecx, esp            ; esp now points to your character
no_print:
                    int     0x80

                    loopne     print_loop

filesize            equ     $ - $$