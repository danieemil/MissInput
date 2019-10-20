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


DefineEntity caja, #78, #48, #1, #16, #0xFF

entities:
   .db #50, #65, #04, #100, #0x20
   .db #40, #76, #04, #80, #0x20
   .db #00, #192,#38, #08, #0x20
   .db #39, #192,#41, #08, #0x20
   .db #00, #00,#39, #08, #0x20
   .db #39, #00,#41, #08, #0x20
   .db #76, #08,#04, #95, #0x20
   .db #76, #103,#04,#89, #0x20
   .db #00, #08,#04, #95, #0x20
   .db #00, #103,#04, #89, #0x20
   .db #0x80

power_ups:
   .db #20, #99, #power_width, #power_height, #0x09
   .dw _power1_spr

   .db #50, #80, #power_width, #power_height, #0x00
   .dw _power1_spr

   .db #37, #170, #power_width, #power_height, #0x05
   .dw _power1_spr


   .db #0x80

DefinePlayer player, #50, #60, #4, #16, #128, #0, #0, #0, #0, #0, #0

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



   call vectorsLoader
   

   ;;---------------------------
   ;; Dibujar mapa
   ;;---------------------------


   ;; Descomprimimos de memoria

   ld de, #levels_buffer_end
   ld hl, #_mylevel_0_end
   call cpct_zx7b_decrunch_s_asm

   ;ld c,    #_map_W
   ;ld b,    #_map_H
   ;ld de,   #_map_W
   ;ld hl,   #levels_tileset
   ;call cpct_etm_setDrawTilemap4x8_ag_asm ;; Elegimos el tileset para dibujar el mapa

   ;ld hl,   #0xC000
   ;ld de,   #levels_buffer
   ;call cpct_etm_drawTilemap4x8_ag_asm    ;; Dibujamos el mapa de tilesets entero


   ;ld hl,   #levels_tileset
   ;ld de,   #0xC000
   ;call cpct_drawTileAligned4x8_asm

   ld ix, #player
   ld b, #50
   ld c, #60

   call initializePlayer


   ;;---------------------------
   ;; Dibujar cajas
   ;;---------------------------


   ld ix, #vector
   ld a, (v_num)
   ld bc, #de_size

   drawBox_loop:
      exx
      ex af, af'
      call drawBox
      ex af, af'
      exx

      add ix, bc

      dec a
   jr nz, drawBox_loop


   ;;---------------------------
   ;; Dibujar power-ups
   ;;---------------------------

   ld ix, #vectorPowers
   ld a, (vP_num)
   ld bc, #dde_size

   drawPower_loop:
      exx
      ex af, af'
      call drawSprite
      ex af, af'
      exx

      add ix, bc

      dec a
   jr nz, drawPower_loop




   ld ix, #player
   ;; Loop forever
loop:

   call drawBackground


   ld a, dp_counter(ix)
   cp #0
   jr z, input

      dec a
      ld dp_counter(ix), a

      ld a, dp_forcedDir(ix)
      jr no_input

   input:
   call inputManager
   no_input:
   
   call inputPlayer




   ;; Reseteamos los bits del walljump
   res 4, de_type(ix)
   res 5, de_type(ix)


   call playerMoveX

   ld iy, #vector
   ld a, (v_num)
   ld bc, #de_size
   call collisionBoxX_loop


   call playerMoveY

   ld iy, #vector
   ld a, (v_num)
   ld bc, #de_size
   call collisionBoxY_loop



   
   ld a, de_type(ix)
   push af

   ld iy, #vectorPowers ;;[14]
   ld a, (vP_num)       ;;[13]
   ld bc, #dde_size     ;;[10]
   call collisionEnt_loop

   pop af

   ;; Evitamos walljump con los power ups
   res 4, de_type(ix)
   res 5, de_type(ix)

   res 2, a

   or de_type(ix)
   ld de_type(ix), a






   call drawSprite

   
   call cpct_waitVSYNC_asm


   jr    loop


;;====================================================
;; Key Definitions:
;; Key_O       
;; Key_P        
;; Key_Space   
;;
;;
;;
;;====================================================
;;Definition: Controla las pulsaciones por teclado
;;Entrada:
;;Salida:
;; A     -> Teclas pulsadas
;;Destruye: A, BC, D, HL
;;====================================================
inputManager:


   call cpct_scanKeyboard_asm    ;;Destruye: AF, BC, DE, HL

   call cpct_isAnyKeyPressed_asm ;;Destruye: A, B, HL
      jr nz, key_pressed         ;;Es 0
      xor a                      ;; Ponemos A a 0
      ret

   key_pressed:
   xor a                         ;; Ponemos A a 0
   ex af, af'

   check_left:
   ld a, de_x(ix)                ;; Comprobamos que no se pasa por el borde izquierdo
   cp #0
   jr z, check_right

   ld hl, #Key_O
   call cpct_isKeyPressed_asm    ;;Destruye: A, BC, D, HL
   jr z, check_right
      ex af, af'
      add a, #1
      ex af, af'


   check_right:
   ;;@quiquesoyyo dijo quitar
   ld a, de_x(ix)                ;; Comprobamos que no se pasa por el borde derecho
   cp #0x4C
   jr z, check_jump

   ld hl, #Key_P
   call cpct_isKeyPressed_asm    ;;Destruye: A, BC, D, HL
   jr z, check_jump
      ex af, af'
      add a, #2
      ex af, af'

   check_jump:
   ld hl, #Key_Space
   call cpct_isKeyPressed_asm    ;;Destruye: A, BC, D, HL
   jr z, final_input
      ex af, af'
      add a, #4
      ret

   final_input:
   ex af, af'

   

