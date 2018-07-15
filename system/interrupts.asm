; Night Kernel
; Copyright 1995 - 2018 by mercury0x000d
; interrupts.asm is a part of the Night Kernel

; The Night Kernel is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
; version.

; The Night Kernel is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License along with the Night Kernel. If not, see
; <http://www.gnu.org/licenses/>.

; See the included file <GPL License.txt> for the complete text of the GPL License by which this program is covered.



; 32-bit function listing:
; IDTInit						Initializes the kernel IDT
; InterruptHandlerSet			Formats the passed data and writes it to the IDT in the slot specified
; InterruptUnimplemented		A generic handler to run when an unimplemented interrupt is called
; ISRInitAll					Sets the interrupt handler addresses into the IDT



bits 32



IDTInit:
	; Initializes the kernel IDT
	;
	;  input:
	;   n/a
	;
	;  output:
	;   n/a


	push ebp
	mov ebp, esp

	; allocate 64 KiB for the IDT
	push dword 65536
	call MemAllocate
	pop eax
	mov dword [kIDTPtr], eax

	; set the proper value into the IDT struct
	mov dword [tIDT.base], eax

	; set all the handler slots to the "unsupported routine" handler for sanity
	mov ecx, 0x00000100
	setupOneVector:
		; preserve our counter
		push ecx

		; map the interrupt
		push 0x8e
		push InterruptUnimplemented
		push 0x08
		push ecx
		call InterruptHandlerSet

		; restore our counter
		pop ecx
	loop setupOneVector

	; activate that IDT!
	lidt [tIDT]

	mov esp, ebp
	pop ebp
ret

tIDT:
.limit											dw 2047
.base											dd 0x00000000



InterruptHandlerSet:
	; Formats the passed data and writes it to the IDT in the slot specified
	;
	;  input:
	;   IDT index
	;   ISR selector
	;   ISR base address
	;   flags
	;
	;  output:
	;   n/a

	; save return address
	pop esi

	pop ebx										; get destination IDT index
	mov eax, 8									; calc the destination offset into the IDT
	mul ebx
	mov edi, [kIDTPtr]							; get IDT's base address
	add edi, eax								; calc the actual write address

	pop ebx										; get ISR selector

	pop ecx										; get ISR base address

	mov eax, 0x0000FFFF
	and eax, ecx								; get low word of base address in eax
	mov word [edi], ax							; write low word
	add edi, 2									; adjust the destination pointer

	mov word [edi], bx							; write selector
	add edi, 2									; adjust the destination pointer again

	mov al, 0x00
	mov byte [edi], al							; write null (reserved byte)
	inc edi										; adjust the destination pointer again

	pop edx										; get the flags
	mov byte [edi], dl							; and write those flags!
	inc edi										; guess what we're doing here :D

	shr ecx, 16									; shift base address right 16 bits to
												; get high word in position
	mov eax, 0x0000FFFF
	and eax, ecx								; get high word of base address in eax
	mov word [edi], ax							; write high word

	push esi									; restore ret address
ret



InterruptUnimplemented:
	; A generic handler to run when an unimplemented interrupt is called
	;
	;  input:
	;   n/a
	;
	;  output:
	;   n/a

	push ebp
	mov ebp, esp

	pusha
	jmp $ ; for debugging, makes sure the system hangs upon exception
	push kUnsupportedInt$
	call PrintRegs32
	call PICIntComplete
	popa

	mov esp, ebp
	pop ebp
iretd



