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



;Flags de la entidad(almacenados en la variable _type de entidad)
;
;
;7   N -> Nada
;6   N -> Nada
;5   I -> Inhabilitado?(1->Sí, 0->No)
;4   C -> Detectaremos colisiones en Y?(1->No, 0->Sí) Solo se usa en las colisiones!!
;3   T -> |
;2   T -> +-> Tipo de power-up:
;;              (00->Aporta doble salto)
;;              (01->Gravedad hacia arriba)
;;              (10->Gravedad hacia abajo)
;;              (11->Fin del nivel)
;1   M -> Es mortal?(1->Sí, 0->No)
;0   C -> Se puede coger?(1->power-up, 0->no power-up)
;
;N N I C T T M C
;0 0 0 0 0 0 0 0
