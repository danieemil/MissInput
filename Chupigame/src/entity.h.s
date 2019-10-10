.include "cpctelera.h.s"
;; Macros

.macro DefineEntity _name, _x, _y, _w, _h, _type
_name:
    .db _x, _y
    .db _w, _h
    .db _type
    _name'_size = . - _name ;; Saves the number of bytes that fills a DefineEntity
.endm


;; Macro positions

de_x    = 0
de_y    = 1
de_w    = 2
de_h    = 3
de_type = 4


;; Globals
    ;;Dependencias


    ;;Funciones
    .globl colisionDetection


