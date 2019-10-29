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

.include "enemy.h.s"


;;====================================================
;;Definition: Updatea todos los enemigos del vector
;;Entrada:
;;  IY  ->  Puntero al vector de enemigos
;;  A   ->  Número de enemigos
;;  BC  ->  Tamaño de cada enemigo
;;Salida:
;;Destruye: A, BC, IY
;;====================================================
enemy_updateAll:

    cp #0
    ret z

    enemiesU_not_empty:
    bit 5, de_type(iy)
    jr nz, next_enemy

    exx
    ex af, af'

    ;; Contador que limita el número de veces que un enemigo se ejecuta
    xor a
    cp dE_resCount(iy)
    jr z, do_update

        dec dE_resCount(iy)
        ld a, de_x(iy)
        ld dde_preX(iy), a
        ld a, de_y(iy)
        ld dde_preY(iy), a
        jr next_enemy

    do_update:
    ld a, dE_res(iy)
    ld dE_resCount(iy), a
    bit 7, de_type(iy)
        call z,  enemy_updateR
        call nz, enemy_updateP
    call enemy_move
    

    next_enemy:
    ex af, af'
    exx

    add iy, bc

    dec a
    jr nz, enemiesU_not_empty
ret




;;==========================================================
;;Definition: Actualiza los datos de un enemigo que persigue
;;Entrada:
;;  IX  ->  Puntero al player
;;  IY  ->  Puntero al enemigo
;;Salida:
;;Destruye: A, BC
;;==========================================================
enemy_updateP:
    xor a
    cp dE_counter(iy)
    jr z, follow

        check_counter:
        ld a, de_x(ix)
        sub de_x(iy)
        jp p, check_counterX
            neg
        
        check_counterX:
        cp dE_counter(iy)
        ret p

        ld a, de_y(ix)
        sub de_y(iy)
        jp p, check_counterY
            neg
        
        check_counterY:
        ld b, dE_range(iy)
        sla b
        sla b
        cp b
        ret p

        ld dE_counter(iy), #0

    ret

    follow:
        ;;Cuando se acerca el enemigo va más despacio
        ld dE_res(iy), #enemy_far_counter
        
        check_range:
        ld a, de_x(ix)
        sub de_x(iy)
        jp p, check_rangeX
            neg
        
        check_rangeX:
        cp dE_range(iy)
        jp p, follow_X

        ld a, de_y(ix)
        sub de_y(iy)
        jp p, check_rangeY
            neg
        
        check_rangeY:
        ld b, dE_range(iy)
        sla b
        sla b
        cp b
        jp p, follow_X

        ld dE_res(iy), #enemy_near_counter

        
    follow_X:

        ld dE_dirX(iy), #0 
        ld dE_dirY(iy), #0

        ld a, de_x(ix)
        sub de_x(iy)
        jp m, player_left
        jr z, follow_Y 

    player_right:
        ld dE_dirX(iy), #1
        jr follow_Y

    player_left:
        ld dE_dirX(iy), #-1

    follow_Y:
        ld a, de_y(ix)
        sub de_y(iy)
        jp m, player_up
        ret z

    player_down:
        ld dE_dirY(iy), #4
        ret

    player_up:
        ld dE_dirY(iy), #-4

ret


;;==========================================================
;;Definition: Actualiza los datos de un enemigo que "rebota"
;;Entrada:
;;  IX  ->  Puntero al player
;;  IY  ->  Puntero al enemigo
;;Salida:
;;Destruye: A
;;==========================================================
enemy_updateR:

    xor a
    cp dE_counter(iy)
    jp nz, decr_counter

        reset_counter:
        ld a, dE_range(iy)
        ld dE_counter(iy), a

        bit 6, de_type(iy)
        jr z, invert_direction

            go_to_Origin:
            ;; On x
            ld a, dE_orX(iy)
            ld de_x(iy), a

            ;; On y
            ld a, dE_orY(iy)
            ld de_y(iy), a

            jr updR_end

        invert_direction:

        xor a               ;;[4]
        sub dE_dirX(iy)     ;;[19]
        ld dE_dirX(iy), a   ;;[19]
        ;; Optimizado, opción menos óptima utilizando (neg)

        xor a
        sub dE_dirY(iy)
        ld dE_dirY(iy), a

        jr updR_end

    decr_counter:
    dec dE_counter(iy)

    updR_end:
    xor a
ret


;;=====================================================================
;;Definition: Actualiza la posición del enemigo en función de sus datos
;;Entrada:
;;  IY  ->  Puntero al enemigo
;;Salida:
;;Destruye: A
;;=====================================================================
enemy_move:

    ld a, de_x(iy)
    add a, dE_dirX(iy)
    ld de_x(iy), a

    ld a, de_y(iy)
    add a, dE_dirY(iy)
    ld de_y(iy), a

ret
