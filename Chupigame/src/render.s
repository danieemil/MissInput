.include "render.h.s"

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