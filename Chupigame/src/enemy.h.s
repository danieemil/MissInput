.include "render.h.s"
;; MACROS

.macro DefineEnemy _name, _x, _y, _w, _h, _type, _sprite, _dirX, _dirY, _range, _counter, _orX, _orY, _restrict, _resCounter
_name:
    DefineDrawableEntity _name'_dE, _x, _y, _w, _h, _type, _sprite
    .db _dirX, _dirY        ;; Dirección
    .db _range, _counter    ;; Rango y contador(por si no sabes inglés ;/)
    .db _orX, _orY          ;; Orígenes
    .db _restrict, _resCounter

    _name'_size = . - _name
.endm


;; Macro positions

dE_dirX     = 0 + dde_size
dE_dirY     = 1 + dde_size
dE_range    = 2 + dde_size
dE_counter  = 3 + dde_size
dE_orX      = 4 + dde_size
dE_orY      = 5 + dde_size
dE_res      = 6 + dde_size
dE_resCount = 7 + dde_size
dE_size     = 8 + dde_size


;; Constantes

enemy_width    = 4
enemy_height   = 16

enemy_near_counter  = 4
enemy_far_counter   = 1



;; Globales
    ;;Dependencias
    .globl _enemy_spr

    .globl Venemies


    ;;Funciones
    .globl enemy_updateAll





;Flags del enemigo (almacenados en la variable _type de entidad)
;
;7   E -> Describe qué tipo de enemigo es(1->Te persigue, 0->Va a su bola)
;6   R -> El enemigo se resetea?(1->Sí, 0->No)(Solo válido para el enemigo con límites)
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
