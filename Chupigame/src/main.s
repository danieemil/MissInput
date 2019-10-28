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
.include "bins/ambient_sound.h.s"
.include "bins/effects.h.s"

.globl _reference01
.globl _reference02



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

;;Referencias a Astro Marine Corps
DefineDrawableEntity reference01, #00, #00, #12, #7, #00, _reference01
DefineDrawableEntity reference02, #00, #00, #16, #7, #00, _reference02
reference_counter: .db #00 ;;Indica cada cuante se aplica el movimiento a las referencias

const_reference_counter = 3

actual_level: .db  #00
death_counter: .db #10


death_sound: .db #00
power_up_sound: .db #00


ambient_frequency = #11
ambient_speed: .db #00



;;==============================================================================
;; ATENCIÓN:
;; Este código se ejecuta en paralelo a nuestro código, y cada vez
;; que ocurre una interrupción. Si se destruye AF', BC', DE', HL' o IY, PETARÁ  
;;
;; Yo lo uso para la música, pero también se pueden poner el escaneo de
;; pulsaciones del teclado para mayor control del personaje, hay una función
;; específica para esto...
;;==============================================================================
interruption_handler:

   ex af, af'
   exx
   push af
   push bc
   push de
   push hl
   push iy
   push ix

   ;; Música ambiente
   ld a, (ambient_speed)
   cp #0
   jr z, playing_now

      dec a
      jr not_playing_now

   playing_now:
   call cpct_akp_musicPlay_asm
   ld a, #ambient_frequency

   not_playing_now:
   ld (ambient_speed), a


   ;; Efectos de sonido
   ;; Si ya hay algún sonido sonando, no toques nada
   
   call cpct_akp_SFXGetInstrument_asm
   ld h, a
   and l
   cp #0
   jr nz, sound_playing


   check_death_sound:
   ld a, (death_sound)
   cp #0
   jr z, check_jump_sound

      ;; Paramos la reproducción de efectos de sonido en el canal 1
      ;; para poder hacer sonar la muerte del jugador sin interferencias
      ld a, #1
      call cpct_akp_SFXStop_asm
      
      ;; Reproducimos a la muerte sonificada ;/
      ld l, #1       ;; Instrumento
      ld h, #15      ;; Volumen(15 -> max)
      ld e, #24      ;; Nota (24 -> C-2)
      ld d, #0       ;; (1-255), 0 = original
      ld bc, #0      ;; Pitch (más pitch, más grave)
      ld a, #1       ;; Canal, bit-flag, tres bits de derecha (C1->001, C2->010, C3->100)
      call cpct_akp_SFXPlay_asm

      xor a
      ld (death_sound), a
      jr sound_playing

   check_jump_sound:
   ld a, (jump_sound)
   cp #0
   jr z, check_power_up_sound

      ;; Reproducimos el salto/doble salto

      ld l, #2       ;; Instrumento
      ld h, #15      ;; Volumen(15 -> max)
      ld e, #48      ;; Nota (48 -> C-4, Do4)
      ld d, #0       ;; (1-255), 0 = original
      ld bc, #0      ;; Pitch (más pitch, más grave)
      ld a, #1       ;; Canal, bit-flag, tres bits de derecha (C1->001, C2->010, C3->100)
      call cpct_akp_SFXPlay_asm

      xor a
      ld (jump_sound), a
      jr sound_playing

   check_power_up_sound:
   ld a, (power_up_sound)
   cp #0
   jr z, sound_playing

      ;; Reproducimos el salto/doble salto
      ld l, #2       ;; Instrumento
      ld h, #15      ;; Volumen(15 -> max)
      ld e, #64      ;; Nota (64 -> E-5, Mi5)
      ld d, #1       ;; Velocidad (1-255), 0 = original
      ld bc, #0      ;; Pitch (más pitch, más grave)
      ld a, #3       ;; Canal, bit-flag, tres bits de derecha (C1->001, C2->010, C3->100)
      call cpct_akp_SFXPlay_asm

      xor a
      ld (power_up_sound), a
      jr sound_playing

   sound_playing:

   pop ix
   pop iy
   pop hl
   pop de
   pop bc
   pop af
   exx
   ex af, af'


ret


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

   ld c, #1
   call cpct_setVideoMode_asm          ;;Destruye AF, BC, HL

   ld hl, #_g_palette
   ld de, #4
   call cpct_setPalette_asm            ;;Destruye AF, BC, DE, HL

   ld hl, #0x0B10
   call cpct_setPALColour_asm          ;;Destruye F, BC, HL

   ;; Inicializamos la música
   ld de, #_ambient
   call cpct_akp_musicInit_asm

   ld de, #_effects
   call cpct_akp_SFXInit_asm

   ;;HL -> Qué método hará cada vez que salte una interrupción
   ld hl, #interruption_handler
   call cpct_setInterruptHandler_asm

   call initBuffers

   

   ;;En este método preparámos DEL TODO el nivel para que sea jugable
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
   call nz, deathLoop

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

   ld a, de_type(ix)
   and #0x30
   jr z, free
      ld a, dp_counter(ix)
      cp #11
      jp p, free

         ld dp_counter(ix), #0

   free:

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

   cp #0
   ret z


   not_cel_empty:
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
         
         ex af, af'

         ld a, #1
         ld (power_up_sound), a
      
         ex af, af'

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

   jr nz, not_cel_empty
