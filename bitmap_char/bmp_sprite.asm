; --------------------------------------------------------------------
;	BMP SPRITE DEMO
; ====================================================================
;	2023/June/28th t.hara (HRA!)
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

jiffy			:= 0xFC9E

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
			; COLOR 15,4,4:SCREEN 5
			ld			hl, (4 << 8) | 15
			ld			[forclr], hl
			ld			a, h
			ld			[bdrclr], a
			ld			a, 5
			call		chgmod
			; �X�v���C�g����
			ld			a, [rg8sav]
			or			a, 0b00000010		; �X�v���C�g����
			di
			out			[vdp_port1], a
			ld			a, 0x80 | 8
			out			[vdp_port1], a
			ei
			; 192���C�����[�h
			ld			a, [rg9sav]
			and			a, 0b01111111		; 192���C�����[�h
			di
			out			[vdp_port1], a
			ld			a, 0x80 | 9
			out			[vdp_port1], a
			ei
			; �J���[�p���b�g������
			ld			hl, initial_palette
			call		set_palette
			; �摜�f�[�^�]��
			ld			hl, hmmc_image1
			ld			bc, 64 / 2 * 32
			call		vdp_command_hmmc
			; �w�i�쐬
			call		makeup_background
			; �t�b�N
			di
			ld			a, 0xC3				; JP
			ld			[h_keyi], a
			ld			hl, h_keyi_interrupt
			ld			[h_keyi + 1], hl
			ei
			; draw page ��������
			ld			a, 1
			ld			[draw_page], a
			; display page ��������
			di
			ld			a, 0x0F
			out			[vdp_port1], a
			ld			a, 0x84
			out			[vdp_port1], a
			ei
			; �{�[��������
			ld			hl, 16
			ld			[ball_y], hl
			; ���C�����[�v
		main_loop:
			; V-SYNC�҂� ---------------------------------------------
			ld			hl, jiffy
			ld			a, [hl]
		wait_vsync:
			cp			a, [hl]
			jp			z, wait_vsync
			; display page ��\������ --------------------------------
			di
			ld			a, [draw_page]
			rrca
			rrca
			rrca
			xor			a, 0x3F
			out			[vdp_port1], a
			ld			a, 0x82
			out			[vdp_port1], a
			ei
			; �{�[�������� -------------------------------------------
			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 0
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 16
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 32
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 48
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 64
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 80
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 96
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 112
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 128
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 144
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 160
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 176
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 192
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 208
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 224
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 240
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 24
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 40
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 56
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 72
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 88
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 104
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 120
			call		erase_ball

			call		wait_complete_vdp_command
			ld			de, [ball_y_d2]
			ld			d, 136
			call		erase_ball

			; �{�[����\������ ---------------------------------------
			call		wait_complete_vdp_command
			ld			b, 0
			ld			de, [ball_y]
			ld			d, 0
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 16
			ld			de, [ball_y]
			ld			d, 16
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 32
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 48
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 0
			ld			de, [ball_y]
			ld			d, 64
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 16
			ld			de, [ball_y]
			ld			d, 80
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 96
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 112
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 0
			ld			de, [ball_y]
			ld			d, 128
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 16
			ld			de, [ball_y]
			ld			d, 144
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 160
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 176
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 192
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 208
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 224
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 240
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 24
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 0
			ld			de, [ball_y]
			ld			d, 40
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 16
			ld			de, [ball_y]
			ld			d, 56
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 72
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 48
			ld			de, [ball_y]
			ld			d, 88
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 0
			ld			de, [ball_y]
			ld			d, 104
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 16
			ld			de, [ball_y]
			ld			d, 120
			call		put_ball

			call		wait_complete_vdp_command
			ld			b, 32
			ld			de, [ball_y]
			ld			d, 136
			call		put_ball

			ld			a, [ball_y_d1]
			ld			[ball_y_d2], a
			ld			a, [ball_y]
			ld			[ball_y_d1], a
			inc			a
			cp			a, 128
			jp			c, skip_ball
			ld			a, 16
		skip_ball:
			ld			[ball_y], a

			; draw page �� display page �����ւ��� -----------------
			ld			a, [draw_page]
			xor			a, 1
			ld			[draw_page], a
			jp			main_loop
			endscope

; --------------------------------------------------------------------
;	���荞�ݏ���
;		���̂� VDP S#0�`�F�b�N�� JIFFY�C���N�������g�����B
;		S#0�������œǂ�ł��܂��̂ŁAH.TIMI �� BIOS �� V-SYNC���[�`���͔������Ȃ�
; --------------------------------------------------------------------
			scope		h_keyi_interrupt
h_keyi_interrupt::
			; Check VDP S#0
			in			a, [vdp_port1]
			or			a, a
			ret			p						; �����������荞�݂Ŗ�����Ζ߂�

			; �����������荞��
			ld			hl, [jiffy]
			inc			hl
			ld			[jiffy], hl
			ret
			endscope

; --------------------------------------------------------------------
;	�w�i�쐬
; --------------------------------------------------------------------
			scope		makeup_background
makeup_background::
			ld			hl, hmmv_clear
			call		vdp_command
			call		wait_complete_vdp_command

			ld			hl, hmmm_htrans
			call		vdp_command
			call		wait_complete_vdp_command

			ld			hl, ymmm_vtrans
			call		vdp_command
			call		wait_complete_vdp_command

			ld			hl, ymmm_page0
			call		vdp_command
			call		wait_complete_vdp_command

			ld			hl, ymmm_page1
			call		vdp_command
			call		wait_complete_vdp_command
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
;	VDP Command
;	HL ..... ���W�f�[�^,�]���f�[�^�̃A�h���X
; --------------------------------------------------------------------
			scope		vdp_command
vdp_command::
			; VDP R#17 = R#32 (�I�[�g�C���N�������g)
			di
			ld			a, 0x00 | 32
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a
			ld			bc, (15 << 8) | vdp_port3
			otir							; R#32-R#46
			ei
			ret
			endscope

; --------------------------------------------------------------------
;	�{�[����\��
;		B .... �{�[���̐F 0, 16, 32, 48
;		E .... �]���� Y
;		D .... �]���� X
; --------------------------------------------------------------------
			scope		put_ball
put_ball::
			; VDP R#17 = R#32 (�I�[�g�C���N�������g)
			di
			ld			a, 0x00 | 32
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a
			ld			c, vdp_port3
			ld			hl, lmmm_tpset
			ld			a, [draw_page]
			out			[c], b			; R#32 (SX����)
			outi						; R#33 (SX���)
			outi						; R#34 (SY����)
			outi						; R#35 (SY���)
			out			[c], d			; R#36 (DX����)
			outi						; R#37 (DX���)
			out			[c], e			; R#38 (DY����)
			out			[c], a			; R#39 (DY���) : �]����y�[�W
			outi						; R#40 (NX����)
			outi						; R#41 (NX���)
			outi						; R#42 (NY����)
			outi						; R#43 (NY���)
			outi						; R#44 (CLR)
			outi						; R#45 (ARG)
			outi						; R#46 (CMD)
			ei
			ret
lmmm_tpset:
			db			0				; SX �]�������W (���)
			dw			512				; SY �]�������W
			db			0				; DX �]������W (���)
			dw			16				; NX ��
			dw			16				; NY ����
			db			0				; CLR dummy
			db			0				; ARG ����
			db			0b10011000		; LMMM, TIMP
			endscope

; --------------------------------------------------------------------
;	�{�[��������
;		A .... �]���� Y
;		D .... �]���� X
; --------------------------------------------------------------------
			scope		erase_ball
erase_ball::
			; VDP R#17 = R#32 (�I�[�g�C���N�������g)
			di
			ld			a, 0x00 | 32
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a
			ld			c, vdp_port3
			ld			hl, hmmm_copy
			ld			a, [draw_page]
			out			[c], d			; R#32 (SX����)
			outi						; R#33 (SX���)
			out			[c], e			; R#34 (SY����)
			outi						; R#35 (SY���)
			out			[c], d			; R#36 (DX����)
			outi						; R#37 (DX���)
			out			[c], e			; R#38 (DY����)
			out			[c], a			; R#39 (DY���) : �]����y�[�W
			outi						; R#40 (NX����)
			outi						; R#41 (NX���)
			outi						; R#42 (NY����)
			outi						; R#43 (NY���)
			outi						; R#44 (CLR)
			outi						; R#45 (ARG)
			outi						; R#46 (CMD)
			ei
			ret
hmmm_copy:
			db			0				; SX �]�������W (���)
			db			2				; SY �]�������W (���)
			db			0				; DX �]������W (���)
			dw			16				; NX ��
			dw			16				; NY ����
			db			0				; CLR dummy
			db			0				; ARG ����
			db			0b11010000		; HMMM
			endscope

; --------------------------------------------------------------------
;	VDP Command�����҂�
; --------------------------------------------------------------------
			scope		wait_complete_vdp_command
wait_complete_vdp_command::
			di
			; R#15 = 2 (Status Register Index)
			ld			c, vdp_port1
			ld			a, 2
			out			[c], a
			ld			a, 0x80 | 15
			out			[c], a
			; B = S#2
			in			b, [c]
			; R#15 = 0 (Status Register Index)
			xor			a, a
			out			[c], a
			ld			a, 0x80 | 15
			out			[c], a
			ei
			ld			a, b
			and			a, 1
			jp			nz, wait_complete_vdp_command
			ret
			endscope

; --------------------------------------------------------------------
;	palette data
; --------------------------------------------------------------------
palette		macro		vr, vg, vb
			db			((vr/32) << 4) | (vb/32)
			db			(vg/32)
			endm

initial_palette:
			palette		  0, 111,  87			; #0
			palette		  0,   0,   0			; #1
			palette		 12, 222,  54			; #2
			palette		128, 255, 144			; #3
			palette		  0,   0, 255			; #4
			palette		  0, 165, 255			; #5
			palette		120,   0,   0			; #6
			palette		  0, 225, 255			; #7
			palette		204,   0,   0			; #8
			palette		255, 105,   0			; #9
			palette		144, 108,   0			; #10
			palette		201, 174,   0			; #11
			palette		  0, 141,   0			; #12
			palette		255, 255, 162			; #13
			palette		  0, 255, 255			; #14
			palette		255, 255, 255			; #15

; --------------------------------------------------------------------
;	graphics data
; --------------------------------------------------------------------
hmmv_clear::
			dw			0				; SX �]�������W (dummy)
			dw			0				; SY �]�������W (dummy)
			dw			0				; DX �]������W
			dw			0				; DY �]������W
			dw			256				; NX ��
			dw			512				; NY ����
			db			0x44			; CLR
			db			0				; ARG
			db			0b11000000		; CMD

; --------------------------------------------------------------------
hmmc_image1::
			dw			0				; DX �]������W
			dw			512				; DY �]������W
			dw			64				; NX ��
			dw			32				; NY ����
			db			0				; ARG ����
			db			0b11110000		; HMMC
			include		"image1.asm"	; offset +10

; --------------------------------------------------------------------
hmmm_htrans::
			dw			0				; SX �]�������W
			dw			512 + 16		; SY �]�������W
			dw			16				; DX �]������W
			dw			512 + 16		; DY �]������W
			dw			256 - 16		; NX ��
			dw			16				; NY ����
			db			0				; CLR dummy
			db			0				; ARG ����
			db			0b11010000		; HMMM

