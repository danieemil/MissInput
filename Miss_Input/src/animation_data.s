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


_player_run_left:

    .dw #_player_spr_02
    .dw #_player_spr_01
    .dw #_player_spr_00
    .dw #_player_spr_01
    .dw #0x0000



_player_run_right:

    .dw #_player_spr_06
    .dw #_player_spr_05
    .dw #_player_spr_04
    .dw #_player_spr_05
    .dw #0x0000



_player_die:
    .dw #_player_spr_09
    .dw #_player_spr_10
    .dw #_player_spr_11
    .dw #_player_spr_13
    .dw #_player_spr_14
    .dw #_player_spr_15
    .dw #0x0000




_power_up_djump:
    .dw #_powerUps_spr_14
    .dw #_powerUps_spr_15
    .dw #_powerUps_spr_16
    .dw #_powerUps_spr_17
    .dw #_powerUps_spr_18
    .dw #_powerUps_spr_19
    .dw #_powerUps_spr_15
    .dw #_powerUps_spr_14
    .dw #_powerUps_spr_14
    .dw #_powerUps_spr_14
    .dw #_powerUps_spr_14
    .dw #_powerUps_spr_14
    .dw #_powerUps_spr_14
    .dw #0x0000


_power_up_gup:
    .dw #_powerUps_spr_00
    .dw #_powerUps_spr_01
    .dw #_powerUps_spr_02
    .dw #_powerUps_spr_03
    .dw #_powerUps_spr_04
    .dw #_powerUps_spr_05
    .dw #_powerUps_spr_06
    .dw #_powerUps_spr_00
    .dw #_powerUps_spr_00
    .dw #_powerUps_spr_00
    .dw #_powerUps_spr_00
    .dw #_powerUps_spr_00
    .dw #_powerUps_spr_00
    .dw #0x0000


_power_up_gdown:
    .dw #_powerUps_spr_07
    .dw #_powerUps_spr_08
    .dw #_powerUps_spr_09
    .dw #_powerUps_spr_10
    .dw #_powerUps_spr_11
    .dw #_powerUps_spr_12
    .dw #_powerUps_spr_13
    .dw #_powerUps_spr_07
    .dw #_powerUps_spr_07
    .dw #_powerUps_spr_07
    .dw #_powerUps_spr_07
    .dw #_powerUps_spr_07
    .dw #_powerUps_spr_07
    .dw #0x0000

_enemy_01_left:
    .dw #_enemy01_spr_0
    .dw #_enemy01_spr_1
    .dw #0x000

_enemy_01_right:
    .dw #_enemy01_spr_2
    .dw #_enemy01_spr_3
    .dw #0x000

_enemy_02_left:
    .dw #_enemy02_spr_0
    .dw #_enemy02_spr_1
    .dw #0x000

_enemy_02_right:
    .dw #_enemy02_spr_2
    .dw #_enemy02_spr_3
    .dw #0x000

_enemy_03_anim:
    .dw #_enemy02_spr_4
    .dw #_enemy02_spr_5
    .dw #0x000

