.include "entity.h.s"

;; Macros

.macro DefineDrawableEntity _name, _x, _y, _w, _h, _type, _sprite
_name:
    DefineEntity _name'_de, _x, _y, _w, _h, _type
    .dw _sprite
    _name'_size = . - _name ;; Saves the number of bytes that fills a DefineEntity
.endm


;; Macro positions

de_size = 5
dde_spr_l = 0 + de_size
dde_spr_h = 1 + de_size


;; Global
    ;;Dependencias
    .globl cpct_drawSprite_asm
    .globl cpct_getScreenPtr_asm
    .globl cpct_drawSolidBox_asm

    ;;Funciones
    .globl drawSprite
    .globl drawBackground