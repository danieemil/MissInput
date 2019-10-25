.include "render.h.s"

dE_dirX     = 0 + dde_size

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GRÁFICOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


levels_buffer           = 0x0040
levels_buffer_max_size  = 0x01F4
levels_buffer_end       = levels_buffer + levels_buffer_max_size - 1

_frontbuffer:
.db 0xC0

_backbuffer:
.db 0x80



;;====================================================
;;Definition: Intercambia los buffers
;;Entrada:
;;Salida:
;;Destruye: AF, HL
;;====================================================
initBuffers:
    ld hl, #0x8000
    ld (hl), #0
    ld de, #0x8000+1
    ld bc, #0x4000-1

    ldir

ret

;;====================================================
;;Definition: Intercambia los buffers
;;Entrada:
;;Salida:
;;Destruye: AF, HL
;;====================================================
switchBuffers:

    ld hl, (_frontbuffer)   ;; Inicialmente (80C0)
    ld a, l                 ;; Carga el front buffer en el back buffer
    ld (_backbuffer) , a
    ld a, h                 ;; Carga el back buffer en el front buffer
    ld (_frontbuffer), a

    srl a
    srl a
    ld l, a
    jp cpct_setVideoMemoryPage_asm


    
    





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
   ld   a, (_backbuffer)         ;; DE = Pointer to start of the screen
   ld   d, a
   ld   e, #00
   ld   b, de_y(iy)              ;; B = y coordinate
   ld   c, de_x(iy)              ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld l, dde_spr_l(iy)
   ld h, dde_spr_h(iy) 
   ld c, de_w(iy)
   ld b, de_h(iy)
   call cpct_drawSprite_asm            ;;Destruye AF, BC, DE, HL

ret


;;=====================================================================
;;Definition: Dibuja el sprite con máscara que contiene el DrawableEntity en IX
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
drawSpriteMasked:

    ;; Calculate a video-memory location for printing a string
   ld   a, (_backbuffer)         ;; DE = Pointer to start of the screen
   ld   d, a
   ld   e, #00
   ld   b, de_y(iy)              ;; B = y coordinate
   ld   c, de_x(iy)              ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL

   ex de, hl
   ld l, dde_spr_l(iy)
   ld h, dde_spr_h(iy) 
   ld c, de_w(iy)
   ld b, de_h(iy)
   call cpct_drawSpriteMasked_asm           ;;Destruye AF, BC, DE, HL

ret


;;=====================================================================
;;Definition: Dibuja el sprite con máscara que contiene el DrawableEntity en IX
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
drawSpriteMaskedFlipped:

    

    ;; Calculate a video-memory location for printing a string
   ld   a, (_backbuffer)         ;; DE = Pointer to start of the screen
   ld   d, a
   ld   e, #00
   ld   b, de_y(iy)              ;; B = y coordinate
   ld   a, de_h(iy)
   add  b
   ld   b, a
   ld   c, de_x(iy)              ;; C = x coordinate
   call cpct_getScreenPtr_asm    ;; Calculate video memory location and return it in HL



   ld e, dde_spr_l(iy)
   ld d, dde_spr_h(iy) 
   ld a, de_w(iy)
   ld b, de_h(iy)
   ld c, #0x00
   ld ix, #0x0000
   add ix, bc

   call cpct_drawSpriteVFlipMasked_asm

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
   ld   a, (_backbuffer)         ;; DE = Pointer to start of the screen
   ld   d, a
   ld   e, #0
   ld   b, de_y(ix)             ;; B = y coordinate
   ld   c, de_x(ix)             ;; C = x coordinate
   call cpct_getScreenPtr_asm   ;; Calculate video memory location and return it in HL

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
   ld   a, (_backbuffer)         ;; DE = Pointer to start of the screen
   ld   d, a
   ld   e, #0
   ld    b, dde_preY(iy)                  ;; B = y coordinate
   ld    c, dde_preX(iy)                  ;; C = x coordinate
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
drawPowerUpVector:

    bit 5, de_type(iy)
    jr nz, dpuv_next_elem

    push af
    push bc
    call powerUpAnimation
    ;;call drawSprite
    pop bc
    pop af

    dpuv_next_elem:
    add iy, bc

    dec a
    jr nz, drawPowerUpVector
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
drawEnemyVector:

    bit 5, de_type(iy)
    jr nz, dev_next_elem

    push af
    push bc
    call enemyAnimation
    ;call drawSprite
    pop bc
    pop af

    dev_next_elem:
    add iy, bc

    dec a
    jr nz, drawEnemyVector
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
    ld d, dde_preX(iy)
    ld a, de_w(iy)
    add d
    ld e, a
    ld b, dde_preY(iy)
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
    push af

    ld de, #0020
    ld hl, #levels_buffer
    exx
    ld de, #0080
    ;;ld hl, #0x8000
    ld a , (_backbuffer)
    ld h, a
    ld l , #00

    pop af

    redrawTiles_loop:

        add hl, de              ;; Back Buffer
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
        ld hl, #_tileset_00

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
    


