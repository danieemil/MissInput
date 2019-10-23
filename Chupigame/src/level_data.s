.include "level_data.h.s"


;;.db #*tw, #*th, #*tw, #*th, #0x20
entities:
   .db #00, #176, #28, #24, #0x20         ;;Suelo [0,22] {7, 3} Tamaño en tiles
   .db #00, #00 , #80, #16, #0x20         ;;Suelo [0,0]  {20,2} Tamaño en tiles
   .db #44, #176, #32, #24, #0x20         ;;Suelo [11,22]{8, 3} Tamaño en tiles
   .db #12, #160, #8,  #16, #0x20         ;;Suelo [11,22]{8, 3} Tamaño en tiles
   .db #7*tw, #14*th, #2*tw, #4*th, #0x20         ;;Suelo [11,22]{8, 3} Tamaño en tiles
   .db #9*tw, #14*th, #2*tw, #2*th, #0x20
   .db #3*tw, #8*th, #5*tw, #1*th, #0x00
   .db #14*tw, #11*th, #2*tw, #6*th, #0x00
   .db #16*tw, #11*th, #4*tw, #3*th, #0x00
   .db #19*tw, #2*th, #1*tw, #5*th, #0x00
   .db #19*tw, #14*th, #1*tw, #8*th, #0x00
   .db #0*tw, #7*th, #1*tw, #15*th, #0x00
   .db #0*tw, #2*th, #1*tw, #5*th, #0x00
   .db #0x80




;;.db #*tw, #*th, #*tw, #*th, #0x20
special_entities:
   .db #7*tw, #22*th, #4*tw, #3*th, #e_pinchos
   .db #19*tw, #7*th, #1*tw, #4*th, #e_salida
   .db #9*tw, #4*th, #2*tw, #10*th, #e_gup
   .db #14*tw, #2*th, #2*tw, #7*th, #e_gdown
   .db #end_of_data



;;.db #*tw, #*th, #power_width, #power_height, #
power_ups:
   .db #5*tw, #14*th, #power_width, #power_height, #p_djump
   .dw _power1_spr
   .db #5*tw, #14*th

   .db #12*tw, #18*th, #power_width, #power_height, #p_gup
   .dw _power1_spr
   .db #12*tw, #18*th

   .db #1*tw, #2*th, #power_width, #power_height, #p_gdown
   .dw _power1_spr
   .db #1*tw, #2*th

   .db #end_of_data



enemies:
   ;;Enemigo que rebota
   .db #3*tw, #6*th, #enemy_width, #enemy_height, #e_bounce     ;;Entity
   .dw _enemy_spr                                               ;;Render
   .db #3*tw, #6*th                                   
   .db #01, #0, #4*tw, #4*tw, #3*tw, #6*th, #02, #00            ;;Dirx  Diry  Range  Counter  OrX  OrY  Res  ResCount

   ;;Enemigo que detecta y persigue
   .db #17*tw, #16*th, #enemy_width, #enemy_height, #e_chase    ;;Entity
   .dw _enemy_spr                                               ;;Render
   .db #17*tw, #16*th  
   .db #00, #00, #20, #20, #17*tw, #16*th, #01, #00             ;;Enemy

   .db #end_of_data