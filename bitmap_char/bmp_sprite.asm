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
ldirvm			:= 0x005C				; CPU RAM → VRAM 転送

forclr			:= 0xF3E9				; 前景色
bakclr			:= 0xF3EA				; 背景色
bdrclr			:= 0xF3EB				; 周辺色

rg1sav			:= 0xF3E0				; VDP R#1
rg8sav			:= 0xFFE7				; VDP R#8
rg9sav			:= 0xFFE8				; VDP R#9

exptbl			:= 0xFCC1
slttbl			:= 0xFCC5

jiffy			:= 0xFC9E

h_keyi			:= 0xFD9A				; 全割り込みのフック

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
			; スプライト無効
			ld			a, [rg8sav]
			or			a, 0b00000010		; スプライト無効
			di
			out			[vdp_port1], a
			ld			a, 0x80 | 8
			out			[vdp_port1], a
			ei
			; 192ラインモード
			ld			a, [rg9sav]
			and			a, 0b01111111		; 192ラインモード
			di
			out			[vdp_port1], a
			ld			a, 0x80 | 9
			out			[vdp_port1], a
			ei
			; カラーパレット初期化
			ld			hl, initial_palette
			call		set_palette
			; 画像データ転送
			ld			hl, hmmc_image1
			ld			bc, 64 / 2 * 32
			call		vdp_command_hmmc
			; 背景作成
			call		makeup_background
			; フック
			di
			ld			a, 0xC3				; JP
			ld			[h_keyi], a
			ld			hl, h_keyi_interrupt
			ld			[h_keyi + 1], hl
			ei
			; draw page を初期化
			ld			a, 1
			ld			[draw_page], a
			; display page を初期化
			di
			ld			a, 0x0F
			out			[vdp_port1], a
			ld			a, 0x84
			out			[vdp_port1], a
			ei
			; ボール初期化
			ld			hl, 16
			ld			[ball_y], hl
			; メインループ
		main_loop:
			; V-SYNC待ち ---------------------------------------------
			ld			hl, jiffy
			ld			a, [hl]
		wait_vsync:
			cp			a, [hl]
			jp			z, wait_vsync
			; display page を表示する --------------------------------
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
			; ボールを消す -------------------------------------------
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

			; ボールを表示する ---------------------------------------
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

			; draw page と display page を入れ替える -----------------
			ld			a, [draw_page]
			xor			a, 1
			ld			[draw_page], a
			jp			main_loop
			endscope

; --------------------------------------------------------------------
;	割り込み処理
;		やるのは VDP S#0チェックと JIFFYインクリメントだけ。
;		S#0をここで読んでしまうので、H.TIMI と BIOS の V-SYNCルーチンは発動しない
; --------------------------------------------------------------------
			scope		h_keyi_interrupt
h_keyi_interrupt::
			; Check VDP S#0
			in			a, [vdp_port1]
			or			a, a
			ret			p						; 垂直同期割り込みで無ければ戻る

			; 垂直同期割り込み
			ld			hl, [jiffy]
			inc			hl
			ld			[jiffy], hl
			ret
			endscope

; --------------------------------------------------------------------
;	背景作成
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
;	パレット変更
;		HL ... パレットデータのアドレス
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
;	HL ..... 座標データ,転送データのアドレス
;	BC ..... 転送データ数
; --------------------------------------------------------------------
			scope		vdp_command_hmmc
vdp_command_hmmc::
			push		bc
			ld			e, l
			ld			d, h
			ld			bc, 10
			add			hl, bc
			ex			de, hl

			; VDP R#17 = R#36 (オートインクリメント)
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

			; VDP R#17 = R#44 (非オートインクリメント)
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
;	HL ..... 座標データ,転送データのアドレス
; --------------------------------------------------------------------
			scope		vdp_command
vdp_command::
			; VDP R#17 = R#32 (オートインクリメント)
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
;	ボールを表示
;		B .... ボールの色 0, 16, 32, 48
;		E .... 転送先 Y
;		D .... 転送先 X
; --------------------------------------------------------------------
			scope		put_ball
put_ball::
			; VDP R#17 = R#32 (オートインクリメント)
			di
			ld			a, 0x00 | 32
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a
			ld			c, vdp_port3
			ld			hl, lmmm_tpset
			ld			a, [draw_page]
			out			[c], b			; R#32 (SX下位)
			outi						; R#33 (SX上位)
			outi						; R#34 (SY下位)
			outi						; R#35 (SY上位)
			out			[c], d			; R#36 (DX下位)
			outi						; R#37 (DX上位)
			out			[c], e			; R#38 (DY下位)
			out			[c], a			; R#39 (DY上位) : 転送先ページ
			outi						; R#40 (NX下位)
			outi						; R#41 (NX上位)
			outi						; R#42 (NY下位)
			outi						; R#43 (NY上位)
			outi						; R#44 (CLR)
			outi						; R#45 (ARG)
			outi						; R#46 (CMD)
			ei
			ret
