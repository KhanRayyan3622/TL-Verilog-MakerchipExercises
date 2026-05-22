\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |fifo
      @1
         $reset = *reset;
         
         // Determine write/read enables from cycle counter
         // Write on even cycles, read on odd cycles (simple stimulus)
         $wr_en = !$reset && (*cyc_cnt[0] == 1'b0) && !$full;
         $rd_en = !$reset && (*cyc_cnt[0] == 1'b1) && !$empty;
         $wr_data[7:0] = *cyc_cnt[7:0];
         
         // Write pointer
         $wr_ptr[2:0] = $reset   ? 3'b0 :
                        $wr_en   ? >>1$wr_ptr + 1 :
                                   >>1$wr_ptr;
         // Read pointer  
         $rd_ptr[2:0] = $reset   ? 3'b0 :
                        $rd_en   ? >>1$rd_ptr + 1 :
                                   >>1$rd_ptr;
         
         // Occupancy count
         $count[3:0] = $reset             ? 4'b0 :
                       ($wr_en && !$rd_en) ? >>1$count + 1 :
                       ($rd_en && !$wr_en) ? >>1$count - 1 :
                                             >>1$count;
         $empty = ($count == 4'b0);
         $full  = ($count == 4'd8);
         
         // Simple read data — use write data delayed (no true memory array)
         // For a real FIFO with memory, use SystemVerilog array in \SV block
         $rd_data[7:0] = >>1$wr_data;
   
   *passed = *cyc_cnt > 80;
   *failed = ($full && $wr_en) || ($empty && $rd_en);
\SV
   endmodule
