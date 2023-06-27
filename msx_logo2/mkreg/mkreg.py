#!/usr/bin/env python3
# coding=utf-8
# =============================================================================
#  Parts converter
# -----------------------------------------------------------------------------
#  2022/Dec/25 t.hara
# =============================================================================

import math

# -----------------------------------------------------------------------------
def output_data( index, phase ):

	with open( "parts_%03d.asm" % index, "w" ) as f:
		f.write( "parts_%03d::\n" % index )
		for y in range( 0, 128 ):
			current_phase = (phase + y) * math.pi / 64
			sample_y = math.cos( current_phase ) * 32 + 32
			if sample_y < 0 or sample_y > 64:
				sample_y = 64
			else:
				sample_y = int( y - sample_y )
			reg23 = (y - sample_y) & 255
			f.write( "\t\tdb\t%d\t\t\t; #%d\n" % ( reg23, y ) )
			f.write( "\t\tdb\t0x80 | 23\n" )

# -----------------------------------------------------------------------------
def main():
	index = 0
	phase = 0
	x = 0

	# —Ž‰º
	for bottom_y in range( 0, 128, 4 ):
		phase = (bottom_y - 64)
		output_data( index, phase )
		index = index + 1
	for bottom_y in range( 128, 0, -4 ):
		phase = (bottom_y - 64)
		output_data( index, phase )
		index = index + 1
main()