ISRInitAll:
	; Sets all the kernel interrupt handler addresses into the IDT
	;
	;  input:
	;   n/a
	;
	;  output:
	;   n/a

	push ebp
	mov ebp, esp

	push 0x8e
	push ISR00
	push 0x08
	push 0x00
	call InterruptHandlerSet

	push 0x8e
	push ISR01
	push 0x08
	push 0x01
	call InterruptHandlerSet

	push 0x8e
	push ISR02
	push 0x08
	push 0x02
	call InterruptHandlerSet

	push 0x8e
	push ISR03
	push 0x08
	push 0x03
	call InterruptHandlerSet

	push 0x8e
	push ISR04
	push 0x08
	push 0x04
	call InterruptHandlerSet

	push 0x8e
	push ISR05
	push 0x08
	push 0x05
	call InterruptHandlerSet

	push 0x8e
	push ISR06
	push 0x08
	push 0x06
	call InterruptHandlerSet

	push 0x8e
	push ISR07
	push 0x08
	push 0x07
	call InterruptHandlerSet

	push 0x8e
	push ISR08
	push 0x08
	push 0x08
	call InterruptHandlerSet

	push 0x8e
	push ISR09
	push 0x08
	push 0x09
	call InterruptHandlerSet

	push 0x8e
	push ISR0A
	push 0x08
	push 0x0A
	call InterruptHandlerSet

	push 0x8e
	push ISR0B
	push 0x08
	push 0x0B
	call InterruptHandlerSet

	push 0x8e
	push ISR0C
	push 0x08
	push 0x0C
	call InterruptHandlerSet

	push 0x8e
	push ISR0D
	push 0x08
	push 0x0D
	call InterruptHandlerSet

	push 0x8e
	push ISR0E
	push 0x08
	push 0x0E
	call InterruptHandlerSet

	push 0x8e
	push ISR0F
	push 0x08
	push 0x0F
	call InterruptHandlerSet

	push 0x8e
	push ISR10
	push 0x08
	push 0x10
	call InterruptHandlerSet

	push 0x8e
	push ISR11
	push 0x08
	push 0x11
	call InterruptHandlerSet

	push 0x8e
	push ISR12
	push 0x08
	push 0x12
	call InterruptHandlerSet

	push 0x8e
	push ISR13
	push 0x08
	push 0x13
	call InterruptHandlerSet

	push 0x8e
	push ISR14
	push 0x08
	push 0x14
	call InterruptHandlerSet

	push 0x8e
	push ISR15
	push 0x08
	push 0x15
	call InterruptHandlerSet

	push 0x8e
	push ISR16
	push 0x08
	push 0x16
	call InterruptHandlerSet

	push 0x8e
	push ISR17
	push 0x08
	push 0x17
	call InterruptHandlerSet

	push 0x8e
	push ISR18
	push 0x08
	push 0x18
	call InterruptHandlerSet

	push 0x8e
	push ISR19
	push 0x08
	push 0x19
	call InterruptHandlerSet

	push 0x8e
	push ISR1A
	push 0x08
	push 0x1A
	call InterruptHandlerSet

	push 0x8e
	push ISR1B
	push 0x08
	push 0x1B
	call InterruptHandlerSet

	push 0x8e
	push ISR1C
	push 0x08
	push 0x1C
	call InterruptHandlerSet

	push 0x8e
	push ISR1D
	push 0x08
	push 0x1D
	call InterruptHandlerSet

	push 0x8e
	push ISR1E
	push 0x08
	push 0x1E
	call InterruptHandlerSet

	push 0x8e
	push ISR1F
	push 0x08
	push 0x1F
	call InterruptHandlerSet

	push 0x8e
	push ISR20
	push 0x08
	push 0x20
	call InterruptHandlerSet

	push 0x8e
	push ISR21
	push 0x08
	push 0x21
	call InterruptHandlerSet

	push 0x8e
	push ISR22
	push 0x08
	push 0x22
	call InterruptHandlerSet

	push 0x8e
	push ISR23
	push 0x08
	push 0x23
	call InterruptHandlerSet

	push 0x8e
	push ISR24
	push 0x08
	push 0x24
	call InterruptHandlerSet

	push 0x8e
	push ISR25
	push 0x08
	push 0x25
	call InterruptHandlerSet

	push 0x8e
	push ISR26
	push 0x08
	push 0x26
	call InterruptHandlerSet

	push 0x8e
	push ISR27
	push 0x08
	push 0x27
	call InterruptHandlerSet

	push 0x8e
	push ISR28
	push 0x08
	push 0x28
	call InterruptHandlerSet

	push 0x8e
	push ISR29
	push 0x08
	push 0x29
	call InterruptHandlerSet

	push 0x8e
	push ISR2A
	push 0x08
	push 0x2A
	call InterruptHandlerSet

	push 0x8e
	push ISR2B
	push 0x08
	push 0x2B
	call InterruptHandlerSet

	push 0x8e
	push ISR2C
	push 0x08
	push 0x2C
	call InterruptHandlerSet

	push 0x8e
	push ISR2D
	push 0x08
	push 0x2D
	call InterruptHandlerSet

	push 0x8e
	push ISR2E
	push 0x08
	push 0x2E
	call InterruptHandlerSet

	push 0x8e
	push ISR2F
	push 0x08
	push 0x2F
	call InterruptHandlerSet

	mov esp, ebp
	pop ebp
