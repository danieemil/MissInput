.include "render.h.s"
;; MACROS

.macro DefineEnemy _name, _x, _y, _w, _h, _type, _sprite, _dirX, _dirY, _range
_name:
    DefineDrawableEntity _name'_dE, _x, _y, _w, _h, _type, _sprite
    .db _dirX, _dirY
    .db _range


    _name'_size = . - _name
.endm


.macro DefineEnemyDefault _name, _suf
    DefineEnemy _name'_suf, #0xFF, #0, #0, #0, #0xEE, #0xFFFF, #0, #0, #0x80
.endm


.macro DefineEnemyVector _name, _num
_name:
    _c = 0
    .rept _num
        DefineEnemyDefault _name, \_c
        _c = _c + 1
    .endm
.endm



;; Macro positions

dE_dirX     = 0 + dde_size
dE_dirY     = 1 + dde_size
dE_range    = 2 + dde_size
dE_size     = 3 + dde_size


;; Constantes

enemy_width    = 4
enemy_height   = 16



;; Globales
    ;;Dependencias
    .globl _enemy_spr

    .globl vectorEnemies
    .globl vE_num
    .globl vE_entity_next



    ;;Funciones
    .globl enemy_new_default
    .globl enemy_copy





;Flags del enemigo (almacenados en la variable _type de entidad)
;
;7   E -> Describe qué tipo de enemigo es(1->Te persigue, 0->Va a su bola)
;6   R -> El enemigo se resetea?(Solo válido para el enemigo con límites)
;;              (1->Se resetea, 0->No se resetea)
;5   I -> Inhabilitado?(1->Sí, 0->No)
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
;E R I C T T M C
;0 0 0 0 0 0 0 0
