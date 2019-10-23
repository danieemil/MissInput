.include "player.h.s"

DefinePlayer player, #12, #152, #4, #16, #128, #0, #0, #0, #0, #0, #0

;; Tabla de saltos, nos permite simular la gravedad
_jumptable:
    .db -12, -9, -7, -5, -4, -3, -1, -1, 0, 1, 1, 1, 1, 1, 3, 3, 3, 4, 0x80

;;====================================================
;;Definition: Inicializa los valores del jugador 
;;Entrada: 
;;  IX  ->  Puntero que contiene al jugador
;;Salida:
;;  IX  ->  Jugador con sus datos actualizados
;;Destruye: HL,
;;====================================================
initializePlayer:

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
        bit 7, de_type(ix)
        call z, jump
        set 7, de_type(ix)
        ret
    end:
    res 7, de_type(ix)
    
ret



;;====================================================
;;Definition: Controla el movimiento del personaje en X
;;Entrada: IX -> Apunta al jugador
;;Salida:
;;Destruye: A, B
;;====================================================
playerMoveX:

    ld a, de_y(ix)
    ld dde_preY(ix), a

    ld a, de_x(ix)
    ld dde_preX(ix), a

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

    
    ld h, dp_jump_h(ix)
    ld l, dp_jump_l(ix)

    bit 7, de_type(ix)
    jr nz, check_limit

        ld a, #-1
        cp (hl)
        jp m, check_limit
        jr z, check_limit   ;; Si quitas esto pasan cosas... ;/

        ld hl, #_jumptable
        ld bc, #jp_extra
        add hl, bc

        jr save_jump_ptr



    check_limit:

    ld a, de_y(ix)

    bit 2, de_type(ix)
    jr z, add_a

    sub a, (hl)
    jr save_a

    add_a:
    add a, (hl)
    
    save_a:
    ld de_y(ix), a

    res 6, de_type(ix)

    increment:
    inc hl

    check_true_limit:
    ld a, #0x80

    cp a, (hl)
    ret z





    save_jump_ptr:
    ld dp_jump_h(ix), h
    ld dp_jump_l(ix), l
    
    
ret

;;====================================================
;;Definition: Inicia el salto
;;Entrada: IX -> Apunta al jugador
;;Salida:
;;Destruye: B, HL
;;====================================================
jump:

    ld b, de_type(ix)
    bit 6, b
    jr nz, init_jump

    check_wallRight:
    bit 5, b
    jr z, check_wallLeft

    ld dp_counter(ix), #10
    ld dp_forcedDir(ix), #5
    jr init_jump


    check_wallLeft:
    bit 4, b
    jr z, check_doubleJump

    ld dp_counter(ix), #10
    ld dp_forcedDir(ix), #6
    jr init_jump

    check_doubleJump:
    bit 3, b
    ret z

    init_jump:
    ld hl, #_jumptable

    ld dp_jump_l(ix), l
    ld dp_jump_h(ix), h

    res 3, de_type(ix)


ret


;;====================================================
;;Definition: Corrige X frente a una colision
;;Entrada:
;;  IX  ->  Player
;;  IY  ->  Entidad
;;Salida:
;;Destruye: A
;;====================================================
pl_fixX:

    ld a, dp_dir(ix)        ;; P = Player    C = Colision
    cp #-1                    ;; P se mueve a la derecha?
    jr z, pl_fixX_left     ;; P -> Izquierda  ||  C -> Derecha

        ld a, de_x(iy)      ;; Cargamos Cx
        sub de_w(ix)        ;; Restamos Pw
        ld de_x(ix), a      ;; Px = (Cx-Pw)
        set 5, de_type(ix)    ;; Marca el flag de colision con pared derecha (Walljump)
        ld de, #jp_wallCol
        jp pl_setJumptable

    pl_fixX_left:

        ld a, de_x(iy)      ;; Cargamos Cx
        add de_w(iy)        ;; Sumamos  Cw
        ld de_x(ix), a      ;; Px = (Cx+Cw)
        set 4, de_type(ix)    ;; Marca el flag de colision con pared izquierda (Walljump)
        ld de, #jp_wallCol
        jp pl_setJumptable



;;====================================================
;;Definition: Corrige Y frente a una colision
;;Entrada:
;;  IX  ->  Player
;;  IY  ->  Entidad
;;Salida:
;;Destruye: A, BC, HL
;;-12, -9, -7, -5, -4, -3, -1, -1, 0, 1, 1, 1, 1, 1, 3, 3, 3, 4, 0x80
;;====================================================
pl_fixY:

    ld h, dp_jump_h(ix)
    ld l, dp_jump_l(ix)

    xor a
    bit 2, de_type(ix)
    jr z, normalGravity

    sub a, (hl)
    jr checkY

    normalGravity:
    add a, (hl)

    jr z, in_roof

    checkY:
    jp m, in_roof



    in_floor:
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

    in_roof:
    ld a, de_y(iy)
    ld b, de_h(iy)
    add a, b

    ld de_y(ix), a
    bit 2, de_type(ix)
    ret z

    set 6, de_type(ix)

ret

;;====================================================
;;Definition: Modifica la dirección del puntero a la jumptable del player
;;            Si está en ascenso no se modifica
;;Entrada:
;;  IX  ->  Player
;;  DE  ->  Jumptable pos
;;Salida:
;;Destruye: A, BC, HL
;;====================================================
pl_setJumptable:


    ld h, dp_jump_h(ix)
    ld l, dp_jump_l(ix)
    ld a, #0
    add a, (hl)
    ret m

    ld hl, #_jumptable
    add hl, de
    ld dp_jump_l(ix), l
    ld dp_jump_h(ix), h
ret


;;================================================================
;;Definition: Setea la jumptable al coger el power up de gravedad
;;Entrada:
;;  IX  ->  Player
;;  DE  ->  Jumptable pos
;;Salida:
;;Destruye: A, BC, HL
;;================================================================
pl_setJumptableOnGravity:

    ld de, #14

    ld h, dp_jump_h(ix)
    ld l, dp_jump_l(ix)
    ld a, #0
    add a, (hl)
    jp m, fall

    ld de, #04

    fall:
    ld hl, #_jumptable
    add hl, de
    ld dp_jump_l(ix), l
    ld dp_jump_h(ix), h
ret
