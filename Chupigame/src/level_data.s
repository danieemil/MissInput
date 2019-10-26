.include "level_data.h.s"






levels:

   .dw #lvl_01




;;===============================
;;
;;       LEVEL 01
;;
;;===============================
lvl_01:

   .dw #_level_01_end

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #19*th

   ;; ENTIDADES DE COLISION
   .db #0*tw, #21*th, #4*tw, #3*th, #0x00
   .db #4*tw, #19*th, #3*tw, #5*th, #0x00
   .db #7*tw, #21*th, #3*tw, #3*th, #0x00
   .db #10*tw, #15*th, #3*tw, #9*th, #0x00
   .db #17*tw, #15*th, #3*tw, #9*th, #0x00
   .db #0*tw, #9*th, #4*tw, #1*th, #0x00
   .db #3*tw, #0*th, #16*tw, #2*th, #0x00
   .db #0*tw, #10*th, #1*tw, #11*th, #0x00
   .db #18*tw, #2*th, #2*tw, #9*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #3*tw, #2*th, #1*tw, #7*th, #e_pinchos
   .db #13*tw, #20*th, #4*tw, #2*th, #e_pinchos
   .db #19*tw+2, #11*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   ;.db #5*tw, #14*th, #power_width, #power_height, #0x01
   ;.dw _powerUps_spr_14
   ;.db #5*tw, #14*th, #0, #0, #0, #0
   .db #0x80
   
   ;; ENEMIGOS
   ;.db #3*tw, #6*th, #enemy_width, #enemy_height, e_bounce     ;;Entity
   ;.dw _enemy02_spr_4                                               ;;Render
   ;.db #3*tw, #6*th, #0, #0, #0, #0                              
   ;.db #01, #0, #4*tw, #4*tw, #3*tw, #6*th, #02, #00   
   .db #0x80









