\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |cpu_pipe
      @1
         // IF — Instruction Fetch
         $reset = *reset;
         $pc[31:0] = $reset ? 32'b0 : >>1$pc + 32'd4;
         $instr[7:0] = *cyc_cnt[7:0];   // simulated instruction
         
      @2
         // ID — Instruction Decode
         $opcode[1:0] = $instr[1:0];
         $operand[5:0] = $instr[7:2];
         
      @3
         // EX — Execute
         $alu_out[7:0] = ($opcode == 2'b00) ? {2'b0, $operand} + 8'd1  :
                         ($opcode == 2'b01) ? {2'b0, $operand} - 8'd1  :
                         ($opcode == 2'b10) ? {2'b0, $operand} << 1    :
                                              {2'b0, $operand} >> 1    ;
      @4
         // MEM — Memory Access (simulated)
         $mem_data[7:0] = $alu_out;   // pass through (no actual memory)
         $mem_valid = ($opcode == 2'b00);
         
      @5
         // WB — Write Back
         $wb_data[7:0] = $mem_data;
         $wb_valid = $mem_valid;
   
   *passed = *cyc_cnt > 60;
   *failed = 1'b0;
\SV
   endmodule
