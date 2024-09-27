	.arch armv8-a
	.file	"foo.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"being patched"
	.align	3
.LC1:
	.string	"Hello world %s!\n"
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
	add	x1, x0, :lo12:.LC0
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	nop
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	print_hello, .-print_hello
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
	.ident	"GCC: (GNU) 12.3.1 (openEuler 12.3.1-16.oe2309)"
	.section	.note.GNU-stack,"",@progbits
