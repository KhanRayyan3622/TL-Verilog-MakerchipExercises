\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |life
      @1
         $reset = *reset;
         
         $grid[15:0] = $reset ? 16'b0000_0100_0010_0111 :
                                >>1$next_grid;
         
         // Neighbor count for cell [5] (row 1, col 1)
         $n[3:0] = {3'b0, $grid[0]} + {3'b0, $grid[1]} +
                   {3'b0, $grid[2]} + {3'b0, $grid[4]} +
                   {3'b0, $grid[6]} + {3'b0, $grid[8]} +
                   {3'b0, $grid[9]} + {3'b0, $grid[10]};
         
         $alive = $grid[5];
         $next5 = ($alive && ($n == 4'd2 || $n == 4'd3)) ||
                  (!$alive && $n == 4'd3);
         
         // Also evolve cell [6] (row 1, col 2)
         $n6[3:0] = {3'b0,$grid[1]}+{3'b0,$grid[2]}+{3'b0,$grid[3]}+
                    {3'b0,$grid[5]}+{3'b0,$grid[7]}+{3'b0,$grid[9]}+
                    {3'b0,$grid[10]}+{3'b0,$grid[11]};
         $alive6 = $grid[6];
         $next6 = ($alive6 && ($n6==4'd2||$n6==4'd3)) ||
                  (!$alive6 && $n6==4'd3);
         
         $next_grid[15:0] = {$grid[15:7], $next6, $next5, $grid[4:0]};
   
   *passed = *cyc_cnt > 50;
   *failed = 1'b0;
\SV
   endmodule
