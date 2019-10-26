.include "enemy.h.s"

;; Macros

.macro DefinePlayer _name, _x, _y, _w, _h, _type, _sprite, _jumptbl_ptr, _vel, _dir, _counter, _forced_dir
_name:
    DefineDrawableEntity _name'_dde, _x, _y, _w, _h, _type, _sprite
    .dw _jumptbl_ptr    ;;Puntero a la posición actual de la tabla de saltos
    .db _vel            ;;Cantidad de ciclos por movimiento(No puede ser negativa)
    .db _dir            ;;Dirección del jugador, <--- Izquierda o Derecha --->
    .db _counter        ;;Este contador inhabilita las pulsaciones por teclado cuando no es 0
    .db _forced_dir     ;;Indica la dirección en la que se moverá el jugador durante _counter
                        ;;Valores: #5->Izquierda y salto, #6->Derecha y salto
    _name'_size = . - _name
.endm

;; Macro positions


dp_jump_l   = 0 + dde_size
dp_jump_h   = 1 + dde_size
dp_vel      = 2 + dde_size
dp_dir      = 3 + dde_size
dp_counter  = 4 + dde_size
dp_forcedDir= 5 + dde_size
dp_size     = 6 + dde_size



;; Constantes

player_vel_max  = 5
player_width    = 4
player_height   = 16



jp_start    = 0    ;;Posición en la tabla cuando se inicia el salto
jp_extra    = 8    ;;Posición en la tabla como interpolación para el salto progresivo
jp_floorCol = 11   ;;Posición en la tabla cuando colisiona con el suelo
jp_wallCol  = 11   ;;Posición en la tabla cuando colisiona con la pared
jp_end      = 20   ;;Posición en la tabla cuando caes a velocidad máxima

;jp_start    = 0    ;;Posición en la tabla cuando se inicia el salto
;jp_extra    = 6    ;;Posición en la tabla como interpolación para el salto progresivo
;jp_floorCol = 9   ;;Posición en la tabla cuando colisiona con el suelo
;jp_wallCol  = 9   ;;Posición en la tabla cuando colisiona con la pared
;jp_end      = 18   ;;Posición en la tabla cuando caes a velocidad máxima



;; Globls
    ;;Dependencias
    .globl _player_spr_01
    
    .globl player


    ;;Funciones
    .globl initializePlayer
    .globl inputPlayer
    .globl playerMoveX
    .globl playerMoveY
    .globl pl_fixX
    .globl pl_fixY
    .globl pl_setJumptable
    .globl pl_setJumptableOnGravity
    .globl drawPlayer


;Flags del jugador(almacenados en la variable _type de entidad)
;Estos flags solo se corresponden si el primer bit está activo
;
;7   I -> Sá pulsao salto?
;6   S -> Colisiona con suelo? (1=suelo 0=aire)
;5   D -> Colisiona con pared_derecha?
;4   I -> Colisiona con pared_izquierda?
;3   P -> Power-up de doble salto?
;2   G -> Gravedad?
;1   M -> Muerte?
;0   D -> Direction (1-> Left, 0 -> Right)
;
;I S D I P G M D
;1 0 0 0 0 0 0 0