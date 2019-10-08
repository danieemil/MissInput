.include "player.h.s"


_jumptable:
    .db  -5, -5, -3, -3, -1, -1, 0, 1, 1, 2, 3, 3, 5, 5, 128

;;====================================================
;;Definition: Inicializa los valores del jugador 
;;Entrada: 
;;  IX  ->  Puntero que contiene al jugador
;;  B   ->  Posición en x del jugador
;;  C   ->  Posición en y del jugador
;;Salida:
;;  IX  ->  Jugador con sus datos actualizados
;;Destruye: HL,
;;====================================================
initializePlayer:
    
    ;; Seteamos posición
    ld de_x(ix), b
    ld de_y(ix), c

    ;; Seteamos su tamaño
    ld de_w(ix), #player_width
    ld de_h(ix), #player_height

    ;; Seteamos su estado
    ld de_type(ix), #128

    ;; Seteamos sprite
    ld hl,#_player_spr
    ld dde_spr_l(ix), l
    ld dde_spr_h(ix), h

    ;; Seteamos su tabla de saltos
    ld hl, #_jumptable
    ld dp_jump_l(ix), l
    ld dp_jump_h(ix), h

    ;; Seteamos su velocidad
    ld dp_vel(ix), #0

    ;; Seteamos su dirección
    ld dp_dir(ix), #0

ret