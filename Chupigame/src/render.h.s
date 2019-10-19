.include "entity.h.s"


;; Macros

.macro DefineDrawableEntity _name, _x, _y, _w, _h, _type, _sprite
_name:
    DefineEntity _name'_de, _x, _y, _w, _h, _type
    .dw _sprite
    _name'_size = . - _name ;; Saves the number of bytes that fills a DefineEntity
.endm


.macro DefineDrawableEntityDefault _name, _suf
    DefineDrawableEntity _name'_suf, #0xFF, #0, #0, #0, #0xEE, #0xFFFF
.endm


.macro DefineDrawableEntityVector _name, _num
_name:
    _c = 0
    .rept _num
        DefineDrawableEntityDefault _name, \_c
        _c = _c + 1
    .endm
.endm

;; Macro positions

dde_spr_l = 0 + de_size
dde_spr_h = 1 + de_size
dde_size  = 2 + de_size


;; Constantes

power_width     = 2
power_height    = 8



;; Global
    ;;Dependencias
    .globl _power1_spr

    .globl cpct_drawSprite_asm
    .globl cpct_getScreenPtr_asm
    .globl cpct_drawSolidBox_asm

    .globl vectorPowers
    .globl vP_num
    .globl vP_entity_next


    ;;Funciones
    .globl power_new
    .globl power_new_default
    .globl power_copy
    .globl drawSprite
    .globl drawBox
    .globl drawBackground




;Flags del power-up (almacenados en la variable _type de entidad)
;
;7   N -> Nada
;6   N -> Nada
;5   N -> Nada
;4   C -> Detectaremos colisiones en Y?(1->No, 0->Sí) No sirve para el power-up
;3   T -> |
;2   T -> +-> Tipo de power-up:
;;              (00->Aporta doble salto)
;;              (01->Gravedad hacia arriba)
;;              (10->Gravedad hacia abajo)
;;              (11->Fin del nivel)
;1   M -> Es mortal?(1->Sí, 0->No) No sirve para el power-up
;0   C -> Se puede coger?(1->power-up, 0->no power-up)
;
;N N N C T T M C
;0 0 0 0 0 0 0 0
