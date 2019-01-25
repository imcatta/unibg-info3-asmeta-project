asm GameOfLife

import StandardLibrary

signature:
	
	enum domain CellStatus = { ALIVE | DEAD }
	domain Coordinate subsetof Natural
	domain Cell subsetof Prod(Coordinate, Coordinate)
	
	dynamic controlled universe: Cell -> CellStatus
	
	static liveNeighborCount: Cell -> Integer
	static refresh: Cell -> CellStatus
	

definitions:
	domain Coordinate = { 0n .. 4n }
	
	function liveNeighborCount($cell in Cell) =
		let ($x = first($cell), $y = second($cell)) in
			size({
				$i in Coordinate, $j in Coordinate | 
				((abs($x - $i) + abs($y - $j) = 1) or (abs($x - $i) = 1 and abs($y - $j) = 1))
				and universe(($i, $j)) = ALIVE : ($i , $j)
			})
		endlet
				
	function refresh($cell in Cell) =
		let ($x = first($cell), $y = second($cell)) in
			let ($status = universe(($x, $y)), $liveNeighbor = liveNeighborCount(($x, $y))) in
				switch ($status)
					case ALIVE:
					 	if ($liveNeighbor = 2 or $liveNeighbor = 3) then
							ALIVE
						else
							DEAD
						endif
					case DEAD:
						if ($liveNeighbor = 3) then
							ALIVE
						else
							DEAD
						endif
				endswitch
			endlet
		endlet

		
	rule r_tick = forall $x in Coordinate, $y in Coordinate do universe(($x, $y)) := refresh(($x, $y))		

	main rule r_Main = r_tick[]
	
default init s0:
	function universe($cell in Cell) =
		let ($x = first($cell), $y = second($cell)) in
			switch ($x, $y)
				case (1n, 2n): ALIVE
				case (2n, 2n): ALIVE
				case (3n, 2n): ALIVE
				otherwise DEAD
			endswitch
		endlet
	