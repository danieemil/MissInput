.include "enemy.h.s"

DefineEnemyVector vectorEnemies, 4


vE_num:          .db 0
vE_entity_next:  .dw #vectorEnemies


;;=============================================================
;;Definition: Registra un nuevo enemigo
;;Entrada:
;;Salida:
;;  HL  ->  Apunta al enemigo registrado
;;Destruye: AF, BC, HL
;;Comentario: 
;;==============================================================
enemy_new_default:

    ld hl, #vE_num
    inc (hl)

    ld hl, #vE_entity_next

    push de

    ld e, (hl)
    inc hl
    ld d, (hl)

    ex de, hl

    push hl

    ld bc, #dE_size
    add hl, bc

    ld (vE_entity_next), hl

    pop hl

    pop de

ret


;;====================================================
;;Definition: Copia un enemigo
;;Entrada:
;;  HL -> Apunta al dirección del enemigo origen
;;  DE -> Apunta al dirección del enemigo destino
;;Salida:
;;  HL -> Apunta al enemigo registrado
;;Destruye: BC, HL
;;====================================================
enemy_copy:

    ld bc, #dE_size
    ldir

ret



;;====================================================
;;Definition: Updatea todos los enemigos del vector
;;Entrada:
;;  IY  ->  Puntero al vector de enemigos
;;  A   ->  Número de enemigos
;;  BC  ->  Tamaño de cada enemigo
;;Salida:
;;Destruye: A, BC, IY
;;====================================================
enemy_updateAll:

    bit 5, de_type(iy)
    jr nz, next_enemy

    exx
    ex af, af'

    ;; Contador que limita el número de veces que un enemigo se ejecuta
    xor a
    cp dE_resCount(iy)
    jr z, do_update

        dec dE_resCount(iy)
        jr next_enemy

    do_update:
    ld a, dE_res(iy)
    ld dE_resCount(iy), a
    bit 7, de_type(iy)
        call z,  enemy_updateR
        call nz, enemy_updateP
    call enemy_move
    

    next_enemy:
    ex af, af'
    exx

    add iy, bc

    dec a
    jr nz, enemy_updateAll
ret




;;==========================================================
;;Definition: Actualiza los datos de un enemigo que persigue
;;Entrada:
;;  IY  ->  Puntero al enemigo
;;Salida:
;;Destruye: 
;;==========================================================
enemy_updateP:

ret


;;==========================================================
;;Definition: Actualiza los datos de un enemigo que "rebota"
;;Entrada:
;;  IY  ->  Puntero al enemigo
;;Salida:
;;Destruye: A
;;==========================================================
enemy_updateR:

    xor a
    cp dE_counter(iy)
    jp nz, decr_counter

        reset_counter:
        ld a, dE_range(iy)
        ld dE_counter(iy), a

        bit 6, de_type(iy)
        jr z, invert_direction

            go_to_Origin:
            ;; On x
            ld a, dE_orX(iy)
            ld de_x(iy), a

            ;; On y
            ld a, dE_orY(iy)
            ld de_y(iy), a

            jr updR_end

        invert_direction:

        xor a               ;;[4]
        sub dE_dirX(iy)     ;;[19]
        ld dE_dirX(iy), a   ;;[19]
        ;; Optimizado, opción menos óptima utilizando (neg)

        xor a
        sub dE_dirY(iy)
        ld dE_dirY(iy), a

        jr updR_end

    decr_counter:
    dec dE_counter(iy)

    updR_end:
    xor a
ret


;;=====================================================================
;;Definition: Actualiza la posición del enemigo en función de sus datos
;;Entrada:
;;  IY  ->  Puntero al enemigo
;;Salida:
;;Destruye: A
;;=====================================================================
enemy_move:

    ld a, de_x(iy)
    add a, dE_dirX(iy)
    ld de_x(iy), a

    ld a, de_y(iy)
    add a, dE_dirY(iy)
    ld de_y(iy), a

ret