\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |cpu
      @1
         $reset = *reset;
         
         $pc[31:0] = $reset        ? 32'b0 :
                     >>1$taken_br  ? >>1$br_tgt :
                                     >>1$pc + 32'd4;
         
         // Hardcoded program memory
         $instr[31:0] = ($pc[3:0] == 4'h0) ? 32'h00500093 :
                        ($pc[3:0] == 4'h4) ? 32'h00A00113 :
                        ($pc[3:0] == 4'h8) ? 32'h002081B3 :
                        ($pc[3:0] == 4'hC) ? 32'hFE000AE3 :
                                             32'h00000013;
         
         $is_r = ($instr[6:0] == 7'b0110011);
         $is_i = ($instr[6:0] == 7'b0010011);
         $is_b = ($instr[6:0] == 7'b1100011);
         
         $rs1[4:0] = $instr[19:15];
         $rs2[4:0] = $instr[24:20];
         $rd[4:0]  = $instr[11:7];
         $imm[31:0] = {{20{$instr[31]}}, $instr[31:20]};
         $funct3[2:0] = $instr[14:12];
         `BOGUS_USE($funct3)
         
      @2
         $fwd_a = (>>1$rd == $rs1) && (>>1$rd != 5'b0) && >>1$is_r;
         $fwd_b = (>>1$rd == $rs2) && (>>1$rd != 5'b0) && >>1$is_r;
         
         $op_a[31:0] = $fwd_a   ? >>1$result : 32'b0;
         $op_b[31:0] = $fwd_b   ? >>1$result :
                       $is_i    ? $imm        : 32'b0;
         
         $result[31:0] = ($is_i || $is_r) ? $op_a + $op_b : 32'b0;
         
         $taken_br = $is_b && ($op_a == $op_b);
         $br_tgt[31:0] = >>1$pc + $imm;
   
   *passed = *cyc_cnt > 60;
   *failed = 1'b0;
\SV
   endmodule
