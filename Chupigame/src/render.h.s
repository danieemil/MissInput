.include "entity.h.s"
.include "bins/tilemap.h.s"
.include "bins/mylevel_0.h.s"
.include "animation_data.h.s"



;; Macros

.macro DefineDrawableEntity _name, _x, _y, _w, _h, _type, _sprite
_name:
    DefineEntity _name'_de, _x, _y, _w, _h, _type
    .dw _sprite
    .db _x, _y
    .db #0, #0, #0, #0
    _name'_size = . - _name ;; Saves the number of bytes that fills a DefineEntity
.endm

;; Macro positions

dde_spr_l = 0 + de_size
dde_spr_h = 1 + de_size
dde_preX  = 2 + de_size
dde_preY  = 3 + de_size

dde_actualAnim = 4 + de_size
dde_prevAnim = 5 + de_size
dde_animCounter = 6 + de_size
dde_animTime = 7 + de_size

dde_size  = 8 + de_size


animTimeConst = 3               ;; Numero de iteraciones entre frames de animacion


;; Global
    ;;Dependencias
    .globl cpct_drawSprite_asm
    .globl cpct_drawSpriteMasked_asm
    .globl cpct_drawSpriteVFlipMasked_asm
    .globl cpct_getScreenPtr_asm
    .globl cpct_drawSolidBox_asm
    .globl cpct_drawTileAligned4x8_asm
    .globl cpct_drawTileAligned4x8_f_asm
    .globl cpct_setVideoMemoryPage_asm

    .globl _tileset_00

    ;; Tilemaps
    .globl levels_buffer
    .globl levels_buffer_max_size  
    .globl levels_buffer_end     


    ;;Funciones
    .globl drawSprite
    .globl drawSpriteMasked
    .globl drawSpriteMaskedFlipped
    .globl drawBox
    .globl drawBackground
    .globl drawVector
    .globl cleanVector
    .globl switchBuffers
    .globl initBuffers
    .globl redrawTiles

    .globl _frontbuffer
    .globl _backbuffer




;Flags del power-up (almacenados en la variable _type de entidad)
;
;7   N -> Nada
;6   N -> Nada
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
;N N I C T T M C
;0 0 0 0 0 0 0 0
