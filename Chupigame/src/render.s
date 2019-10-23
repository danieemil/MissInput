.include "render.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;POWER-UPS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ReserveVector Vpowers, dde_size, 4



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GRÁFICOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


levels_buffer           = 0x0040
levels_buffer_max_size  = 0x05B4
levels_buffer_end       = levels_buffer + levels_buffer_max_size - 1
levels_tileset          = levels_buffer + _mylevel_0_OFF_001

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

    ;exx
    ;ex af, af'
    push af
    push bc
    

    ;call drawBackground
    ld d, de_x(iy)
    ld a, de_w(iy)
    add d
    ld e, a
    ld b, de_y(iy)
    ld a, de_h(iy)
    add b
    call redrawTiles
    
    pop bc
    pop af
    ;ex af, af'
    ;exx

    next_celem:
    add iy, bc

    dec a
    jr nz, cleanVector
ret



;;==============================================================
;;Definition: redibuja los tiles que hay al fondo del sprite
;;Entrada: 
;;  DE  ->  X y X+W
;;  A   ->  Y+W
;;  B   ->  Y
;;Salida:
;;Destruye: AF, BC, DE, HL
;;===============================================================
redrawTiles:

    push de
    srl b
    srl b
    srl b

    srl a
    srl a
    srl a

    sub b
    ld c, a

    ld a, b

    ld de, #0020
    ld hl, #levels_buffer
    exx
    ld de, #0080
    ld hl, (_frontbuffer)

    redrawTiles_loop:

        add hl, de              ;; Front Buffer
        exx
        add hl, de               ;; Tilemap
        exx
        dec a

    jr nz, redrawTiles_loop

    exx                         ;; HL - Tilemap  |  HL' - Video mem
    pop de

    srl d
    srl d

    srl e
    srl e

    ld a, e
    sub d
    ld e, a
    push de

    ld e, d
    ld d, #0
    add hl, de     ;; HL + X
    
    ld a, e
    exx
    sla a
    sla a
    ld d, #0
    ld e, a
    add hl, de

    exx
    pop de

    ;; HL -> puntero a tilemap (x,y) | HL' -> Puntero a memoria de video alineada (x,y) 
    ;; B -> Y en el tilemap  |  C -> Diferencia de Y en el tilemap
    ;; D -> X en el tilemap  |  E -> Diferencia de X en el tilemap
    drawTile_X_loop:

    push hl
    exx
    push hl
    exx

    ld a, c

    drawTile_Y_loop:

        

        

        push af
        ld a, (hl)
        exx
        ex de, hl
        ld bc, #32
        ld hl, #levels_tileset

        cp a, #0
        jr z, findTile_loop_end

        findTile_loop:
            add hl, bc
            dec a
        jr nz,findTile_loop

        findTile_loop_end:
        push de
        call cpct_drawTileAligned4x8_asm       ;; se lo carga toh
        pop  de

        ex de, hl
        ld bc, #80
        add hl, bc
        
        exx
        push bc
        ld bc, #20
        add hl, bc
        pop bc

        pop af
        dec a
    jp p, drawTile_Y_loop

    exx
    pop hl
    ld bc, #4
    add hl, bc
    exx

    pop hl
    inc hl

    

    ld a, e
    cp #0
    ;jr z, .
    ret z

    dec e
    
    jr drawTile_X_loop
    