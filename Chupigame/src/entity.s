.include "entity.h.s"




;;====================================================
;;Definition: Detecta las colisiones entre dos entidades
;;Entrada: 
;;  IX  ->  Puntero a la primera entidad
;;  IY  ->  Puntero a la segunda entidad
;;Salida:
;;  A   ->  Resultado de la colisión(0->no colisionan, 1->colisionan)
;;Destruye: A, HL,
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
colisionDetection:
;;Primero detectamos si hay colisión en el eje X
;;(x2max - x1min) -> 0, negativo; si no hay colision

;;x2max en A
    ld a, de_x(iy)      ;;[19]
    add a, de_w(iy)     ;;[19]

    sub a, de_x(ix)     ;;[19]
    jr z, endColisions  ;;[12/7]
    jp m, endColisions  ;;[10]
                        ;;[67 + 12/7]

    ;;FRAN
    ;;[13]+[4]+[13]+[4]+[7]+[10]+[12/7]

    ;;[7]+[4]+[6]+[6]+[7]+[4]+[7]+[6]+[6]+[10]+[12/7] -> 63 + 12/7


;;(x1max - x2min) -> 0, negativo; si no hay colisión
    ld a, de_x(ix)      ;;[19]
    add a, de_w(ix)     ;;[19]

    sub a, de_x(iy)     ;;[19]
    jr z, endColisions  ;;[12/7]
    jp m, endColisions  ;;[10]


    ld a, #0xFF
    ld (0xC000), a
    

;;Luego detectamos si hay colisión en el eje Y
;;(y2max - y1min) -> 0, negativo; si no hay colision
    ld a, de_y(iy)      
    add a, de_h(iy)     

    sub a, de_y(ix)     
    jr z, endColisions
    jp m, endColisions

;;(y1max - y2min) -> 0, negativo; si no hay colisión
    ld a, de_y(ix)      
    add a, de_h(ix)     

    sub a, de_y(iy)     
    jr z, endColisions  
    jp m, endColisions 



    ret


    endColisions:
    ld a, #0x00
    ld (0xC000), a
    ld (0xC004), a

ret