ret



ISR00:
	; Divide by Zero Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000000
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR01:
	; Debug Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000001
	pop esi
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR02:
	push ebp
	mov ebp, esp

	; Nonmaskable Interrupt Exception
	pusha
	pushf
	mov edx, 0x00000002
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR03:
	; Breakpoint Exception
	; get the location of the bad instruction off the stack
	push ebp
	mov ebp, esp

	pop dword [exceptionAddress]
	pop dword [exceptionSelector]
	dec dword [exceptionAddress]
	pusha
	push dword [exceptionAddress]
	push dword [exceptionSelector]
	push kPrintText$
	push .format$
	call StringBuild

	; print the string we just built
	mov byte [textColor], 14
	mov byte [backColor], 7
	push kPrintText$
	call Print16

	push 1
	push dword [exceptionAddress]
	call PrintRAM32

	; print the error message
	call PICIntComplete

	; restore the registers and dump thm to screen
	popa
	call PrintRegs32

	; restore the return address
	inc dword [exceptionAddress]
	push dword [exceptionSelector]
	push dword [exceptionAddress]	

	mov esp, ebp
	pop ebp
iretd
.format$										db ' Breakpoint at ^p4^h:^p8^h ', 0x00



ISR04:
	; Overflow Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000004
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR05:
	; Bound Range Exceeded Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000005
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR06:
	; Invalid Opcode Exception
	push ebp
	mov ebp, esp

	; get the location of the bad instruction off the stack
	pop dword [exceptionAddress]
	pop dword [exceptionSelector]
	pusha
	push dword [exceptionAddress]
	push dword [exceptionSelector]
	push kPrintText$
	push .format$
	call StringBuild

	; print the string we just built
	mov byte [textColor], 4
	mov byte [backColor], 7
	push kPrintText$
	call Print32

	push 1
	push dword [exceptionAddress]
	call PrintRAM32

	; print the error message
	call PICIntComplete

	; dump the registers
	popa
	call PrintRegs32

	jmp $ ; for debugging, makes sure the system hangs upon exception

	mov esp, ebp
	pop ebp
iretd
.format$										db ' Invalid Opcode at ^p4^h:^p8^h ', 0x00



ISR07:
	push ebp
	mov ebp, esp

	; Device Not Available Exception
	pusha
	pushf
	mov edx, 0x00000007
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR08:
	push ebp
	mov ebp, esp

	; Double Fault Exception
	pusha
	pushf
	mov edx, 0x00000008
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR09:
	push ebp
	mov ebp, esp

	; Former Coprocessor Segment Overrun Exception
	pusha
	pushf
	mov edx, 0x00000009
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR0A:
	; Invalid TSS Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000000A
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR0B:
	; Segment Not Present Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000000B
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR0C:
	; Stack Segment Fault Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000000C
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR0D:
	; General Protection Fault
	; get the location of the bad instruction off the stack
	push ebp
	mov ebp, esp

	pop dword [exceptionAddress]
	pusha
	push dword [exceptionAddress]
	push kPrintText$
	push .format$
	call StringBuild

	; print the string we just built
	mov byte [textColor], 4
	mov byte [backColor], 7
	push kPrintText$
	call Print32

	push 1
	push dword [exceptionAddress]
	call PrintRAM32

	; print the error message
	call PICIntComplete

	; dump the registers
	popa
	call PrintRegs32

	jmp $ ; for debugging, makes sure the system hangs upon exception

	mov esp, ebp
	pop ebp