; --------------------------------------------------------------------
ymmm_vtrans::
			dw			0				; SX dummy
			dw			512 + 16		; SY �]�������W
			dw			0				; DX �]������W
			dw			512 + 32		; DY �]������W
			dw			256				; NX dummy
			dw			128 - 16		; NY ����
			db			0				; CLR dummy
			db			0				; ARG ����
			db			0b11100000		; YMMM

; --------------------------------------------------------------------
ymmm_page0::
			dw			0				; SX dummy
			dw			512 + 16		; SY �]�������W
			dw			0				; DX �]������W
			dw			0 + 16			; DY �]������W
			dw			256				; NX dummy
			dw			128				; NY ����
			db			0				; CLR dummy
			db			0				; ARG ����
			db			0b11100000		; YMMM

; --------------------------------------------------------------------
ymmm_page1::
			dw			0				; SX dummy
			dw			512 + 16		; SY �]�������W
			dw			0				; DX �]������W
			dw			256 + 16		; DY �]������W
			dw			256				; NX dummy
			dw			128				; NY ����
			db			0				; CLR dummy
			db			0				; ARG ����
			db			0b11100000		; YMMM

			align		16384

; --------------------------------------------------------------------
;	work area
; --------------------------------------------------------------------
draw_page	:=			0xC000			; 1byte  : �`�撆�̃y�[�W
ball_y		:=			0xC001			; 2bytes : Y���W
ball_y_d1	:=			0xC003			; 1byte
ball_y_d2	:=			0xC004			; 1byte
