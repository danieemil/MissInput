



;;Constantes

    ;;Tiles
    tw = 4
    th = 8

    ;;Entidades especiales
    e_pinchos = 0x02     ;; 00000010
    e_salida  = 0x0C     ;; 00001100
    e_djump   = 0x00     ;; 00000000
    e_gup     = 0x04     ;; 00000100
    e_gdown   = 0x08     ;; 00001000

    ;;Power-ups
    power_width     = 2
    power_height    = 8

    p_djump = 0x01       ;; 00000001
    p_gup   = 0x05       ;; 00000101
    p_gdown = 0x09       ;; 00001001

    ;;Enemigos
    enemy_width    = 4
    enemy_height   = 16

    e_bounce = 0x02      ;; 00000010
    e_line   = 0x42      ;; 01000010  
    e_chase  = 0x82      ;; 10000010

end_of_data = 0x80



;; Globales
    ;; Dependencias
    .globl _enemy_spr
    .globl _power1_spr

    .globl entities
    .globl special_entities
    .globl power_ups
    .globl enemies


    ;;Funciones