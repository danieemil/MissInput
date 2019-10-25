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
.include "level_data.h.s"



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


                  ;;=============================;;
                  ;;TODAS LAS ENTIDADES DEL JUEGO;;
                  ;;=============================;;

;;Jugador
DefinePlayer player, #12, #144, #4, #16, #128, #0, #0, #0, #0, #0, #0

;;Entidades de colisión
ReserveVector Ventities, de_size, 20

;;Entidades especiales
ReserveVector Ventities2, de_size, 20

;;Power-ups
ReserveVector Vpowers, dde_size, 4

;;Enemigos
ReserveVector Venemies, dE_size, 4



;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;
_main::
   
   ;;-------------------------------------------
   ;; Inicializar paleta, modo de video, etc...
   ;; Solo se hace una vez, al iniciar el juego
   ;;-------------------------------------------
   ld sp, #0x8000


   call cpct_disableFirmware_asm

   call initBuffers

   ld c, #1
   call cpct_setVideoMode_asm          ;;Destruye AF, BC, HL

   ld hl, #_g_palette
   ld de, #4
   call cpct_setPalette_asm            ;;Destruye AF, BC, DE, HL

   ld hl, #0x0B10
   call cpct_setPALColour_asm          ;;Destruye F, BC, HL
   

   ;; Descomprimimos el mapa y tileset de memoria
   ld de, #levels_buffer_end
   ld hl, #_mylevel_0_end
   call cpct_zx7b_decrunch_s_asm
   

   ;;En este método preparámos el nivel para que sea jugable
   call initializeLevel


   ;;------------
   ;;Dibujar mapa
   ;;------------

   ;ld a, (_backbuffer)
   ;ld d, a
   ;ld e, #00
   ;ld hl, #levels_buffer
   ;ld bc, #500
   ;call draw_tilemap
   
   ;ld hl, #0x8000
   ;ld de, #0xC000
   ;ld bc, #0x4000
   ;ldir


ld ix, #player

main_loop:

   bit 1, de_type(ix)
   call nz, initializeLevel

   ;; Clear player
   ld d, dde_preX(ix)
   ld a, de_w(ix)
   add d
   ld e, a
   ld b, dde_preY(ix)
   ld a, de_h(ix)
   add b
   call redrawTiles

   ld iy, #Vpowers
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)  
   call cleanVector

   ld iy, #Venemies
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)
   call cleanVector


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

   ld iy, #Ventities
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)  
   call collisionBoxX_loop


   call playerMoveY

   ld iy, #Ventities
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)  
   call collisionBoxY_loop

   ld a, de_type(ix)
   push af



   ;; Colisiones de los power-ups
   ld iy, #Vpowers
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)  
   call collisionEnt_loop

   ;; Colisiones de las entidades especiales :/
   ld iy, #Ventities2
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)  
   call collisionEnt_loop

   update_enemies:
   ld iy, #Venemies
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)
   call enemy_updateAll

   ld iy, #Venemies
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)
   call collisionEnt_loop


   pop af

   ;; Evitamos walljump con los power ups
   res 4, de_type(ix)
   res 5, de_type(ix)

   res 2, a

   or de_type(ix)
   ld de_type(ix), a


   and #0x30
   jr z, draw

      ;; Wallride
      ld de, #jp_wallCol
      call pl_setJumptable


   draw:

   ld iy, #Vpowers
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)   
   call drawPowerUpVector

   ld iy, #Venemies
   ld a, vector_n(iy)
   ld b, #0
   ld c, vector_s(iy)
   call drawEnemyVector

   ld iy, #player
   ;call drawSprite
   ;call drawSpriteMasked
   call drawPlayer
   ld ix, #player

   
   
   call switchBuffers
   call cpct_waitVSYNC_asm


jp  main_loop


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

         set 1, de_type(ix)
         ret

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
      jp nz, end_level

      set 3, de_type(ix)


   noCollisionEnt:

   ex af, af'
   exx

   next_Ent:

   add iy, bc

   dec a

   jr nz, collisionEnt_loop
ret

end_level:
   jp initializeLevel
ret




;;===============================================================================
;;Definition: Carga datos de múltiples elementos en un vector
;;Entrada:
;; HL -> Datos
;; DE -> Vector
;;Salida:
;;Destruye: A, BC, DE, HL
;;===============================================================================
vectorloader:

   ;; Cargamos en BC el tamaño de cada elemento del vector
   push de
   ex de, hl

   dec hl
   dec hl
   dec hl
   dec hl
   ld b, #0
   ld c, (hl)

   ex de, hl
   pop de

   load_loop:
   
   ld a, #end_of_data
   cp (hl)
   jr z, end_load

   ;; Pasamos los datos al vector
   push hl
   push de
   push bc
   ex de, hl
   call new_elem
   ex de, hl
   pop bc
   pop de
   pop hl
   

   add hl, bc
   jr load_loop

   end_load:
   
ret


;;===============================================================================
;;Definition: Reinicia un nivel con los datos hay en memoria
;;Entrada:
;;Salida:
;;Destruye: AF, BC, DE, HL
;;===============================================================================
initializeLevel:

;; Reiniciamos al jugador
   ld ix, #player
   ld b, #12
   ld c, #144
   call initializePlayer


;; Reiniciamos todos los vectores a los valores por defecto
   ld hl, #enemies
   ld de, #Venemies
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader

   ld hl, #entities
   ld de, #Ventities
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader

   ld hl, #special_entities
   ld de, #Ventities2
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader

   ld hl, #power_ups
   ld de, #Vpowers
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader


   ;;------------------------------------------------------------------
   ;; Dibujamos mapa en el backbuffer
   ;;------------------------------------------------------------------
   ld a, (_backbuffer)
   ld d, a
   ld e, #00
   ld hl, #levels_buffer
   ld bc, #500
   call draw_tilemap

   ;; Copiamos del backbuffer al frontbuffer
   ld hl, (_frontbuffer)
   ld d, l
   ld l, #0
   ld e, #0
   ld bc, #0x4000
   ldir

ret





;;====================================================
;;Definition: Dibuja el tilemap entero
;;
;; IMPORTANTE: Asume que el tileset seimpre va a ser el mismo para toda la ejecución (levels_tileset)
;;
;;Entrada:
;;  BC -> Tamaño del tilemap en tiles (si es de 4x4, BC valdrá 16)
;;  HL -> Apunta al inicio del tilemap
;;  DE -> Apunta al inicio de la memoria de video
;;Salida:
;;
;;
;;  
;;Destruye: AF, BC, DE, HL
;;====================================================
draw_tilemap:

   push bc
   ld a, (hl)
   ld bc, #0032
   push hl
   ld hl, #_tileset_00


   cp a, #0
   jr z, draw_tilemap_loop_end
   draw_tilemap_loop:
      add hl, bc
      dec a
   jr nz, draw_tilemap_loop
   draw_tilemap_loop_end:

   push de
   call cpct_drawTileAligned4x8_asm       ;; se lo carga toh
   pop de
   pop hl

   inc hl
   ld bc, #0004
   ex de, hl
   add hl, bc
   ex de, hl

   pop bc
   dec bc
   ld a, b
   or c
   jr nz, draw_tilemap

ret
