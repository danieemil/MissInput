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

.globl _g_palette

.globl cpct_disableFirmware_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm
.globl cpct_setPALColour_asm
.globl cpct_zx7b_decrunch_s_asm
.globl cpct_isAnyKeyPressed_asm
.globl cpct_isKeyPressed_asm
.globl cpct_scanKeyboard_asm
.globl cpct_waitVSYNC_asm
.globl cpct_akp_musicInit_asm
.globl cpct_akp_musicPlay_asm
.globl cpct_akp_stop_asm
.globl cpct_akp_SFXInit_asm
.globl cpct_akp_SFXStop_asm
.globl cpct_akp_SFXStopAll_asm
.globl cpct_akp_SFXGetInstrument_asm
.globl cpct_setInterruptHandler_asm
;.globl cpct_scanKeyboard_if_asm
