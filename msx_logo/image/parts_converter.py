#!/usr/bin/env python3
# coding=utf-8
# =============================================================================
#  Parts converter
# -----------------------------------------------------------------------------
#  2022/Dec/25 t.hara
# =============================================================================

import sys
import re

try:
	from PIL import Image
except:
	print( "ERROR: Require PIL module. Please run 'pip3 install Pillow.'" )
	exit()

# --------------------------------------------------------------------
def my_rgb( r, g, b ):
	return (r << 16) | (g << 8) | b;

# --------------------------------------------------------------------
color_palette = [
	my_rgb(   0,   0,   0 ),
	my_rgb(   0,   0,   0 ),
	my_rgb( 101, 206,  51 ),
	my_rgb( 141, 255,  75 ),
	my_rgb(   0,  84, 255 ),
	my_rgb( 135, 123, 255 ),
	my_rgb( 183, 114,   0 ),
	my_rgb(  30, 192, 243 ),
	my_rgb( 186, 126,  60 ),
	my_rgb( 228, 159, 120 ),
	my_rgb( 204, 186,  60 ),
	my_rgb( 231, 231, 111 ),
	my_rgb(  96, 165,   0 ),
	my_rgb(  87,  87,  87 ),
	my_rgb( 174, 174, 177 ),
	my_rgb( 255, 255, 255 ),
];

# --------------------------------------------------------------------
def get_color_index( r, g, b ):
	c = my_rgb( r, g, b )
	try:
		i = color_palette.index( c )
	except:
		return -1
	if i == 0:
		i = 1
	return i

# --------------------------------------------------------------------
def put_datas( file, datas ):
	index = 0
	pattern_no = 0
	for d in datas:
		if index == 0:
			file.write( "\tdb\t0x%02X" % d )
		elif index == 7:
			file.write( ", 0x%02X\t\t; #%02X\n" % ( d, pattern_no ) )
			pattern_no = pattern_no + 1
		else:
			file.write( ", 0x%02X" % d )
		index = (index + 1) & 7
	if index != 0:
		file.write( "\n" )

# --------------------------------------------------------------------
def convert():

	try:
		img = Image.open( "msx_logo.png" )
	except:
		print( "ERROR: Cannot read the 'msx_logo.png'." )
		return

	img = img.convert( 'RGB' )

	# SCREEN5‰æ‘œ‚É•ÏŠ· ------------------------------------------
	image_table = []
	for y in range( 0, 64 ):
		for x in range( 0, 208, 2 ):
			( r, g, b ) = img.getpixel( ( x + 0, y ) )
			p0 = get_color_index( r, g, b )
			( r, g, b ) = img.getpixel( ( x + 1, y ) )
			p1 = get_color_index( r, g, b )
			p = (p0 << 4) | p1
			image_table.append( p )

	with open( "msx_logo.asm", 'wt' ) as file:
		file.write( '; ====================================================================\n' )
		file.write( ';  GRAPHIC PARTS DATA for MSX Logo Demo\n' )
		file.write( '; --------------------------------------------------------------------\n' )
		file.write( ';  Copyright (C)2023 t.hara (HRA!)\n' )
		file.write( '; ====================================================================\n' )
		file.write( '\n' )
		file.write( '\tscope graphic_parts\n' )
		file.write( 'graphic_parts::\n' )
		put_datas( file, image_table )
		file.write( '\tendscope\n' )
	print( "Success!!" )

# --------------------------------------------------------------------
def usage():
	print( "Usage> parts_converter.py" )

# --------------------------------------------------------------------
def main():
	convert()

if __name__ == "__main__":
	main()
