#!/usr/bin/env python3
# coding=utf-8
# =============================================================================
#  Parts converter
# -----------------------------------------------------------------------------
#  2022/Dec/25 t.hara
# =============================================================================

import math

# -----------------------------------------------------------------------------
def output_data( index, bottom_y, height ):

	with open( "parts_%03d.asm" % index, "w" ) as f:
		f.write( "parts_%03d::\n" % index )
		for y in range( 0, 128 ):
			top_y = bottom_y - height;

			if y < top_y or y > bottom_y:
				sample_y = 64
				reg23 = (sample_y - y) & 255
			else:
				sample_y = int( (y - top_y) * 64 / height )
				reg23 = (sample_y - y) & 255
			f.write( "\t\tdb\t%d\t\t\t; #%d\n" % ( reg23, y ) )
			f.write( "\t\tdb\t0x80 | 23\n" )

# -----------------------------------------------------------------------------
def main():
	index = 0
	bottom_y = 0
	height = 64
	x = 0

	# —Ž‰º
	for bottom_y in range( 0, 128, 4 ):
		height = 128 * math.cos( (bottom_y - 64) * math.pi / 4. / 32. )
		if height < 32:
			height = 32
		print( "Y = %d, H = %d" % ( bottom_y, height ) )
		output_data( index, bottom_y, height )
		index = index + 1
	for bottom_y in range( 128, 0, -4 ):
		height = 128 * math.cos( (bottom_y - 64) * math.pi / 4. / 32. )
		if height < 32:
			height = 32
		output_data( index, bottom_y, height )
		index = index + 1
main()
