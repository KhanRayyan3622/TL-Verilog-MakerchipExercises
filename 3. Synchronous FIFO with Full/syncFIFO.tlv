\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |fifo
      @1
         $reset = *reset;
         $wr_en = !$reset && !$full  && (*cyc_cnt[3] == 1'b0);
         $rd_en = !$reset && !$empty && (*cyc_cnt[3] == 1'b1);
         $wr_data[7:0] = *cyc_cnt[7:0];
         
         $wr_ptr[2:0] = $reset ? 3'b0 :
                        $wr_en ? >>1$wr_ptr + 1 : >>1$wr_ptr;
         $rd_ptr[2:0] = $reset ? 3'b0 :
                        $rd_en ? >>1$rd_ptr + 1 : >>1$rd_ptr;
         
         $count[3:0] = $reset             ? 4'b0 :
                       ($wr_en && !$rd_en) ? >>1$count + 1 :
                       ($rd_en && !$wr_en) ? >>1$count - 1 :
                                             >>1$count;
         $empty = ($count == 4'b0);
         $full  = ($count == 4'd8);
         
         // Shift-register based storage (8 deep)
         $fifo_0[7:0] = ($wr_en && $wr_ptr==3'd0) ? $wr_data : >>1$fifo_0;
         $fifo_1[7:0] = ($wr_en && $wr_ptr==3'd1) ? $wr_data : >>1$fifo_1;
         $fifo_2[7:0] = ($wr_en && $wr_ptr==3'd2) ? $wr_data : >>1$fifo_2;
         $fifo_3[7:0] = ($wr_en && $wr_ptr==3'd3) ? $wr_data : >>1$fifo_3;
         $fifo_4[7:0] = ($wr_en && $wr_ptr==3'd4) ? $wr_data : >>1$fifo_4;
         $fifo_5[7:0] = ($wr_en && $wr_ptr==3'd5) ? $wr_data : >>1$fifo_5;
         $fifo_6[7:0] = ($wr_en && $wr_ptr==3'd6) ? $wr_data : >>1$fifo_6;
         $fifo_7[7:0] = ($wr_en && $wr_ptr==3'd7) ? $wr_data : >>1$fifo_7;
         
         $rd_data[7:0] = ($rd_ptr==3'd0) ? $fifo_0 :
                         ($rd_ptr==3'd1) ? $fifo_1 :
                         ($rd_ptr==3'd2) ? $fifo_2 :
                         ($rd_ptr==3'd3) ? $fifo_3 :
                         ($rd_ptr==3'd4) ? $fifo_4 :
                         ($rd_ptr==3'd5) ? $fifo_5 :
                         ($rd_ptr==3'd6) ? $fifo_6 :
                                           $fifo_7;
   
   *passed = *cyc_cnt > 80;
   *failed = ($full && $wr_en) || ($empty && $rd_en);
\SV
   endmodule
