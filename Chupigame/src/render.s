.include "render.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWER-UPS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




DefineDrawableEntityVector vectorPowers, 4


vP_num:          .db 0
vP_entity_next:  .dw #vectorPowers


;;=============================================================
;;Definition: Registra un nuevo power-up y le setea sus valores
;;Entrada:
;;  A   ->  Contiene _type
;;  B   ->  Contiene _x
;;  C   ->  Contiene _y
;;  D   ->  Contiene _w
;;  E   ->  Contiene _h
;;Salida:
;;  HL  ->  Apunta al power-up registrado
;;Destruye: AF, BC, DE, HL
;;Comentario: 
;;==============================================================
power_new:

    ld hl, #vP_num
    inc (hl)

    ld hl, #vP_entity_next

    push de

    ld e, (hl)
    inc hl
    ld d, (hl)

    ex de, hl

    pop de

    push bc
    push hl

    ld bc, #dde_size
    add hl, bc

    ld (vP_entity_next), hl

    pop hl
    pop bc

    push hl

    ;; Seteamos los datos del power-up en cuestión
    ld (hl), b
    inc hl
    ld (hl), c
    inc hl
    ld (hl), d
    inc hl
    ld (hl), e
    inc hl
    ld (hl), a

    pop hl

ret


;;=============================================================
;;Definition: Registra un nuevo power-up
;;Entrada:
;;Salida:
;;  HL  ->  Apunta al power-up registrado
;;Destruye: AF, BC, HL
;;Comentario: 
;;==============================================================
power_new_default:

    ld hl, #vP_num
    inc (hl)

    ld hl, #vP_entity_next

    push de

    ld e, (hl)
    inc hl
    ld d, (hl)

    ex de, hl

    push hl

    ld bc, #dde_size
    add hl, bc

    ld (vP_entity_next), hl

    pop hl

    pop de

ret




;;====================================================
;;Definition: Copia un power-up
;;Entrada:
;;  HL -> Apunta al dirección del power-up origen
;;  DE -> Apunta al dirección del power-up destino
;;Salida:
;;  HL -> Apunta al power-up registrado
;;Destruye: BC, HL
;;====================================================
power_copy:

    ld bc, #dde_size
    ldir

ret







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GRÁFICOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_frontbuffer:
.dw 0xC000

_backbuffer:
.dw 0x8000

;;====================================================
;;Definition: Dibuja el sprite que contiene el DrawableEntity en IX
;;Entrada: 
;;  IX  ->  Puntero que apunta al DrawableEntity
;;Salida:
;;Destruye: AF, BC, DE, HL
;;====================================================
drawSprite:

    ;; Calculate a video-memory location for printing a string
   ld   de, (_frontbuffer) ;; DE = Pointer to start of the screen
   ld    b, de_y(ix)                  ;; B = y coordinate
   ld    c, de_x(ix)                  ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld l, dde_spr_l(ix)
   ld h, dde_spr_h(ix) 
   ld c, de_w(ix)
   ld b, de_h(ix)
   call cpct_drawSprite_asm            ;;Destruye AF, BC, DE, HL

ret


;;====================================================
;;Definition: Dibuja un cuadrado
;;Entrada:
;;  IX  ->  Puntero que apunta al DrawableEntity
;;Salida:
;;Destruye: AF, BC, DE, HL
;;====================================================
drawBox:
 ;; Calculate a video-memory location for printing a string
   ld   de, (_frontbuffer) ;; DE = Pointer to start of the screen
   ld    b, de_y(ix)                  ;; B = y coordinate
   ld    c, de_x(ix)                  ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld a, de_type(ix)
   ld c, de_w(ix)
   ld b, de_h(ix)
   call cpct_drawSolidBox_asm            ;;Destruye AF, BC, DE, HL

ret

;;====================================================
;;Definition: Dibuja un cuadrado en negro
;;Entrada: 
;;  IX  ->  Puntero que apunta al DrawableEntity
;;Salida:
;;Destruye: AF, BC, DE, HL
;;====================================================
drawBackground:

    ;; Calculate a video-memory location for printing a string
   ld   de, (_frontbuffer) ;; DE = Pointer to start of the screen
   ld    b, de_y(ix)                  ;; B = y coordinate
   ld    c, de_x(ix)                  ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld a, #0
   ld c, de_w(ix)
   ld b, de_h(ix)
   call cpct_drawSolidBox_asm            ;;Destruye AF, BC, DE, HL

ret