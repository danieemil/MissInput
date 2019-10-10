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





;;====================================================
;;Definition: Actualiza al jugador 
;;Entrada:
;;  IX  ->  Puntero que contiene al jugador
;;  A   ->  Acción del jugador(moverse, saltar)
;;Salida:
;;Destruye: HL,
;;====================================================
;;
;;Orden de físicas del player
;;1º Analizamos el input
;;2º Mover en x
;;3º Comprobamos colisiones
;;4º Corregimos en x
;;5º Mover en y
;;6º Comprobamos colisiones
;;7º Corregimos en y
;;8º Dibujamos y muerte en ciclos
;;
;;====================================================
updatePlayer:


    ld dp_dir(ix), #0
    bit 0, a
    jr nz, check_right
        dec dp_dir(ix)
        

    check_right:
    bit 1, a
    jr nz, check_jump
        inc dp_dir(ix)
        

    check_jump:
    ;Colisiones
    bit 2, a
    jr nz, end
        ld a, de_type(ix)
        bit 6, a
        call z, jump

    end:

    call move


ret



;;====================================================
;;Definition: Controla el movimiento del personaje
;;Entrada: 
;;Salida:
;;Destruye:
;;====================================================
move:
    ld a, de_x(ix)
    ld b, dp_dir(ix)
    sla b   ;; Esto hace que se mueva el doble de rápido ;/
    sub a, b
    ld de_x(ix), a

ret



;;====================================================
;;Definition: Inicia el salto
;;Entrada:
;;Salida:
;;Destruye:
;;====================================================
jump:


ret