.include "entity.h.s"

vector:
DefineEntityVector v_entity, 5

v_num:          .db 0
v_entity_next:  .dw #vector

;;=============================================================
;;Definition: Registra una nueva entidad y le setea sus valores
;;Entrada:
;;  A   ->  Contiene _type
;;  B   ->  Contiene _x
;;  C   ->  Contiene _y
;;  D   ->  Contiene _w
;;  E   ->  Contiene _h
;;Salida:
;;  HL  ->  Apunta a la entidad registrada
;;Destruye: AF, BC, DE, HL
;;Comentario: 
;;==============================================================
ent_new:

    ld hl, #v_num
    inc (hl)

    ld hl, #v_entity_next

    push de

    ld e, (hl)
    inc hl
    ld d, (hl)

    ex de, hl

    pop de

    push bc
    push hl

    ld bc, #de_size
    add hl, bc

    ld (v_entity_next), hl

    pop hl
    pop bc

    push hl

    ;; Seteamos los datos de la entidad en cuestión
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
;;Definition: Registra una nueva entidad
;;Entrada:
;;Salida:
;;  HL  ->  Apunta a la entidad registrada
;;Destruye: AF, BC, HL
;;Comentario: 
;;==============================================================
ent_new_default:

    ld hl, #v_num
    inc (hl)

    ld hl, #v_entity_next

    push de

    ld e, (hl)
    inc hl
    ld d, (hl)

    ex de, hl

    push hl

    ld bc, #de_size
    add hl, bc

    ld (v_entity_next), hl

    pop hl

    pop de

ret




;;====================================================
;;Definition: Copia una entidad
;;Entrada:
;;  HL -> Apunta a la dirección de la entidad origen
;;  DE -> Apunta a la dirección de la entidad destino
;;Salida:
;;  HL -> Apunta a la entidad registrada
;;Destruye: BC, HL
;;====================================================
ent_copy:

    ld bc, #de_size
    ldir

ret



;; Colisiones en GENERAL
;;====================================================
;;Definition: Detecta las colisiones entre dos entidades
;;Entrada: 
;;  IX  ->  Puntero a la primera entidad
;;  IY  ->  Puntero a la segunda entidad
;;  C   ->  TIENE QUE SER 0
;;Salida:
;;  C   ->  Resultado de la colisión
;;  Detalles: (0->solo colisiona en x, pero no en y, 1->colisionan)
;;Destruye: A, HL, C
;;====================================================
;;Fórmulas:
;;
;;Colisiones en una dimensión:
;;if(x1min >= x2max || x1max =< x2min)
;;  Si se cumple esto, NO COLISIONAN, sin embargo si no se cumple, HAY COLISIÓN
;;
;;
;;Instrucciones
;;JP P, direccion : Salta si el indicador de signo S está a cero (resultado positivo).
;;JP M, direccion : Salta si el indicador de signo S está a uno (resultado negativo)
;;
;;====================================================



;;==================================================================================
;;Definition: Después de corregir en X y mover en Y, detecta colisiones solo en Y
;;0487
;;==================================================================================
collisionY:
    bit 4, de_type(iy)
    jr z, etiqueta

    ld c, #0
    jr detectCollisionY

    etiqueta:
ret


;;=============================================================================================
;;Definition: Detecta las colisiones entre dos entidades en X (si colisionan las detecta en y)
;;=============================================================================================
detectCollisionX:
;;Primero detectamos si hay colisión en el eje X
;;(x2max - x1min) -> 0, negativo; si no hay colision
;;x2max en A
    ld a, de_x(iy)      ;;[19]
    add a, de_w(iy)     ;;[19]

    sub a, de_x(ix)     ;;[19]
    jr z, endCollisions  ;;[12/7]
    jp m, endCollisions  ;;[10]
                        ;;[67 + 12/7]

    ;;FRAN
    ;;[13]+[4]+[13]+[4]+[7]+[10]+[12/7]
    ;;[7]+[4]+[6]+[6]+[7]+[4]+[7]+[6]+[6]+[10]+[12/7] -> 63 + 12/7

;;(x1max - x2min) -> 0, negativo; si no hay colisión
    ld a, de_x(ix)      ;;[19]
    add a, de_w(ix)     ;;[19]

    sub a, de_x(iy)     ;;[19]
    jr z, endCollisions  ;;[12/7]
    jp m, endCollisions  ;;[10]

;;=================================================================
;;Definition: Detecta las colisiones entre dos entidades solo en Y
;;=================================================================
detectCollisionY:
    ;;Luego detectamos si hay colisión en el eje Y
    ;;(y2max - y1min) -> 0, negativo; si no hay colision
    ld a, de_y(iy)      
    add a, de_h(iy)     

    sub a, de_y(ix)     
    ret z
    ret m

    ;;(y1max - y2min) -> 0, negativo; si no hay colisión
    ld a, de_y(ix)      
    add a, de_h(ix)     

    sub a, de_y(iy)     
    ret z  
    ret m 

    inc c

    endCollisions:
    set 4, de_type(iy)

ret