ret

end_level:
   ld a, (actual_level)
   inc a
   ld (actual_level), a

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
   inc hl
ret


;;===============================================================================
;;Definition: Reinicia un nivel con los datos hay en memoria
;;Entrada:
;; HL -> Datos del nivel
;;Salida:
;;Destruye: AF, BC, DE, HL
;;===============================================================================
initializeLevel:



   ld hl, #levels
   ld a, (actual_level)
   ld d, #0
   ld e, a
   add hl, de
   add hl, de
   ld e, (hl)
   inc hl
   ld d, (hl)
   ex de, hl
   ld a, h
   or l
   jr nz, start_decrunch
      ld hl, #lvl_01
      ld a, #00
      ld (actual_level), a
   start_decrunch:

   push hl

   ld de, #4
   call cpct_setPalette_asm            ;;Destruye AF, BC, DE, HL

   pop hl
   ld de, #4
   add hl, de


   ;; .dw _level_XX_end en HL
   ld e, (hl)
   inc hl
   ld d, (hl)
   inc hl
   push hl
   ex de, hl

   ;; Descomprimimos el mapa de memoria
   ld de, #levels_buffer_end
   call cpct_zx7b_decrunch_s_asm

   pop hl
   

   ;; BC -> X e Y de la posicion del jugador
   ld ix, #player
   ld b, (hl)
   inc hl
   ld c, (hl)
   inc hl

   push hl

;; Reiniciamos al jugador

   call initializePlayer

   pop hl

;; Reiniciamos todos los vectores a los valores por defecto

   
   
   ld de, #Ventities
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader

   ld de, #Ventities2
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader

   ld de, #Vpowers
   push hl
   push de
   ex de, hl
   call vector_reset
   pop de
   pop hl
   call vectorloader

   ld de, #Venemies
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




deathLoop:

   ld a, (death_counter)
   dec a
   jr nz, no_set_references

      
      ex af, af'
      
      ld ix, #player     ;;<-- Quitar una vez funcione para ver que pasa
      ld iy, #reference01
      ld a, de_x(ix)
      sub a, #04
      cp #0
      jp p, rf01_set_coordinates
         ld a, #0
      rf01_set_coordinates:
      ld de_x(iy), a
      ld a, de_y(ix)
      add a, de_h(ix) 
      ld de_y(iy), a

      ex af, af'

   no_set_references:
   ld (death_counter), a

   ld a, #1
   ld (death_sound), a

   ld iy, #player
   ld hl, #_player_die
   ld a, #1

   dloop:
   push af
   push hl
   ;; Clear player
   ld iy, #player
   ld d, dde_preX(iy)
   ld a, de_w(iy)
   add d
   ld e, a
   ld b, dde_preY(iy)
   ld a, de_h(iy)
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

   ld a, de_x(iy)
   ld dde_preX(iy), a
   ld a, de_y(iy)
   ld dde_preY(iy), a

   pop hl
   ld a, (hl)
   inc hl
   ld b, (hl)
   dec hl  
   or b
   jr nz, continue_dloop

      pop af
      dec a
      push af
      push hl

      jr check_end_dloop

   continue_dloop:
   
   ld a, dde_animTime(iy)
   cp #0
   jr nz, draw_dloop

   ld dde_animTime(iy), #animTimeConstPlayer
   ;ld hl, #_player_die
   ld a, (hl)
   ld dde_spr_l(iy), a
   inc hl
   ld a, (hl)
   ld dde_spr_h(iy), a
   inc hl
   

   draw_dloop:
   push hl
   dec dde_animTime(iy)

   bit 2, de_type(iy)
   jr z, draw_dloop_normal

   call drawSpriteMaskedFlipped
   jr check_end_dloop

   draw_dloop_normal:
   call drawSpriteMasked


   check_end_dloop:

   ld a, (death_counter)
   cp #0
   jr nz, no_draw_references

      ld a, #10
      ld(death_counter), a
      call drawReferences

   no_draw_references:

   call switchBuffers
   call cpct_waitVSYNC_asm

   pop hl
   pop af   

jp nz, dloop

   jp initializeLevel         ;; Salida del metodo






;;====================================================
;;Definition: Dibuja las referencias
;;Entrada:
;;  IY = Puntero a la referencia
;;
;;Salida:
;;
;;Destruye: AF, BC, DE, HL
;;====================================================
drawReferences:


ret