iretd
.format$										db ' General protection fault at ^p8^h ', 0x00



ISR0E:
	; Page Fault Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000000E
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR0F:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000000F
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR10:
	; x86 Floating Point Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000010
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR11:
	; Alignment Check Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000011
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR12:
	; Machine Check Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000012
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR13:
	; SIMD Floating Point Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000013
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR14:
	; Virtualization Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000014
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR15:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000015
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR16:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000016
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR17:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000017
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR18:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000018
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR19:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000019
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR1A:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000001A
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR1B:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000001B
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR1C:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000001C
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR1D:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000001D
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR1E:
	; Security Exception
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000001E
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR1F:
	; Reserved
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000001F
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR20:
	; Programmable Interrupt Timer (PIT)
	push ebp
	mov ebp, esp

	pusha
	pushf
	inc dword [tSystem.ticksSinceBoot]
	inc byte [tSystem.ticks]
	cmp byte [tSystem.ticks], 0
	jne .done
	inc dword [tSystem.secondsSinceBoot]
	inc byte [tSystem.seconds]
	cmp byte [tSystem.seconds], 60
	jne .done
	mov byte [tSystem.seconds], 0
	inc byte [tSystem.minutes]
	cmp byte [tSystem.minutes], 60
	jne .done
	mov byte [tSystem.minutes], 0
	inc byte [tSystem.hours]
	cmp byte [tSystem.hours], 24
	jne .done
	mov byte [tSystem.hours], 0
	inc byte [tSystem.day]
	cmp byte [tSystem.day], 30				; this will need modified to account for the different number of days in the months
	jne .done
	mov byte [tSystem.day], 0
	inc byte [tSystem.month]
	cmp byte [tSystem.month], 13
	jne .done
	mov byte [tSystem.month], 1
	inc byte [tSystem.year]
	cmp byte [tSystem.year], 100
	jne .done
	mov byte [tSystem.year], 0
	inc byte [tSystem.century]
	.done:
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR21:
	; Keyboard
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov eax, 0x00000000
	in al, 0x60

	; skip if this isn't a key down event
	cmp al, 0x80
	ja .done

	; load the buffer position
	mov esi, kKeyBuffer
	mov edx, 0x00000000
	mov dl, [kKeyBufferWrite]
	add esi, edx

	; get the letter or symbol associated with this key code
	mov ebx, kKeyTable
	add ebx, eax
	mov cl, [ebx]

	; add the letter or symbol to the key buffer
	mov byte [esi], cl

	; if the buffer isn't full, adjust the buffer pointer
	mov dh, [kKeyBufferRead]
	inc dl
	cmp dl, dh
	jne .incrementCounter

	.done:
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd
.incrementCounter:
 mov [kKeyBufferWrite], dl
jmp .done



