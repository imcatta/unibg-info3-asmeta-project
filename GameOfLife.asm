asm GameOfLife

import StandardLibrary

signature:
	
	enum domain CellStatus = { ALIVE | DEAD }
	domain Coordinate subsetof Natural
	domain Cell subsetof Prod(Coordinate, Coordinate)
	
	dynamic controlled universe: Cell -> CellStatus
	
	static liveNeighbor: Cell -> Powerset(Cell)
	static liveNeighborCount: Cell -> Natural
	static refresh: Cell -> CellStatus
	

definitions:
	domain Coordinate = { 0n .. 4n }
	
	function liveNeighbor($cell in Cell) =
		let ($x = first($cell), $y = second($cell)) in
			{
				$i in Coordinate, $j in Coordinate | 
				((abs($x - $i) + abs($y - $j) = 1) or (abs($x - $i) = 1 and abs($y - $j) = 1))
				and universe(($i, $j)) = ALIVE : ($i , $j)
			}
		endlet
	
	function liveNeighborCount($cell in Cell) = iton(size(liveNeighbor($cell)))
				
	function refresh($cell in Cell) =
		let ($status = universe($cell), $liveNeighbor = liveNeighborCount($cell)) in
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

		
	rule r_tick = forall $x in Coordinate, $y in Coordinate do universe(($x, $y)) := refresh(($x, $y))
	// for some reason if i use `forall $cell in Cell` the interpreter raises a java.lang.NullPointerException

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
	