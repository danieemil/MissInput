.include "level_data.h.s"


;; PUNERO A LOS NIVELES
levels:

   .dw #lvl_01
   .dw #lvl_02
   .dw #lvl_03
   .dw #lvl_04
   .dw #lvl_05
   .dw #lvl_06
   .dw #lvl_07
   .dw #lvl_08
   .dw #lvl_09
   .dw #lvl_10

   .dw #0x0000

;;===============================
;;
;;       LEVEL 01
;;
;;===============================
lvl_01:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_01_end

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
   .db #0x80
   
   ;; ENEMIGOS
   .db #0x80




;;===============================
;;
;;       LEVEL 02
;;
;;===============================
   lvl_02:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_02_end

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #19*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #21*th, #17*tw, #2*th, #0x00
   .db #10*tw, #19*th, #2*tw, #2*th, #0x00
   .db #18*tw, #17*th, #2*tw, #4*th, #0x00
   .db #1*tw, #11*th, #11*tw, #2*th, #0x00
   .db #12*tw, #6*th, #4*tw, #7*th, #0x00
   .db #4*tw, #0*th, #15*tw, #2*th, #0x00
   .db #0*tw, #13*th, #1*tw, #8*th, #0x00
   .db #3*tw, #2*th, #1*tw, #5*th, #0x00
   .db #19*tw, #2*th, #1*tw, #15*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #5*tw, #20*th, #2*tw, #1*th, #e_pinchos
   .db #10*tw, #18*th, #2*tw, #1*th, #e_pinchos
   .db #16*tw, #20*th, #2*tw, #1*th, #e_pinchos
   .db #9*tw, #10*th, #3*tw, #1*th, #e_pinchos
   .db #3*tw, #7*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #0x80
   
   ;; ENEMIGOS 
   .db #0x80



;;===============================
;;
;;       LEVEL 03
;;
;;===============================
   lvl_03:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_06_end                       ;; El nivel 3 utiliza el mapa 6 (esta bien, no preguntar)

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #19*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #21*th, #3*tw, #3*th, #0x00
   .db #7*tw, #8*th, #2*tw, #14*th, #0x00
   .db #12*tw, #20*th, #2*tw, #3*th, #0x00
   .db #12*tw, #2*th, #2*tw, #13*th, #0x00
   .db #17*tw, #7*th, #3*tw, #14*th, #0x00
   .db #0*tw, #15*th, #1*tw, #6*th, #0x00
   .db #1*tw, #3*th, #3*tw, #12*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #4*tw, #22*th, #3*tw, #2*th, #e_pinchos
   .db #9*tw, #22*th, #3*tw, #2*th, #e_pinchos
   .db #14*tw, #22*th, #3*tw, #2*th, #e_pinchos
   .db #4*tw, #2*th, #8*tw, #1*th, #e_pinchos
   .db #14*tw, #2*th, #5*tw, #1*th, #e_pinchos
   .db #19*tw+2, #3*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #0x80
   
   ;; ENEMIGOS 
   .db #0x80



;;===============================
;;
;;       LEVEL 04
;;
;;===============================
   lvl_04:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_03_end                       ;; El nivel 4 utiliza el mapa 3

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #17*tw, #6*th

   ;; ENTIDADES DE COLISION
   .db #0*tw, #18*th, #4*tw, #3*th, #0x00
   .db #4*tw, #21*th, #12*tw, #3*th, #0x00
   .db #16*tw, #8*th, #3*tw, #13*th, #0x00
   .db #11*tw, #2*th, #3*tw, #10*th, #0x00
   .db #0*tw, #2*th, #1*tw, #12*th, #0x00
   .db #1*tw, #0*th, #18*tw, #2*th, #0x00
   .db #19*tw, #2*th, #1*tw, #6*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #0*tw, #14*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #0x80
   
   ;; ENEMIGOS 
   .db #4*tw+1, #19*th, #enemy_width, #enemy_height, e_bounce     ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #4*tw+1, #19*th, #0, #0, #0, #0                            ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #01, #0, #11*tw-1, #11*tw-1, #3*tw, #6*th, #01, #00        ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   .db #0x80




