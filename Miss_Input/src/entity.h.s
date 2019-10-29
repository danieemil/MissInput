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

.include "cpctelera.h.s"
.include "vector.h.s"
;; Macros

.macro DefineEntity _name, _x, _y, _w, _h, _type
_name:
    .db _x, _y
    .db _w, _h
    .db _type
    _name'_size = . - _name ;; Saves the number of bytes that fills a DefineEntity
.endm

;; Macro positions

de_x    = 0
de_y    = 1
de_w    = 2
de_h    = 3
de_type = 4
de_size = 5



;; Globals
    ;;Dependencias
    

    ;;Funciones
    .globl detectCollisionX
    .globl collisionY



;Flags de la entidad(almacenados en la variable _type de entidad)
;
;
;7   N -> Nada
;6   N -> Nada
;5   I -> Inhabilitado?(1->Sí, 0->No)
;4   C -> Detectaremos colisiones en Y?(1->No, 0->Sí) Solo se usa en las colisiones!!
;3   T -> |
;2   T -> +-> Tipo de power-up:
;;              (00->Aporta doble salto)
;;              (01->Gravedad hacia arriba)
;;              (10->Gravedad hacia abajo)
;;              (11->Fin del nivel)
;1   M -> Es mortal?(1->Sí, 0->No)
;0   C -> Se puede coger?(1->power-up, 0->no power-up)
;
;N N I C T T M C
;0 0 0 0 0 0 0 0
