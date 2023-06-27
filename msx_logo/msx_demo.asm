; --------------------------------------------------------------------
;	MSX LOGO DEMO
; ====================================================================
;	2023/June/25th t.hara (HRA!)
; --------------------------------------------------------------------

			org			0x4000

vdp_port0		:= 0x98
vdp_port1		:= 0x99
vdp_port2		:= 0x9A
vdp_port3		:= 0x9B
ppi_slot_sel	:= 0xA8

enaslt			:= 0x0024

filvrm			:= 0x0056				; vram_memset( HL, A, BC )
chgmod			:= 0x005F				; SCREEN A
ldirvm			:= 0x005C				; CPU RAM �� VRAM �]��

forclr			:= 0xF3E9				; �O�i�F
bakclr			:= 0xF3EA				; �w�i�F
bdrclr			:= 0xF3EB				; ���ӐF

rg1sav			:= 0xF3E0				; VDP R#1
rg8sav			:= 0xFFE7				; VDP R#8
rg9sav			:= 0xFFE8				; VDP R#9

exptbl			:= 0xFCC1
slttbl			:= 0xFCC5

h_keyi			:= 0xFD9A				; �S���荞�݂̃t�b�N

			ds			"AB"
			dw			entry
			dw			0
			dw			0
			dw			0
			dw			0
			dw			0
			dw			0

; --------------------------------------------------------------------
;	entry point
; --------------------------------------------------------------------
			scope		entry
