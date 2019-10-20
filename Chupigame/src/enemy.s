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


