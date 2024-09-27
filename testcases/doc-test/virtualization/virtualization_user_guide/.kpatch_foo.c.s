	.arch armv8-a
	.file	"foo.c"
#---------- var ---------
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"Hello world!"
#---------- func ---------
	.text
	.align	2
	.global	print_hello
	.type	print_hello, %function
print_hello:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts
	nop
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	print_hello, .-print_hello
print_hello.Lfe:
#---------- kpatch begin ---------
	.pushsection .kpatch.text,"ax",@progbits
	.align	2
	.global	print_hello.kpatch
	.type	print_hello.kpatch, %function
print_hello.kpatch:
.LFB0.kpatch:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	adrp	x0, .LC0.kpatch
	add	x1, x0, :lo12:.LC0.kpatch
	adrp	x0, .LC1.kpatch
	add	x0, x0, :lo12:.LC1.kpatch
	bl	printf
	nop
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0.kpatch:
	.size	print_hello.kpatch, .-print_hello.kpatch
print_hello.kpatch_end:
	.popsection

	.pushsection .kpatch.strtab,"a",@progbits
kpatch_strtab1:
	.string "print_hello.kpatch"
	.popsection
	.pushsection .kpatch.info,"a",@progbits
print_hello.Lpi:
	.quad print_hello
	.quad print_hello.kpatch
	.long print_hello.Lfe - print_hello
	.long print_hello.kpatch_end - print_hello.kpatch
	.quad kpatch_strtab1
	.quad 0
	.long 0
	.byte 0, 0, 0, 0
	.popsection

#---------- kpatch end -----------
#---------- func ---------
	.align	2
	.global	main
	.type	main, %function
main:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
.L3:
	bl	print_hello
	mov	w0, 1
	bl	sleep
	b	.L3
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.pushsection .kpatch.text,"ax",@progbits
	.section .kpatch.data,"aw",@progbits
	.p2align	12
	.align	3
.LC0.kpatch:
	.string	"being patched"
	.popsection
	.pushsection .kpatch.data,"aw",@progbits
	.align	3
.LC1.kpatch:
	.string	"Hello world %s!\n"
	.popsection
	.ident	"GCC: (GNU) 12.3.1 (openEuler 12.3.1-16.oe2309)"
	.section	.note.GNU-stack,"",@progbits
