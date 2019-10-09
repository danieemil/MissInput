.include "render.h.s"

;; Macros

.macro DefinePlayer _name, _x, _y, _w, _h, _type, _sprite, _jumptbl_ptr, _vel, _dir
_name:
    DefineDrawableEntity _name'_dde, _x, _y, _w, _h, _type, _sprite
    .dw _jumptbl_ptr    ;;Puntero a la posición actual de la tabla de saltos
    .db _vel            ;;Cantidad de ciclos por movimiento(No puede ser negativa)
    .db _dir            ;;Dirección del jugador, <--- Izquierda o Derecha --->
    _name'_size = . - _name
.endm

;; Macro positions

dde_size    = 7
dp_jump_l   = 0 + dde_size
dp_jump_h   = 1 + dde_size
dp_vel      = 2 + dde_size
dp_dir      = 3 + dde_size



;; Constantes

player_vel_max  = 5
player_width    = 4
player_height   = 16


;; Globls
    ;;Dependencias
    .globl _player_spr



    ;;Funciones
    .globl initializePlayer
    .globl updatePlayer


;Flags del jugador(almacenados en la variable _type de entidad)
;Estos flags solo se corresponden si el primer bit está activo
;
;7   J -> Jugador?
;6   S -> Colisiona con suelo?
;5   D -> Colisiona con pared_derecha?
;4   I -> Colisiona con pared_izquierda?
;3   P -> Power-up de doble salto?
;2   G -> Gravedad?
;1   M -> Muerte
;0   D -> Direction (1-> Left, 0 -> Right)
;
;J S D I P G M D
;1 0 0 0 0 0 0 0