ISR22:
	; Cascade - used internally by the PICs, should never fire
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000022
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR23:
	; Serial port 2
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000023
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR24:
	; Serial port 1
	push ebp
	mov ebp, esp

	pusha
	pushf
	;push 1
	;call SerialGetIIR
	;pop edx
	;pop ecx
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR25:
	; Parallel port 2
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000025
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR26:
	; Floppy disk
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000026
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR27:
	; Parallel port 1 - prone to misfire
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000027
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR28:
	; CMOS real time clock
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000028
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR29:
	; Free for peripherals / legacy SCSI / NIC
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x00000029
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR2A:
	; Free for peripherals / SCSI / NIC
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000002A
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR2B:
	; Free for peripherals / SCSI / NIC
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000002B
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR2C:
	; PS/2 Mouse
	push ebp
	mov ebp, esp

	pusha
	pushf

	mov eax, 0x00000000
	in al, 0x60

	; add this byte to the mouse packet
	mov ebx, tSystem.mousePacketByte1
	mov ecx, 0x00000000
	mov cl, [tSystem.mousePacketByteCount]
	mov dl, [tSystem.mousePacketByteSize]
	add ebx, ecx
	mov byte [ebx], al

	; see if we have a full set of bytes, skip to the end if not
	inc cl
	cmp cl, dl
	jne .done

	; if we get here, we have a whole packet
	mov byte [tSystem.mousePacketByteCount], 0xFF

	mov edx, 0x00000000
	mov byte dl, [tSystem.mousePacketByte1]

	; save edx, mask off the three main mouse buttons, restore edx
	push edx
	and dl, 00000111b
	mov byte [tSystem.mouseButtons], dl
	pop edx

	; process the X axis
	mov eax, 0x00000000
	mov ebx, 0x00000000
	mov byte al, [tSystem.mousePacketByte2]
	mov word bx, [tSystem.mouseX]
	push edx
	and dl, 00010000b
	cmp dl, 00010000b
	pop edx
	jne .mouseXPositive
	; movement was negative
	neg al
	sub ebx, eax
	; see if the mouse position would be beyond the left side of the screen, correct if necessary
	cmp ebx, 0x0000FFFF
	ja .mouseXNegativeAdjust
	jmp .mouseXDone
	.mouseXPositive:
	; movement was positive
	add ebx, eax
	; see if the mouse position would be beyond the right side of the screen, correct if necessary
	mov ax, [tSystem.mouseXLimit]
	cmp ebx, eax
	jae .mouseXPositiveAdjust
	.mouseXDone:
	mov word [tSystem.mouseX], bx

	; process the Y axis
	mov eax, 0x00000000
	mov ebx, 0x00000000
	mov byte al, [tSystem.mousePacketByte3]
	mov word bx, [tSystem.mouseY]
	and dl, 00100000b
	cmp dl, 00100000b
	jne .mouseYPositive
	; movement was negative (but we add to counteract the mouse's cartesian coordinate system)
	neg al
	add ebx, eax
	; see if the mouse position would be beyond the bottom of the screen, correct if necessary
	mov ax, [tSystem.mouseYLimit]
	cmp ebx, eax
	jae .mouseYPositiveAdjust
	jmp .mouseYDone
	.mouseYPositive:
	; movement was positive (but we subtract to counteract the mouse's cartesian coordinate system)
	sub ebx, eax
	; see if the mouse position would be beyond the top of the screen, correct if necessary
	cmp ebx, 0x0000FFFF
	ja .mouseYNegativeAdjust
	.mouseYDone:
	mov word [tSystem.mouseY], bx

	; see if we're using a FancyMouse(TM) and act accordingly
	mov byte al, [tSystem.mouseID]
	cmp al, 0x03
	jne .done
	; if we get here, we need have a wheel and need to process the Z axis
	mov eax, 0x00000000
	mov byte al, [tSystem.mousePacketByte4]
	mov word bx, [tSystem.mouseZ]
	mov cl, 0xF0
	and cl, al
	cmp cl, 0xF0
	jne .mouseZPositive
	; movement was negative
	neg al
	and al, 0x0F
	sub bx, ax
	jmp .mouseZDone
	.mouseZPositive:
	; movement was positive
	add bx, ax
	.mouseZDone:
	mov word [tSystem.mouseZ], bx

	.done:
	inc byte [tSystem.mousePacketByteCount]
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd

.mouseXNegativeAdjust:
	mov bx, 0x00000000
jmp .mouseXDone

.mouseXPositiveAdjust:
	mov word bx, [tSystem.mouseXLimit]
	dec bx
jmp .mouseXDone

.mouseYNegativeAdjust:
	mov bx, 0x00000000
jmp .mouseYDone

.mouseYPositiveAdjust:
	mov word bx, [tSystem.mouseYLimit]
	dec bx
jmp .mouseYDone



ISR2D:
	; FPU / Coprocessor / Inter-processor
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000002D
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR2E:
	; Primary ATA Hard Disk
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000002E
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



ISR2F:
	; Secondary ATA Hard Disk
	push ebp
	mov ebp, esp

	pusha
	pushf
	mov edx, 0x0000002F
	jmp $ ; for debugging, makes sure the system hangs upon exception
	call PICIntComplete
	popf
	popa

	mov esp, ebp
	pop ebp
iretd



kUnsupportedInt$								db 'An unsupported interrupt has been called', 0x00
exceptionSelector								dd 0x00000000
exceptionAddress								dd 0x00000000
kIDTPtr											dd 0x00000000