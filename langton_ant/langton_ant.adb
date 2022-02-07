with ada.text_io; use ada.text_io;

procedure langton_ant is
    -- for limited iterations
	max_iterations : constant positive := 10000; -- how many iterations?
	type iterations is range 1 .. max_iterations; -- prints max_iterations + 1, the first just shows beginning
    -- for limited iterations


    iterations_per_second : integer := 3; -- if it is too fast it will finish fine but the rendering will look weird when running as the anscii clear can't keep up
   	-- board
	-- size
	width : constant positive := 20;
	height : constant positive := width;

	type rows is mod height;
	type cols is mod width;
	-- size
	-- grid
	type square is (white, black);
	type field is array (rows, cols) of square;

	board : field := (others=>(others=>white));
	-- grid
   	-- board

	-- keep track of current move
	type move_count is range 0 .. integer'last;
	current_move : move_count := 0;
	-- keep track of current move
	
	-- ant
	type direction is (left, up, right, down);

	ant_col : cols;
	ant_row : rows;
	ant_dir : direction;
	-- ant
		
	function turn_right(dir: direction) return direction is
	begin
	    return (if dir = direction'last then direction'first else direction'succ(dir));
	end turn_right;

	function turn_left(dir: direction) return direction is
	begin
	    return (if dir = direction'first then direction'last else direction'pred(dir));
	end turn_left;

	-- move forward
	procedure move(ant_row: in out rows; ant_col: in out cols; ant_dir: in direction) is	
	begin
		case ant_dir is
			when left => ant_col := ant_col - 1;
			when up => ant_row := ant_row -1;
			when right => ant_col := ant_col + 1;
			when down => ant_row := ant_row + 1;
		end case;	
		
	end move;

	procedure draw_board(b: field) is
	begin
        put(ascii.esc);
        put("[1J");
        put(ascii.esc);
        put("[1;1H");
		put_line("move:" & current_move'img); -- print current move
		current_move := current_move + 1;     -- increment current move
		for row in rows loop
			for col in cols loop
				if row = ant_row and col = ant_col then -- if the coordinates are the position of the ant
                    put(ascii.esc);
                    put("[31m"); -- set foreground color to red
					case ant_dir is -- draw ant
						when up		=> put('^');
						when down	=> put('v');
						when left	=> put('<');
						when right	=> put('>');
					end case;
                    put(ascii.esc);
                    put("[0m"); -- reset sgr - select graphic rendition - how the text is rendered - here we are changing color
				else -- if square is not ant's position just draw a square
					case b(row,col) is
						when white => put('.');
						when black => put('#');
					end case;
				end if;
			end loop;
		    --put(ascii.esc & "[11A" & ascii.esc & "[11D");--&"[2J"); -- ansi clear
			new_line;
		end loop;
        --put(ascii.esc & "[13A" & ascii.esc & "11D");
--        put("[10A");
--        put(ascii.esc);
--        put("[10D");
        delay duration(1.0/iterations_per_second); -- divisor is how many iterations per second
	end;
begin
    	-- ant initialization
    	ant_row := 4;
	ant_col := 2;
	ant_dir := up;
    	-- ant initialization

	draw_board(board); -- first render

	--for iteration in iterations -- comment out for infinite loop
	loop 
		case board(ant_row, ant_col) is
			when white =>  -- if white
				ant_dir := turn_right(ant_dir);  -- turn right
				board(ant_row,ant_col) := black; -- flip to black
				move(ant_row, ant_col, ant_dir); -- move foward
			when black =>
				ant_dir := turn_left(ant_dir);   -- turn left
				board(ant_row,ant_col) := white; -- flip to white
				move(ant_row, ant_col, ant_dir); -- move forward
		end case;

		draw_board(board); -- render
		--new_line;
			
	end loop;
end langton_ant;