entry::
			; �X���b�g��������
			call		init_slot
			; COLOR 15,4,4:SCREEN 5
			ld			hl, (4 << 8) | 15
			ld			[forclr], hl
			ld			a, h
			ld			[bdrclr], a
			ld			a, 5
			call		chgmod
			; �J���[�p���b�g������
			ld			hl, initial_palette
			call		set_palette
			; �摜�f�[�^�]��
			ld			hl, hmmc_msx_logo
			ld			bc, 208 / 2 * 64
			call		vdp_command_hmmc
			; �X�v���C�g 16x16, 2�{�p
			di
			ld			a, [rg1sav]
			or			a, 0b0000_0011			; 16x16, 2�{
			out			[vdp_port1], a
			ld			a, 0x80 | 1
			out			[vdp_port1], a
			; 192���C�����[�h
			ld			a, [rg9sav]
			and			a, 0b0111_1111			; 192���C�����[�h
			out			[vdp_port1], a
			ld			a, 0x80 | 9
			out			[vdp_port1], a
			; �X�v���C�g�����ɂ��� ( 4x32 )
			ld			hl, 0x7800				; �X�v���C�g�p�^�[���W�F�l���[�^�e�[�u��
			ld			a, 0xC0
			ld			bc, 16
			call		filvrm
			ld			hl, 0x7810				; �X�v���C�g�p�^�[���W�F�l���[�^�e�[�u��
			ld			a, 0x00
			ld			bc, 16
			call		filvrm
			; �X�v���C�g��w�i�Ɠ����F�ɂ���
			ld			hl, 0x7400				; �X�v���C�g�J���[�e�[�u��
			ld			a, 0x04
			ld			bc, 512
			call		filvrm
			; �X�v���C�g���\���ɂ���
			ld			hl, 0x7600				; �X�v���C�g�A�g���r���[�g�e�[�u��
			ld			a, 216
			ld			bc, 128
			call		filvrm
			; �ꕔ�̃X�v���C�g��\������
			ld			hl, sprite_attribute
			ld			de, 0x7600
			ld			bc, sprite_attribute_end - sprite_attribute
			call		ldirvm
			; scroll_data_ptr ��������
			ld			hl, scroll_data
			ld			[scroll_data_ptr], hl
			; H.KEYI�t�b�N
			di
			ld			a, 0xC3					; JP
			ld			[h_keyi], a
			ld			hl, h_keyi_routine
			ld			[h_keyi + 1], hl
			ei
			; �҂�
		wait_loop:
			halt
			jp			wait_loop
			endscope

; -----------------------------------------------------------------------------
;	Initialize slot selector
;	input:
;		none
;	output:
;		none
;	description:
;		DI��ԂŖ߂�
; -----------------------------------------------------------------------------
		scope		init_slot
init_slot::
		; page1 �̃X���b�g�𒲂ׂ�
		in			a, [ ppi_slot_sel ]
		rrca
		rrca
		and			a, 3
		push		af
		; ���̃X���b�g���g���X���b�g���ǂ������ׂ�
		add			a, exptbl & 255
		ld			l, a
		ld			h, exptbl >> 8
		ld			a, [hl]
		and			a, 0x80
		jr			z, basic_slot

		; �J�[�g���b�W����������Ă���̂��g���X���b�g�������ꍇ
		inc			hl
		inc			hl
		inc			hl
		inc			hl
		ld			a, [hl]				; A = SLTTBL[ �^�[�Q�b�g�X���b�g ]
		and			a, 0x0C0
		ld			b, a
		pop			af
		or			a, b
		or			a, 0x80
		jr			exit

		; �J�[�g���b�W����������Ă���̂���{�X���b�g�������ꍇ
basic_slot:
		pop			af
exit:
		ld			[rom_slot], a
		ld			h, 0x80
		jp			enaslt					; �X���b�g�؂�ւ���ɂ��̂܂ܖ߂�
		endscope

; --------------------------------------------------------------------
;	���荞�ݏ���
; --------------------------------------------------------------------
			scope		h_keyi_routine
h_keyi_routine::
			; S#0 �𒲂ׂ�
			ld			c, vdp_port1
			in			a, [c]
			or			a, a				; �����������Ԃ����ׂ�
			ret			p					; ����Ă�Ζ߂�BS#0 �ǂ񂾂̂� H.TIMI�͌Ă΂�Ȃ��Ȃ�
			; �X�N���[�������̏�����
			ld			hl, [scroll_data_ptr]
			ld			b, 0
			; �X�N���[������
	wait_hsync:
			in			a, [c]
			and			a, 0b0010_0000
			jp			z, wait_hsync
			outi
			outi
			jp			nz, wait_hsync
			; ���̃X�N���[���ɑJ��
			ld			[scroll_data_ptr], hl
			ld			a, h
			cp			a, scroll_data_end >> 8
			ret			c
			ld			hl, scroll_data
			ld			[scroll_data_ptr], hl
			ret
			endscope

; --------------------------------------------------------------------
;	�p���b�g�ύX
;		HL ... �p���b�g�f�[�^�̃A�h���X
; --------------------------------------------------------------------
			scope		set_palette
set_palette::
			xor			a, a
			di
			out			[vdp_port1], a
			ld			a, 0x80 | 16
			out			[vdp_port1], a		; VDP R#16 = 0 (palette index)
			ei
			ld			bc, (32 << 8) | vdp_port2
			otir
			ret
			endscope

; --------------------------------------------------------------------
;	VDP Command HMMC
;	HL ..... ���W�f�[�^,�]���f�[�^�̃A�h���X
;	BC ..... �]���f�[�^��
; --------------------------------------------------------------------
			scope		vdp_command_hmmc
vdp_command_hmmc::
			push		bc
			ld			e, l
			ld			d, h
			ld			bc, 10
			add			hl, bc
			ex			de, hl

			; VDP R#17 = R#36 (�I�[�g�C���N�������g)
			di
			ld			a, 0x00 | 36
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a
			ld			c, vdp_port3

			ld			a, [de]
			inc			de
			outi							; R#36
			outi							; R#37
			outi							; R#38
			outi							; R#39
			outi							; R#40
			outi							; R#41
			outi							; R#42
			outi							; R#43
			out			[c], a				; R#44
			outi							; R#45
			outi							; R#46

			; VDP R#17 = R#44 (��I�[�g�C���N�������g)
			ld			a, 0x80 | 44
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a

			ex			de, hl
			pop			de
			dec			de

		loop:
			dec			de
			ld			a, e
			outi
			or			a, d
			jr			nz, loop
			ei
			ret
			endscope

; --------------------------------------------------------------------
;	palette data
; --------------------------------------------------------------------
palette		macro		vr, vg, vb
			db			(vr << 4) | vb
			db			vg
			endm

initial_palette:
			palette		0, 0, 0			; #0
			palette		0, 0, 0			; #1
			palette		1, 6, 1			; #2
			palette		3, 7, 3			; #3
			palette		0, 2, 7			; #4
			palette		2, 3, 7			; #5
			palette		5, 1, 1			; #6
			palette		2, 6, 7			; #7
			palette		7, 1, 1			; #8
			palette		7, 3, 3			; #9
			palette		6, 6, 1			; #10
			palette		6, 6, 3			; #11
			palette		1, 4, 1			; #12
			palette		3, 3, 3			; #13
			palette		5, 5, 5			; #14
			palette		7, 7, 7			; #15

; --------------------------------------------------------------------
;	�X�v���C�g�A�g���r���[�g
; --------------------------------------------------------------------
sprite_attribute::	;	  Y, X, Pat, N/A
			db			  0, 0,   0,   0	; #0
			db			  0, 0,   0,   0	; #1
			db			 32, 0,   0,   0	; #2
			db			 32, 0,   0,   0	; #3
			db			 64, 0,   0,   0	; #4
			db			 64, 0,   0,   0	; #5
			db			 96, 0,   0,   0	; #6
			db			 96, 0,   0,   0	; #7
			db			128, 0,   0,   0	; #8
			db			128, 0,   0,   0	; #9
			db			160, 0,   0,   0	; #10
			db			160, 0,   0,   0	; #11
			db			192, 0,   0,   0	; #12
			db			192, 0,   0,   0	; #13
			db			224, 0,   0,   0	; #14
			db			224, 0,   0,   0	; #15
sprite_attribute_end::

; --------------------------------------------------------------------
;	�X�N���[���f�[�^
; --------------------------------------------------------------------
			align		256
scroll_data::
			include		"mkreg/parts_000.asm"
			include		"mkreg/parts_001.asm"
			include		"mkreg/parts_002.asm"
			include		"mkreg/parts_003.asm"
			include		"mkreg/parts_004.asm"
			include		"mkreg/parts_005.asm"
			include		"mkreg/parts_006.asm"
			include		"mkreg/parts_007.asm"
			include		"mkreg/parts_008.asm"
			include		"mkreg/parts_009.asm"
			include		"mkreg/parts_010.asm"
			include		"mkreg/parts_011.asm"
			include		"mkreg/parts_012.asm"
			include		"mkreg/parts_013.asm"
			include		"mkreg/parts_014.asm"
			include		"mkreg/parts_015.asm"
			include		"mkreg/parts_016.asm"
			include		"mkreg/parts_017.asm"
			include		"mkreg/parts_018.asm"
			include		"mkreg/parts_019.asm"
			include		"mkreg/parts_020.asm"
			include		"mkreg/parts_021.asm"
			include		"mkreg/parts_022.asm"
			include		"mkreg/parts_023.asm"
			include		"mkreg/parts_024.asm"
			include		"mkreg/parts_025.asm"
			include		"mkreg/parts_026.asm"
			include		"mkreg/parts_027.asm"
			include		"mkreg/parts_028.asm"
			include		"mkreg/parts_029.asm"
			include		"mkreg/parts_030.asm"
			include		"mkreg/parts_031.asm"
			include		"mkreg/parts_032.asm"
			include		"mkreg/parts_033.asm"
			include		"mkreg/parts_034.asm"
			include		"mkreg/parts_035.asm"
			include		"mkreg/parts_036.asm"
			include		"mkreg/parts_037.asm"
			include		"mkreg/parts_038.asm"
			include		"mkreg/parts_039.asm"
			include		"mkreg/parts_040.asm"
			include		"mkreg/parts_041.asm"
			include		"mkreg/parts_042.asm"
			include		"mkreg/parts_043.asm"
			include		"mkreg/parts_044.asm"
			include		"mkreg/parts_045.asm"
			include		"mkreg/parts_046.asm"
			include		"mkreg/parts_047.asm"
			include		"mkreg/parts_048.asm"
			include		"mkreg/parts_049.asm"
			include		"mkreg/parts_050.asm"
			include		"mkreg/parts_051.asm"
			include		"mkreg/parts_052.asm"
			include		"mkreg/parts_053.asm"
			include		"mkreg/parts_054.asm"
			include		"mkreg/parts_055.asm"
			include		"mkreg/parts_056.asm"
			include		"mkreg/parts_057.asm"
			include		"mkreg/parts_058.asm"
			include		"mkreg/parts_059.asm"
			include		"mkreg/parts_060.asm"
			include		"mkreg/parts_061.asm"
			include		"mkreg/parts_062.asm"
			include		"mkreg/parts_063.asm"
scroll_data_end::

; --------------------------------------------------------------------
;	graphics data
; --------------------------------------------------------------------
hmmc_msx_logo::
			dw			24				; DX �]������W
			dw			0				; DY �]������W
			dw			208				; NX ��
			dw			64				; NY ����
			db			0				; ARG ����
			db			0b11110000		; HMMC
			include		"msx_logo.asm"	; offset +10

			align		16384

scroll_data_ptr		:= 0xC000
rom_slot			:= 0xC002
