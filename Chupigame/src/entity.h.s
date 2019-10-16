.include "cpctelera.h.s"
;; Macros

.macro DefineEntity _name, _x, _y, _w, _h, _type
_name:
    .db _x, _y
    .db _w, _h
    .db _type
    _name'_size = . - _name ;; Saves the number of bytes that fills a DefineEntity
.endm

.macro DefineEntityDefault _name, _suf
DefineEntity _name'_suf, #0xFF, #0, #0, #0, #0xFF
.endm


.macro DefineEntityVector _name, _num
_name:
    _c = 0
    .rept _num
        DefineEntityDefault _name, \_c
        _c = _c + 1
    .endm
.endm

;; Macro positions

de_x    = 0
de_y    = 1
de_w    = 2
de_h    = 3
de_type = 4
de_size = 5



;; Globals
    ;;Dependencias
    .globl vector
    .globl v_num
    .globl v_entity_next

    ;;Funciones
    .globl ent_new
    .globl ent_new_default
    .globl ent_copy
    .globl detectCollisionX
    .globl collisionY


