\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   
   |pkt_proc
      @1
         $reset = *reset;
         $valid = !$reset && $rand1[0];
         
      ?$valid
         @1
            $pkt_type[1:0] = $rand2[1:0];
            $src_addr[3:0] = $rand3[3:0];
            $dst_addr[3:0] = $rand4[3:0];
            
         @2
            $local   = ($dst_addr == 4'hF);
            $forward = !$local;
            $drop    = ($pkt_type == 2'b11); // drop invalid type
            
         @3
            $accepted = $local && !$drop;
            $forwarded = $forward && !$drop;
               
   *passed = *cyc_cnt > 100;
   *failed = 1'b0;
\SV
   endmodule