lmmm_tpset:
			db			0				; SX 転送元座標 (上位)
			dw			512				; SY 転送元座標
			db			0				; DX 転送先座標 (上位)
			dw			16				; NX 幅
			dw			16				; NY 高さ
			db			0				; CLR dummy
			db			0				; ARG 向き
			db			0b10011000		; LMMM, TIMP
			endscope

; --------------------------------------------------------------------
;	ボールを消す
;		A .... 転送先 Y
;		D .... 転送先 X
; --------------------------------------------------------------------
			scope		erase_ball
erase_ball::
			; VDP R#17 = R#32 (オートインクリメント)
			di
			ld			a, 0x00 | 32
			out			[vdp_port1], a
			ld			a, 0x80 | 17
			out			[vdp_port1], a
			ld			c, vdp_port3
			ld			hl, hmmm_copy
			ld			a, [draw_page]
			out			[c], d			; R#32 (SX下位)
			outi						; R#33 (SX上位)
			out			[c], e			; R#34 (SY下位)
			outi						; R#35 (SY上位)
			out			[c], d			; R#36 (DX下位)
			outi						; R#37 (DX上位)
			out			[c], e			; R#38 (DY下位)
			out			[c], a			; R#39 (DY上位) : 転送先ページ
			outi						; R#40 (NX下位)
			outi						; R#41 (NX上位)
			outi						; R#42 (NY下位)
			outi						; R#43 (NY上位)
			outi						; R#44 (CLR)
			outi						; R#45 (ARG)
			outi						; R#46 (CMD)
			ei
			ret
hmmm_copy:
			db			0				; SX 転送元座標 (上位)
			db			2				; SY 転送元座標 (上位)
			db			0				; DX 転送先座標 (上位)
			dw			16				; NX 幅
			dw			16				; NY 高さ
			db			0				; CLR dummy
			db			0				; ARG 向き
			db			0b11010000		; HMMM
			endscope

; --------------------------------------------------------------------
;	VDP Command完了待ち
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
			dw			0				; SX 転送元座標 (dummy)
			dw			0				; SY 転送元座標 (dummy)
			dw			0				; DX 転送先座標
			dw			0				; DY 転送先座標
			dw			256				; NX 幅
			dw			512				; NY 高さ
			db			0x44			; CLR
			db			0				; ARG
			db			0b11000000		; CMD

; --------------------------------------------------------------------
hmmc_image1::
			dw			0				; DX 転送先座標
			dw			512				; DY 転送先座標
			dw			64				; NX 幅
			dw			32				; NY 高さ
			db			0				; ARG 向き
			db			0b11110000		; HMMC
			include		"image1.asm"	; offset +10

; --------------------------------------------------------------------
hmmm_htrans::
			dw			0				; SX 転送元座標
			dw			512 + 16		; SY 転送元座標
			dw			16				; DX 転送先座標
			dw			512 + 16		; DY 転送先座標
			dw			256 - 16		; NX 幅
			dw			16				; NY 高さ
			db			0				; CLR dummy
			db			0				; ARG 向き
			db			0b11010000		; HMMM

; --------------------------------------------------------------------
ymmm_vtrans::
			dw			0				; SX dummy
			dw			512 + 16		; SY 転送元座標
			dw			0				; DX 転送先座標
			dw			512 + 32		; DY 転送先座標
			dw			256				; NX dummy
			dw			128 - 16		; NY 高さ
			db			0				; CLR dummy
			db			0				; ARG 向き
			db			0b11100000		; YMMM

; --------------------------------------------------------------------
ymmm_page0::
			dw			0				; SX dummy
			dw			512 + 16		; SY 転送元座標
			dw			0				; DX 転送先座標
			dw			0 + 16			; DY 転送先座標
			dw			256				; NX dummy
			dw			128				; NY 高さ
			db			0				; CLR dummy
			db			0				; ARG 向き
			db			0b11100000		; YMMM

; --------------------------------------------------------------------
ymmm_page1::
			dw			0				; SX dummy
			dw			512 + 16		; SY 転送元座標
			dw			0				; DX 転送先座標
			dw			256 + 16		; DY 転送先座標
			dw			256				; NX dummy
			dw			128				; NY 高さ
			db			0				; CLR dummy
			db			0				; ARG 向き
			db			0b11100000		; YMMM

			align		16384

; --------------------------------------------------------------------
;	work area
; --------------------------------------------------------------------
draw_page	:=			0xC000			; 1byte  : 描画中のページ
ball_y		:=			0xC001			; 2bytes : Y座標
ball_y_d1	:=			0xC003			; 1byte
ball_y_d2	:=			0xC004			; 1byte
