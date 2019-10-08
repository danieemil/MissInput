;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
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

;; Include all CPCtelera constant definitions, macros and variables
.include "cpctelera.h.s"
.include "main.h.s"
.include "player.h.s"
.include "bins/MapaPruebas2.h.s"
.include "bins/mylevel_0.h.s"
.include "bins/tileset.h.s"


;;
;; Start of _DATA area 
;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
;;  right after _CODE area contents.
;;
.area _DATA

;;
;; Start of _CODE area
;; 
.area _CODE

;; 
;; Declare all function entry points as global symbols for the compiler.
;; (The linker will know what to do with them)
;; WARNING: Every global symbol declared will be linked, so DO NOT declare 
;; symbols for functions you do not use.
;;

DefineEntity caja, #32, #48, #4, #16, #0xFF

_jug:
;DefinePlayer _name, _x, _y, _w, _h, _type, _sprite, _jumptbl_ptr, _velx, _dir
DefinePlayer player, #60, #60, #4, #16, #128, #0, #0, #0, #0

levels_buffer           = 0x0040
levels_buffer_max_size  = 0x0274
levels_buffer_end       = levels_buffer + levels_buffer_max_size - 1
levels_tileset          = levels_buffer + _mylevel_0_OFF_001


;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::
   
   ;;-------------------------------------------
   ;; Inicializar paleta, modo de video, etc...
   ;;-------------------------------------------
   
   ;; Disable firmware to prevent it from interfering with string drawing
   call cpct_disableFirmware_asm

   ld c, #1
   call cpct_setVideoMode_asm          ;;Destruye AF, BC, HL

   ld hl, #_g_palette
   ld de, #4
   call cpct_setPalette_asm            ;;Destruye AF, BC, DE, HL


   ld hl, #0x0B10
   call cpct_setPALColour_asm          ;;Destruye F, BC, HL

   ;;---------------------------
   ;; Dibujar mapa
   ;;---------------------------


   ;; Descomprimimos de memoria

   ld de, #levels_buffer_end
   ld hl, #_mylevel_0_end
   call cpct_zx7b_decrunch_s_asm



   ld c,    #_map_W
   ld b,    #_map_H
   ld de,   #_map_W
   ld hl,   #levels_tileset
   call cpct_etm_setDrawTilemap4x8_ag_asm ;; Elegimos el tileset para dibujar el mapa

   ;ld hl,   #0xC000
   ;ld de,   #levels_buffer
   ;call cpct_etm_drawTilemap4x8_ag_asm    ;; Dibujamos el mapa de tilesets entero


   ;ld hl,   #levels_tileset
   ;ld de,   #0xC000
   ;call cpct_drawTileAligned4x8_asm

   ld ix, #_jug
   ld b, #76
   ld c, #60

   call initializePlayer


   ;;---------------------------
   ;; Dibujar jugador         
   ;;---------------------------

   ;; Calculate a video-memory location for printing a string
   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   ld    b, de_y(ix)                  ;; B = y coordinate
   ld    c, de_x(ix)                  ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld l, dde_spr_l(ix)
   ld h, dde_spr_h(ix) 
   ld c, de_w(ix)
   ld b, de_h(ix)
   call cpct_drawSprite_asm            ;;Destruye AF, BC, DE, HL



   ;;---------------------------
   ;; Dibujar caja
   ;;---------------------------

   ld ix, #caja

   ;; Calculate a video-memory location for printing a string
   ld   de, #CPCT_VMEM_START_ASM ;; DE = Pointer to start of the screen
   ld    b, de_y(ix)                  ;; B = y coordinate
   ld    c, de_x(ix)                  ;; C = x coordinate

   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld a, de_type(ix)
   ld c, de_w(ix)
   ld b, de_h(ix)
   call cpct_drawSolidBox_asm ;; Destruye AF, BC, DE, HL


   ;; Loop forever
loop:
   jr    loop