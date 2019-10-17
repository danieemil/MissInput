.include "player.h.s"


;; Tabla de saltos, nos permite simular la gravedad
_jumptable:
    .db  -12, -9, -7, -5, -4, -3, -1, -1, 0, 1, 1, 1, 1, 1, 3, 3, 3, 4, 0x80

jp_start    = #0   ;;Posición en la tabla cuando se inicia el salto
jp_floorCol = #8    ;;Posición en la tabla cuando colisiona con el suelo
jp_wallCol  = #9    ;;Posición en la tabla cuando colisiona con la pared

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
    ld bc, #8
    add hl, bc
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
;;3º Comprobamos colisiones para todos los objetos
;;      - Si C es -1:
;;        Hacemos que esta entidad solo ejecute el paso 5º
;;      - Si C es  0:
;;        Hacemos que esta entidad se salte el paso 4º 
;;      - Si C es  1:
;;        Hacemos que esta entidad ejecute todos los pasos
;;4º Corregimos en x
;;5º Mover en y
;;6º Comprobamos colisiones ¿solo en Y? para todos los objetos
;;      - Si C es 0 o -1:
;;        Hacemos que esta entidad se salte el paso 7º
;;      - Si C es  1:
;;        Hacemos que esta entidad ejecute el siguiente paso
;;7º Corregimos en y
;;
;;====================================================
inputPlayer:


    ld dp_dir(ix), #0
    bit 0, a
    jr z, check_right
        dec dp_dir(ix)

    check_right:
    bit 1, a
    jr z, check_jump
        inc dp_dir(ix)
        

    check_jump:
    bit 2, a
    jr z, end
        ld a, de_type(ix)
        bit 6, a
        jp nz, jump

    end:
ret



;;====================================================
;;Definition: Controla el movimiento del personaje en X
;;Entrada: IX -> Apunta al jugador
;;Salida:
;;Destruye: A, B
;;====================================================
playerMoveX:
    ld a, de_x(ix)
    ld b, dp_dir(ix)
    add a, b
    ld de_x(ix), a

    end_playerMoveX:
ret


;;=====================================================
;;Definition: Controla el movimiento del personaje en Y
;;Entrada: IX -> Apunta al jugador
;;Salida: 
;;Destruye: A, BC, HL
;;=====================================================
playerMoveY:

    ld a, de_y(ix)
    ld h, dp_jump_h(ix)
    ld l, dp_jump_l(ix)
    add a, (hl)

    ld de_y(ix), a

    res 6, de_type(ix)

    inc hl
    ld a, #0x80

    cp a, (hl)
    ret z

    ld dp_jump_h(ix), h
    ld dp_jump_l(ix), l
    
ret

;;====================================================
;;Definition: Inicia el salto
;;Entrada: IX -> Apunta al jugador
;;Salida:
;;Destruye: A, BC, HL
;;====================================================
jump:

    ld hl, #_jumptable

    ld dp_jump_l(ix), l
    ld dp_jump_h(ix), h

ret


;;====================================================
;;Definition: Corrige X frente a una colision
;;Entrada:
;;  IX  ->  Player
;;  IY  ->  Entidad
;;Salida:
;;Destruye:
;;====================================================
pl_fixX:

    ld a, dp_dir(ix)        ;; P = Player    C = Colision
    cp #-1                    ;; P se mueve a la derecha?
    jr z, pl_fixX_left     ;; P -> Izquierda  ||  C -> Derecha

        ld a, de_x(iy)      ;; Cargamos Cx
        sub de_w(ix)        ;; Restamos Pw
        ld de_x(ix), a      ;; Px = (Cx-Pw)
        ;;set 5, de_type(ix)    ;; Marca el flag de colision con pared derecha (Walljump)
        ret

    pl_fixX_left:

        ld a, de_x(iy)      ;; Cargamos Cx
        add de_w(iy)        ;; Sumamos  Cw
        ld de_x(ix), a      ;; Px = (Cx+Cw)
        ;;set 4, de_type(ix)    ;; Marca el flag de colision con pared izquierda (Walljump)
        ret



;;====================================================
;;Definition: Corrige Y frente a una colision
;;Entrada:
;;  IX  ->  Player
;;  IY  ->  Entidad
;;Salida:
;;Destruye: A, B
;;====================================================
pl_fixY:

    ld h, dp_jump_h(ix)
    ld l, dp_jump_l(ix)

    ld a, (hl)
    cp #1
    jp m, check_roof

    check_floor:
    ld a, de_y(iy)
    ld b, de_h(ix)
    sub a, b

    ld de_y(ix), a
    set 6, de_type(ix)

    ld hl, #_jumptable
    ld a, #-1
    cp a, (hl)
    ret z

    ld bc, #jp_floorCol
    add hl, bc

    ld dp_jump_h(ix), h
    ld dp_jump_l(ix), l

    ret

    check_roof:
    ld a, de_y(iy)
    ld b, de_h(iy)
    add a, b

    ld de_y(ix), a

ret