ret


;;====================================================
;;Definition: Carga datos en un vector
;;Entrada:
;;Salida:
;;Destruye: A, BC, DE, HL
;;====================================================
vectorsLoader:


   ld hl, #entities

   ent_loop:
   
      ld a, (hl)
      cp #0x80
      jr z, load_power_ups

      ex de, hl
      call ent_new_default
      ex de, hl
      push hl

      call ent_copy
      pop hl

      ld bc, #de_size
      add hl, bc

   jr #ent_loop


   load_power_ups:

   ld hl, #power_ups

   power_loop:
   
      ld a, (hl)
      cp #0x80
      ret z

      ex de, hl
      call power_new_default
      ex de, hl
      push hl

      call power_copy
      pop hl

      ld bc, #dde_size
      add hl, bc

      jr #power_loop


ret


;;===============================================================================
;;Definition: Detecta colisiones entre un vector y el personaje al moverse en X
;;Entrada:
;; IX -> Jugador
;; IY -> Vector
;; A  -> Tamaño ACTUAL del vector
;; BC -> Tamaño de cada elemento del vector
;;Salida:
;;Destruye: A, IY
;;===============================================================================
collisionBoxX_loop:
   exx
   ex af, af'
   
   res 4, de_type(iy)
   ld c, #0
   call detectCollisionX

   ld a, c
   cp #1
   jr nz, noCollisionBoxX
   call pl_fixX
   noCollisionBoxX:

   ex af, af'
   exx

   add iy, bc

   dec a

   jr nz, collisionBoxX_loop
ret



;;===============================================================================
;;Definition: Detecta colisiones entre un vector y el personaje al moverse en Y
;;Entrada:
;; IX -> Jugador
;; IY -> Vector
;; A  -> Tamaño ACTUAL del vector
;; BC -> Tamaño de cada elemento del vector
;;Salida:
;;Destruye: A, IY
;;===============================================================================
collisionBoxY_loop:
      exx
      ex af, af'
      

      bit 4, de_type(iy)
      jr nz, no_collisionY


      call collisionY

      ld a, c
      cp #1
      jr nz, noCollisionBoxY
      call pl_fixY
      noCollisionBoxY:

      no_collisionY:

      ex af, af'
      exx

      add iy, bc

      dec a

   jr nz, collisionBoxY_loop
ret



;;===============================================================================
;;Definition: Detecta colisiones entre un vector y el personaje
;;Entrada:
;; IX -> Jugador
;; IY -> Vector
;; A  -> Tamaño ACTUAL del vector
;; BC -> Tamaño de cada elemento del vector
;;Salida:
;;Destruye: A, IY
;;===============================================================================
collisionEnt_loop:

   ;; Si está inhabilitado pasamos a la siguiente entidad
   bit 5, de_type(iy)
   jr nz, next_Ent

   exx
   ex af, af'
   
   res 4, de_type(iy)
   ld c, #0
   call detectCollisionX

   ld a, c
   cp #1
   jr nz, noCollisionEnt

      ld a, de_type(iy)
      
      ;; Puede matar??!!
      check_mortal:
      bit 1, a
      jr z, check_gatherable

         ;jp die

      ;; Se puede coger?
      check_gatherable:
      bit 0, a
      jr z, check_type

         set 5, de_type(iy)

      ;; T _ T 
      check_type:
      and #12

      ;;Gravedad hacia abajo?
      check_gDown:
      cp a, #8
      jr nz, check_gUP

      bit 2, de_type(ix)
      jr z, noCollisionEnt

         call pl_setJumptableOnGravity
         res 2, de_type(ix)

      jr noCollisionEnt


      ;;Gravedad hacia arriba?
      check_gUP:
      cp a, #4
      jr nz, check_doubleJump

      bit 2, de_type(ix)
      jr nz, noCollisionEnt

         call pl_setJumptableOnGravity
         set 2, de_type(ix)
      
      jr noCollisionEnt

      check_doubleJump:
      cp a, #00
      jr nz, end_level

      set 3, de_type(ix)


      ;;Fin del nivel
      ;jp z, end_level




   noCollisionEnt:

   ex af, af'
   exx

   next_Ent:

   add iy, bc

   dec a

   jr nz, collisionEnt_loop
ret



end_level:
   jr .
ret