;;===============================
;;
;;       LEVEL 05
;;
;;===============================
   lvl_05:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_04_end                       ;; El nivel 5 utiliza el mapa 4

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #4*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #6*th, #4*tw, #2*th, #0x00
   .db #4*tw, #14*th, #4*tw, #2*th, #0x00
   .db #1*tw, #21*th, #19*tw, #2*th, #0x00
   .db #1*tw, #0*th, #18*tw, #2*th, #0x00
   .db #0*tw, #2*th, #1*tw, #4*th, #0x00
   .db #0*tw, #8*th, #1*tw, #13*th, #0x00
   .db #8*tw, #2*th, #2*tw, #14*th, #0x00
   .db #13*tw, #7*th, #2*tw, #14*th, #0x00
   .db #19*tw, #3*th, #1*tw, #14*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #19*tw+2, #17*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #0x80
   
   ;; ENEMIGOS 
   .db #7*tw+1, #12*th, #enemy_width, #enemy_height, e_line       ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #1*tw, #12*th, #0, #0, #0, #0                              ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #-1, #0, #6*tw, #6*tw, #7*tw+1, #12*th, #01, #00          ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   
   .db #12*tw+1, #19*th, #enemy_width, #enemy_height, e_line       ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #12*tw+1, #19*th, #0, #0, #0, #0                              ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #-1, #0, #11*tw, #11*tw, #12*tw+1, #19*th, #01, #00          ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   
   .db #18*tw, #2*th-1, #enemy_width, #enemy_height, e_line       ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #18*tw, #19*th, #0, #0, #0, #0                              ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #0, #4, #8*tw+1, #8*tw+1, #18*tw, #2*th-1, #01, #00          ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   
   .db #0x80


;Crispin dice:
;iikl....... 

;;===============================
;;
;;       LEVEL 06
;;
;;===============================
   lvl_06:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_07_end                       ;; El nivel 5 utiliza el mapa 4

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #15*tw, #7*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #13*th, #3*tw, #1*th, #0x00
   .db #6*tw, #17*th, #3*tw, #1*th, #0x00
   .db #12*tw, #20*th, #2*tw, #1*th, #0x00
   .db #17*tw, #17*th, #2*tw, #1*th, #0x00
   .db #7*tw, #9*th, #10*tw, #1*th, #0x00
   .db #1*tw, #0*th, #18*tw, #2*th, #0x00
   .db #10*tw, #2*th, #1*tw, #3*th, #0x00
   .db #11*tw, #2*th, #3*tw, #7*th, #0x00
   .db #0*tw, #2*th, #1*tw, #11*th, #0x00
   .db #0*tw, #14*th, #1*tw, #7*th, #0x00
   .db #19*tw, #2*th, #1*tw, #8*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #1*tw, #21*th, #18*tw, #2*th, #e_pinchos
   .db #19*tw, #10*th, #1*tw, #11*th, #e_pinchos
   .db #10*tw+2, #5*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #0x80
   
   ;; ENEMIGOS 
   .db #1*tw-1, #10*th, #enemy_width, #enemy_height, e_line       ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #1*tw, #12*th, #0, #0, #0, #0                              ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #1, #0, #17*tw, #17*tw+1, #1*tw-1, #10*th, #01, #00          ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   
   .db #8*tw-1, #15*th, #enemy_width, #enemy_height, e_line       ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #1*tw, #12*th, #0, #0, #0, #0                              ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #1, #0, #17*tw, #10*tw+1, #1*tw-1, #15*th, #01, #00        ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   .db #0x80




;;===============================
;;
;;       LEVEL 07
;;
;;===============================
   lvl_07:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_05_end                       ;; El nivel 5 utiliza el mapa 4

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #19*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #21*th, #15*tw, #2*th, #0x00
   .db #16*tw, #17*th, #4*tw, #4*th, #0x00
   .db #0*tw, #14*th, #1*tw, #7*th, #0x00
   .db #1*tw, #13*th, #13*tw, #1*th, #0x00
   .db #5*tw, #7*th, #15*tw, #1*th, #0x00
   .db #0*tw, #2*th, #1*tw, #11*th, #0x00
   .db #1*tw, #0*th, #19*tw, #2*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #5*tw, #20*th, #2*tw, #1*th, #e_pinchos
   .db #1*tw, #12*th, #2*tw, #1*th, #e_pinchos
   .db #19*tw, #8*th, #1*tw, #9*th, #e_pinchos
   .db #19*tw+2, #2*th, #1*tw-2, #5*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #0x80
   
   ;; ENEMIGOS 
   .db #8*tw, #10*th, #enemy_width, #enemy_height, #e_chase    ;;Entity
   .dw _enemy01_spr_4                                             ;;Render
   .db #8*tw, #10*th, #0, #0, #0, #0
   .db #00, #00, #20, #20, #8*tw, #10*th, #01, #00             ;;Enemy
   
   .db #0x80



