.include "render.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWER-UPS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ReserveVector Vpowers, dde_size, 4



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GRÁFICOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_frontbuffer:
.dw 0xC000

_backbuffer:
.dw 0x8000

;;=====================================================================
;;Definition: Dibuja el sprite que contiene el DrawableEntity en IX
;;Entrada: 
;;  IY  ->  Puntero que apunta al DrawableEntity
;;Salida:
;;Destruye: AF, BC, DE, HL
;;=====================================================================
;;
;; Sprite 
;;   80 + (84 + 20W)16 + ((36)H)H            (+36)Worst case
;; Player -> 2704 + 9216 = 11920 ciclos
;
;; Sprite Masked
;;   84 + (88 + 72W)H + 40HH                 (+40)Worst case
;;
;;======================================================================
drawSprite:

    ;; Calculate a video-memory location for printing a string
   ld   de, (_frontbuffer) ;; DE = Pointer to start of the screen
   ld    b, de_y(iy)                  ;; B = y coordinate
   ld    c, de_x(iy)                  ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld l, dde_spr_l(iy)
   ld h, dde_spr_h(iy) 
   ld c, de_w(iy)
   ld b, de_h(iy)
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
;;  IY  ->  Puntero que apunta al DrawableEntity
;;Salida:
;;Destruye: AF, BC, DE, HL
;;====================================================
drawBackground:

    ;; Calculate a video-memory location for printing a string
   ld   de, (_frontbuffer) ;; DE = Pointer to start of the screen
   ld    b, de_y(iy)                  ;; B = y coordinate
   ld    c, de_x(iy)                  ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld a, #0
   ld c, de_w(iy)
   ld b, de_h(iy)
   call cpct_drawSolidBox_asm            ;;Destruye AF, BC, DE, HL

ret



;;====================================================
;;Definition: Dibuja todos los elementos de un vector
;;Entrada: 
;;  IY  ->  Puntero que apunta al vector
;;  A   ->  Número de elementos
;;  BC  ->  Tamaño de cada elemento
;;Salida:
;;Destruye: AF, BC, DE, HL
;;====================================================
drawVector:

    bit 5, de_type(iy)
    jr nz, next_elem

    exx
    ex af, af'
    call drawSprite
    ex af, af'
    exx

    next_elem:
    add iy, bc

    dec a
    jr nz, drawVector
ret


;;==============================================================
;;Definition: Dibuja todos los elementos de un vector como fondo
;;Entrada: 
;;  IY  ->  Puntero que apunta al vector
;;  A   ->  Número de elementos
;;  BC  ->  Tamaño de cada elemento
;;Salida:
;;Destruye: AF, BC, DE, HL
;;===============================================================
cleanVector:

    bit 5, de_type(iy)
    jr nz, next_celem

    exx
    ex af, af'
    call drawBackground
    ex af, af'
    exx

    next_celem:
    add iy, bc

    dec a
    jr nz, cleanVector
ret



;;==============================================================
;;Definition: redibuja los tiles que hay al fondo del sprite
;;Entrada: 
;;  IX  ->  Puntero que apunta al vector
;;  A   ->  Número de elementos
;;  BC  ->  Tamaño de cada elemento
;;Salida:
;;Destruye: AF, BC, DE, HL
;;===============================================================
redrawTiles:

    
    
ret