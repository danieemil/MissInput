;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of Miss Input: An Amstrad CPC Game 
;;  Copyright (C) 2019 Enrique Vidal Cayuela, Daniel Saura Martínez
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------

.include "vector.h.s"

;;=============================================================
;;Definition: Registra un nuevo enemigo
;;Entrada:
;;  HL  ->  Apunta al principio del vector
;;  DE  ->  Apunta a los datos del elemento
;;Salida:
;;Destruye: BC, DE, HL
;;Comentario: 
;;==============================================================
new_elem:

    ;; Sumamos 1 al contador de elementos
    dec hl
    dec hl
    dec hl
    inc (hl)

    ;; Cargamos en BC el tamaño de cada elemento
    dec hl
    ld b, #0
    ld c, (hl)

    push de

    ;; Cargamos en hl la dirección a _next
    inc hl
    inc hl
    ld e, (hl)
    inc hl
    ld d, (hl)
    ex de, hl
    dec de

    

    ;; DE -> Apunta a la etiqueta _next
    ;; HL -> Apunta a lo que apunta la etiqueta _next
    ;; BC -> Tamaño del elemento

    push hl

    add hl, bc
    ex de, hl

    ;; Cargamos en _next la siguiente entidad
    ld (hl), e
    inc hl
    ld (hl), d

    pop hl
    pop de

    ex de, hl

    ;; Copiamos:
    ;; Cantidad:    BC
    ;; Origen:      HL
    ;; Destino:     DE
    ldir

ret



;;=============================================================
;;Definition: Devuelve el vector al estado inicial
;;Entrada:
;;  HL  ->  Apunta al principio del vector
;;Salida:
;;  HL  ->  Apunta al principio del vector
;;Destruye: DE, HL
;;Comentario: 
;;==============================================================
vector_reset:

    
    push hl

    ;; Ponemos el número de elementos a 0
    dec hl 
    dec hl

    push hl

    dec hl
    ld (hl), #0
    ex de, hl

    pop hl
    ex de, hl
    
    pop hl
    ex de, hl

    ;; Ponemos _next al principio del vector
    ld (hl), e
    inc hl
    ld (hl), d

ret