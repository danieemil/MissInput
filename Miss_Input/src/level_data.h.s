;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of Miss Input: An Amstrad CPC Game 
;;  Copyright (C) 2019 Enrique Vidal Cayuela, Daniel Saura Martínez
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

.include "animation_data.h.s"
.include "bins/map_01.h.s"
.include "bins/map_02.h.s"
.include "bins/map_06.h.s"
.include "bins/map_03.h.s"
.include "bins/map_04.h.s"
.include "bins/map_07.h.s"
.include "bins/map_05.h.s"
.include "bins/map_08.h.s"
.include "bins/map_09.h.s"
.include "bins/map_10.h.s"
.include "bins/map_15.h.s"
.include "bins/map_17.h.s"
.include "bins/map_11.h.s"
.include "bins/map_12.h.s"
.include "bins/map_13.h.s"
.include "bins/map_14.h.s"
.include "bins/map_16.h.s"
.include "bins/map_18.h.s"
.include "bins/map_19.h.s"
.include "bins/map_20.h.s"
.include "bins/map_21.h.s"
.include "bins/map_23.h.s"
.include "bins/map_24.h.s"



;;Constantes

    ;;Tiles
    tw = 4
    th = 8

    ;;Entidades especiales
    e_pinchos = 0x02     ;; 00000010
    e_salida  = 0x0C     ;; 00001100
    e_djump   = 0x00     ;; 00000000
    e_gup     = 0x04     ;; 00000100
    e_gdown   = 0x08     ;; 00001000

    ;;Power-ups
    power_width     = 2
    power_height    = 8

    p_djump = 0x01       ;; 00000001
    p_gup   = 0x05       ;; 00000101
    p_gdown = 0x09       ;; 00001001

    ;;Enemigos
    enemy_width    = 4
    enemy_height   = 16

    e_bounce = 0x02      ;; 00000010
    e_line   = 0x42      ;; 01000010  
    e_chase  = 0x82      ;; 10000010

end_of_data = 0x80

;; Cosas de la etiqueta de los niveles
levels_l = 0
levels_h = 1


;; Globales
    ;; Dependencias
    
    .globl levels
    .globl lvl_01


    ;;Funciones