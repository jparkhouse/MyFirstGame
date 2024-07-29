extends Node

# bitflags
enum {
	TOP_LEFT_CORNER = 1 << 0,
	TOP_WALL = 1 << 1,
	TOP_RIGHT_CORNER = 1 << 2,
	RIGHT_WALL = 1 << 3,
	BOTTOM_RIGHT_CORNER = 1 << 4,
	BOTTOM_WALL = 1 << 5,
	BOTTOM_LEFT_CORNER = 1 << 6,
	LEFT_WALL = 1 << 7
}

# enum of all tiles
enum TILE_KEYS {
	BOTTOMRIGHTINNER = BOTTOM_RIGHT_CORNER,
	BOTTOMLEFTINNER = BOTTOM_LEFT_CORNER,
	TOPRIGHTINNER = TOP_RIGHT_CORNER,
	TOPLEFTINNER = TOP_LEFT_CORNER,
	TOPWALL = TOP_LEFT_CORNER | TOP_WALL | TOP_RIGHT_CORNER,
	LEFTWALL = BOTTOM_LEFT_CORNER | LEFT_WALL | TOP_LEFT_CORNER,
	RIGHTWALL = TOP_RIGHT_CORNER | RIGHT_WALL | BOTTOM_RIGHT_CORNER,
	BOTTOMWALL = BOTTOM_RIGHT_CORNER | BOTTOM_WALL | BOTTOM_LEFT_CORNER,
	TOPLEFTCORNER = LEFT_WALL | TOP_LEFT_CORNER | TOP_WALL,
	TOPRIGHTCORNER = TOP_WALL | TOP_RIGHT_CORNER | RIGHT_WALL,
	BOTTOMLEFTCORNER = BOTTOM_WALL | BOTTOM_LEFT_CORNER | LEFT_WALL,
	BOTTOMRIGHTCORNER = RIGHT_WALL | BOTTOM_RIGHT_CORNER | BOTTOM_WALL,
	EMPTY = 0,
	NORTHSOUTHCORRIDOR = BOTTOM_LEFT_CORNER | LEFT_WALL | TOP_LEFT_CORNER | \
		TOP_RIGHT_CORNER | RIGHT_WALL | BOTTOM_RIGHT_CORNER,
	EASTWESTCORRIDOR = TOP_LEFT_CORNER | TOP_WALL | TOP_RIGHT_CORNER | \
		BOTTOM_RIGHT_CORNER | BOTTOM_WALL | BOTTOM_LEFT_CORNER,
	BOTTOMENTRANCE = BOTTOM_LEFT_CORNER | BOTTOM_RIGHT_CORNER,
	TOPENTRANCE = TOP_LEFT_CORNER | TOP_RIGHT_CORNER,
	LEFTENTRANCE = TOP_LEFT_CORNER | BOTTOM_LEFT_CORNER,
	RIGHTENTRANCE = TOP_RIGHT_CORNER | BOTTOM_RIGHT_CORNER,
	TOPLEFTTURN = TOP_LEFT_CORNER | TOP_RIGHT_CORNER | BOTTOM_RIGHT_CORNER | \
		BOTTOM_LEFT_CORNER | RIGHT_WALL | BOTTOM_WALL,
	TOPRIGHTTURN = TOP_LEFT_CORNER | TOP_RIGHT_CORNER | BOTTOM_RIGHT_CORNER | \
		BOTTOM_LEFT_CORNER | LEFT_WALL | BOTTOM_WALL,
	BOTTOMLEFTTURN = TOP_LEFT_CORNER | TOP_RIGHT_CORNER | BOTTOM_RIGHT_CORNER |\
		BOTTOM_LEFT_CORNER | RIGHT_WALL | TOP_WALL,
	BOTTOMRIGHTTURN = TOP_LEFT_CORNER | TOP_RIGHT_CORNER | BOTTOM_RIGHT_CORNER\
		| BOTTOM_LEFT_CORNER | LEFT_WALL | TOP_WALL,
	NOTSET,
}

const LEFT_SELECTION_MASK = BOTTOM_LEFT_CORNER | LEFT_WALL | TOP_LEFT_CORNER
const TOP_SELECTION_MASK = TOP_LEFT_CORNER | TOP_WALL | TOP_RIGHT_CORNER
const RIGHT_SELECTION_MASK = TOP_RIGHT_CORNER | RIGHT_WALL | BOTTOM_RIGHT_CORNER
const BOTTOM_SELECTION_MASK = BOTTOM_RIGHT_CORNER | BOTTOM_WALL | BOTTOM_LEFT_CORNER

func get_valid_tiles(top_tile: TILE_KEYS,\
	right_tile: TILE_KEYS,\
	bottom_tile: TILE_KEYS,\
	left_tile: TILE_KEYS) -> Array[TILE_KEYS]:
	return TILE_KEYS.keys().filter(
		func filter_tiles(key):
			var truths = []
			if left_tile != TILE_KEYS.NOTSET: # if the tile on the left is set
				truths.push(is_valid_tile_side(left_tile, key, DIRECTIONS.LEFT))
			if top_tile != TILE_KEYS.NOTSET:
				truths.push(is_valid_tile_side(top_tile, key, DIRECTIONS.TOP))
			if bottom_tile != TILE_KEYS.NOTSET:
				truths.push(is_valid_tile_side(bottom_tile, key, DIRECTIONS.BOTTOM))
			if right_tile != TILE_KEYS.NOTSET:
				truths.push(is_valid_tile_side(right_tile, key, DIRECTIONS.RIGHT))
			return truths.all(func is_true(x: bool):
								return x) # if any are false, not a valid match
	)

enum DIRECTIONS {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

func is_valid_tile_side(tile_to_compare: TILE_KEYS, tile_to_set: TILE_KEYS, direction: DIRECTIONS) -> bool:
	match direction:
		DIRECTIONS.LEFT:
			var left_tile_right_side = tile_to_compare & RIGHT_SELECTION_MASK # right side of left tile
			# this is what is fixed from the tile on the left
			var left_side = tile_to_set & LEFT_SELECTION_MASK # left side of the
			# considered tile
			return left_tile_right_side & left_side == left_tile_right_side
		
		DIRECTIONS.RIGHT: # same for other directions
			var right_tile_left_side = tile_to_compare & LEFT_SELECTION_MASK
			var right_side = tile_to_set & RIGHT_SELECTION_MASK
			return right_tile_left_side & right_side == right_tile_left_side
		
		DIRECTIONS.TOP:
			var top_tile_bottom_side = tile_to_compare & BOTTOM_SELECTION_MASK
			var top_side = tile_to_set & TOP_SELECTION_MASK
			return top_tile_bottom_side & top_side == top_tile_bottom_side

		DIRECTIONS.BOTTOM:
			var bottom_tile_top_side = tile_to_compare & TOP_SELECTION_MASK
			var bottom_side = tile_to_set & BOTTOM_SELECTION_MASK
			return bottom_tile_top_side & bottom_side == bottom_tile_top_side
		_: # anything else
			return false
