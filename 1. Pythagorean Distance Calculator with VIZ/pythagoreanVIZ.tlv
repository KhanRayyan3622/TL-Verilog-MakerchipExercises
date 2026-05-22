\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   |calc
      @1
         $reset = *reset;
         // Random inputs representing x and y distances
         $x[7:0] = $rand1[7:0];
         $y[7:0] = $rand2[7:0];
         
      @2
         // Stage 2: square both values
         // Flip-flops from @1→@2 inferred automatically
         $x_sq[15:0] = $x * $x;
         $y_sq[15:0] = $y * $y;
         
      @3
         // Stage 3: sum of squares
         $sum_sq[16:0] = $x_sq + $y_sq;
         
      @4
         // Stage 4: approximate sqrt via bit shift
         // Real sqrt would use iterative hardware
         $dist[8:0] = $sum_sq[16:8];
   
   // VIZ block — visual debug showing pipeline stages
   \viz_js
      {
         layout: {
            x_in: {
               type: "box",
               x: 10, y: 20, width: 120, height: 50,
               label: (ctx) => `X: ${ctx.signal('/pipe|calc/x').asInt()}`,
               fillColor: "#D6E4F0"
            },
            y_in: {
               type: "box",
               x: 10, y: 80, width: 120, height: 50,
               label: (ctx) => `Y: ${ctx.signal('/pipe|calc/y').asInt()}`,
               fillColor: "#D6E4F0"
            },
            dist_out: {
               type: "box",
               x: 300, y: 50, width: 160, height: 50,
               label: (ctx) => `Dist ≈ ${ctx.signal('/pipe|calc/dist').asInt()}`,
               fillColor: "#EAF4EA"
            }
         }
      }
   
   *passed = *cyc_cnt > 60;
   *failed = 1'b0;
\SV
   endmodule
