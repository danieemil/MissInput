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

.macro ReserveVector _name, _e_size, _elems
_name'_size:    .db _e_size
_name'_num:     .db #0
_name'_next:    .dw . + 2
_name:
    .rept _elems
        .rept _e_size
            .db #0xDA
        .endm
    .endm
.endm


vector_nx_l = -1
vector_nx_l = -2
vector_n    = -3
vector_s    = -4


.globl new_elem
.globl vector_reset