;;===============================
;;
;;       LEVEL 08
;;
;;===============================
   lvl_08:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_08_end                       

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #13*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #15*th, #5*tw, #5*th, #0x00
   .db #0*tw, #2*th, #1*tw, #13*th, #0x00
   .db #19*tw, #2*th, #1*tw, #11*th, #0x00
   .db #1*tw, #0*th, #18*tw, #2*th, #0x00
   .db #15*tw, #17*th, #5*tw, #3*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #6*tw, #20*th, #9*tw, #2*th, #e_pinchos
   .db #19*tw+2, #13*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #10*tw+1, #11*th, #power_width, #power_height, #p_djump
   .dw _powerUps_spr_14
   .db #5*tw, #14*th, #0, #0, #0, #0
   .db #0x80
   
   ;; ENEMIGOS
   .db #0x80




;;===============================
;;
;;       LEVEL 09
;;
;;===============================
   lvl_09:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_09_end                       

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #19*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #21*th, #19*tw, #2*th, #0x00
   .db #9*tw, #10*th, #2*tw, #3*th, #0x00
   .db #3*tw, #1*th, #14*tw, #2*th, #0x00
   .db #0*tw, #7*th, #1*tw, #14*th, #0x00
   .db #19*tw, #7*th, #1*tw, #10*th, #0x00
   .db #1*tw, #3*th, #2*tw, #4*th, #0x00
   .db #17*tw, #3*th, #2*tw, #4*th, #0x00
   .db #9*tw, #3*th, #2*tw, #2*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #9*tw, #13*th, #2*tw, #8*th, #e_pinchos
   .db #19*tw+2, #17*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #6*tw, #16*th, #power_width, #power_height, #p_gup
   .dw _powerUps_spr_14
   .db #5*tw, #14*th, #0, #0, #0, #0

   .db #17*tw+2, #11*th, #power_width, #power_height, #p_gdown
   .dw _powerUps_spr_14
   .db #5*tw, #14*th, #0, #0, #0, #0

   .db #0x80
   
   ;; ENEMIGOS
   .db #0x80





;;===============================
;;
;;       LEVEL 10
;;
;;==============================                                                                                                            bnnnnnnnnnnnnnnnnn==
   lvl_10:

   ;;PALETA DEL NIVEL
   .db #0x57, #0x54, #0x4C, #0x4B

   ;;POSICION FINAL DEL MAPA COMPRIMIDO
   .dw #_map_10_end                       

   ;;POSICIÓN INICIAL DEL JUGADOR
   .db #2*tw, #4*th

   ;; ENTIDADES DE COLISION
   .db #1*tw, #6*th, #2*tw, #1*th, #0x00
   .db #3*tw, #6*th, #2*tw, #2*th, #0x00
   .db #13*tw, #6*th, #7*tw, #1*th, #0x00
   .db #3*tw, #14*th, #5*tw, #5*th, #0x00
   .db #8*tw, #14*th, #6*tw, #2*th, #0x00
   .db #14*tw, #11*th, #2*tw, #7*th, #0x00
   .db #6*tw, #21*th, #13*tw, #2*th, #0x00
   .db #1*tw, #0*th, #2*tw, #2*th, #0x00
   .db #8*tw, #0*th, #2*tw, #2*th, #0x00
   .db #12*tw, #0*th, #8*tw, #2*th, #0x00
   .db #0*tw, #2*th, #1*tw, #4*th, #0x00
   .db #0*tw, #8*th, #1*tw, #13*th, #0x00
   .db #19*tw, #8*th, #1*tw, #13*th, #0x00
   .db #0x80

   ;; ENTIDADES ESPECIALES
   .db #3*tw, #0*th, #5*tw, #2*th, #e_pinchos
   .db #10*tw, #0*th, #2*tw, #2*th, #e_pinchos
   .db #1*tw, #7*th, #2*tw, #1*th, #e_pinchos
   .db #15*tw, #7*th, #4*tw, #1*th, #e_pinchos
   .db #1*tw, #21*th, #5*tw, #2*th, #e_pinchos
   .db #19*tw+2, #2*th, #1*tw-2, #4*th, #e_salida
   .db #0x80

   ;; POWER UPS
   .db #11*tw-2, #18*th, #power_width, #power_height, #p_gup
   .dw _powerUps_spr_14
   .db #5*tw, #14*th, #0, #0, #0, #0

   .db #0x80
   
   ;; ENEMIGOS
   .db #3*tw+1, #12*th, #enemy_width, #enemy_height, e_bounce     ;; Entity
   .dw _enemy02_spr_4                                             ;; Render
   .db #4*tw+1, #19*th, #0, #0, #0, #0                            ;; PreX, PreY, Animation data (no cambiar de #0)
   .db #01, #0, #10*tw-1, #10*tw-1, #3*tw, #12*th, #01, #00        ;; DirX, DirY, Rango, RangoInicial, OrigX, OrigY, Iteraciones/update, ResCounter 
   .db #0x80