;;==============================================================
;;Definition: dibuja el frame de animacion del Power Up
;;Entrada: 
;;  IY = Puntero al Power Up
;;Salida:
;;Destruye: AF, BC, HL
;;===============================================================
powerUpAnimation:

    ld a, de_type(iy)
    and #0x0C
    pua_check_djump:
    cp #00
    jr nz, pua_check_gup
        ld hl, #_power_up_djump
        jr pua_end_check

    pua_check_gup:
    cp #0x04
    jr nz, pua_set_gdown
        ld hl, #_power_up_gup
        jr pua_end_check

    pua_set_gdown:
    ld hl, #_power_up_gdown

    pua_end_check:
    ld b, #0x00
    ld c, dde_animCounter(iy)

    push hl

    add hl, bc
    ld a, (hl)
    inc hl
    ld b, (hl)
    dec hl  
    or b
    jr nz, apply_power_up_animation

        pop hl
        ld dde_animCounter(iy), #0x00
        push hl

    apply_power_up_animation:         
    ld a, (hl)
    ld dde_spr_l(iy), a
    inc hl
    ld a, (hl)
    ld dde_spr_h(iy), a

    pop hl
                
    ld a, dde_animTime(iy)
    cp a, #0
    jr nz, decrement_animTime_Powerup

        inc dde_animCounter(iy)
        inc dde_animCounter(iy)
        ld dde_animTime(iy), #animTimeConstPowerUp
        jp drawSprite

    decrement_animTime_Powerup:
    dec dde_animTime(iy)
    jp drawSprite



;;==============================================================
;;Definition: dibuja el frame de animacion del Enemigo
;;Entrada: 
;;  IY = Puntero al enemigo
;;Salida:
;;Destruye: AF, BC, HL
;;===============================================================
enemyAnimation:

    ld a, dde_actualAnim(iy)
    cp dde_prevAnim(iy)
    jr z, continue_enemy_animation

        ld dde_animCounter(ix), #0x00
        ld dde_animTime(ix), #animTimeConstPlayer

    continue_enemy_animation:
    ld dde_prevAnim(iy), a

    ld a, de_type(iy)
    and #0xC0
    ea_check_bounce:
    cp #0x00
    jr nz, ea_check_reset

        ld a, dE_dirX(iy)
        cp #1
        jr nz, ea_bounce_left

            ld dde_actualAnim(iy), #0x01        ;; Bounce_right = anim 01
            ld hl, #_enemy_02_right
            jr ea_end_check
                                     
        ea_bounce_left:

            ld dde_actualAnim(iy), #0x00        ;; Bounce_right = anim 01
            ld hl, #_enemy_02_left
            jr ea_end_check

    ea_check_reset:
    cp #0x40
    jr nz, ea_set_chase

        ld dde_actualAnim(iy), #0x00        ;; Bounce_right = anim 01
        ld hl, #_enemy_03_anim
        jr ea_end_check

    ea_set_chase:

        ld a, dE_dirX(iy)
        cp #1
        jr nz, ea_chase_left

            ld dde_actualAnim(iy), #0x01        ;; Bounce_right = anim 01
            ld hl, #_enemy_01_right
            jr ea_end_check

        ea_chase_left:
        cp #-1
        jr nz, ea_chase_none
        
            ld dde_actualAnim(iy), #0x00        ;; Bounce_right = anim 01
            ld hl, #_enemy_01_left
            jr ea_end_check

        ea_chase_none:
        jp drawSpriteMasked


    ea_end_check:
    ld b, #0x00
    ld c, dde_animCounter(iy)

    push hl

    add hl, bc
    ld a, (hl)
    inc hl
    ld b, (hl)
    dec hl  
    or b
    jr nz, apply_enemy_animation

        pop hl
        ld dde_animCounter(iy), #0x00
        push hl

    apply_enemy_animation:         
    ld a, (hl)
    ld dde_spr_l(iy), a
    inc hl
    ld a, (hl)
    ld dde_spr_h(iy), a

    pop hl
                
    ld a, dde_animTime(iy)
    cp a, #0
    jr nz, decrement_animTime_Enemy

        inc dde_animCounter(iy)
        inc dde_animCounter(iy)
        ld dde_animTime(iy), #animTimeConstEnemy
        jr dde_draw_sprite

    decrement_animTime_Enemy:
    dec dde_animTime(iy)

    dde_draw_sprite:
    bit 7, de_type(iy)
    jp nz, drawSpriteMasked
    jp drawSprite