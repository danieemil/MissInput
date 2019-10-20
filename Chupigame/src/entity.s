
.include "player.h.s"

;; En este vector estarán las entidades que corrigen la posición del jugador
vector:
DefineEntityVector v_entity, 20

v_num:          .db 0
v_entity_next:  .dw #vector



;; En este vector... el resto de entidades
vector_2:
DefineEntityVector v2_entity, 20

v2_num:          .db 0
v2_entity_next:  .dw #vector_2


;;=============================================================
;;Definition: Registra una nueva entidad
;;Entrada:
;;  HL -> Dirección donde está guardado el número de entidades
;;  BC -> Dirección donde está guardado la dirección a la siguiente entidad
;;Salida:
;;  HL  ->  Apunta a la entidad registrada
;;Destruye: AF, BC, HL
;;Comentario: 
;;==============================================================
ent_new_default:

    inc (hl)

    inc hl

    push de

    ld e, (hl)
    inc hl
    ld d, (hl)

    ex de, hl

    push hl

    push bc

    ld bc, #de_size
    add hl, bc

    pop bc

    ld a, l
    ld (bc), a
    inc bc

    ld a, h
    ld (bc), a

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
;;==================================================================================
collisionY:
    bit 4, de_type(iy)
    jr nz, etiqueta

    ld b, #0
    ld c, #0
    jr detectCollisionY

    

    etiqueta:
ret


;;=============================================================================================
;;Definition: Detecta las colisiones entre dos entidades en X (si colisionan las detecta en y)
;;=============================================================================================
detectCollisionX:

    ;; Tá xocando con la paré¿
    ld b, #0


;;Primero detectamos si hay colisión en el eje X
;;(x2max - x1min) -> 0, negativo; si no hay colision
;;x2max en A
    ld a, de_x(iy)      ;;[19]
    add a, de_w(iy)     ;;[19]

    sub a, de_x(ix)     ;;[19]
    jp m, endCollisions  ;;[10]
    jr nz, check_right  ;;[12/7]
                        ;;[67 + 12/7]
        dec b
        set 4, de_type(iy)
        jr detectCollisionY

    ;;FRAN
    ;;[13]+[4]+[13]+[4]+[7]+[10]+[12/7]
    ;;[7]+[4]+[6]+[6]+[7]+[4]+[7]+[6]+[6]+[10]+[12/7] -> 63 + 12/7

    check_right:
;;(x1max - x2min) -> 0, negativo; si no hay colisión
    ld a, de_x(ix)      ;;[19]
    add a, de_w(ix)     ;;[19]

    sub a, de_x(iy)     ;;[19]
    jp m, endCollisions  ;;[10]
    jr nz, detectCollisionY  ;;[12/7]

        inc b
        set 4, de_type(iy)

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
    
    ld a, b

    cp #0
    jp m, box_left
    jr nz, box_right

    inc c

    endCollisions:
    set 4, de_type(iy)

ret

    box_left:
    set 4, de_type(ix)
    ret

    box_right:
    set 5, de_type(ix)
    ret



