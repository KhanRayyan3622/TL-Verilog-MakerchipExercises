\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |pipe
      @1
         $reset  = *reset;
         $valid  = !$reset;
         $data[7:0]  = *cyc_cnt[7:0];
         $addr[3:0]  = *cyc_cnt[3:0];
         $cmd[1:0]   = *cyc_cnt[1:0];
      
      @2
         // In TL-Verilog, signals from @1 are automatically available at @2
         // via staging (flip-flops inferred). This IS the transaction flow.
         // $ANY would pull ALL @1 signals if referencing a subscope.
         // Here we demonstrate the concept by using staged signals:
         $result[7:0] = ($cmd == 2'b00) ? $data :
                        ($cmd == 2'b01) ? $data + 8'd1 :
                        ($cmd == 2'b10) ? {$addr, $addr} :
                                          8'hFF;
         `BOGUS_USE($result)
      
      @3
         // Demonstrating $ANY in a when-scope (valid transactions only)
         ?$valid
            // All signals ($data, $addr, $cmd) available here
            // because they flow through the pipeline as a transaction
            $processed[7:0] = ($cmd == 2'b11) ? ~$data : $data;
   
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
