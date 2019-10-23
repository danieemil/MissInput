.macro ReserveVector _name, _e_size, _elems
_name'_size:    .db _e_size
_name'_num:     .db #0
_name'_next:    .dw . + 2
_name:
    .rept _elems
        .rept _e_size
            .db #0xDA
        .endm
    .endm
.endm


vector_nx_l = -1
vector_nx_l = -2
vector_n    = -3
vector_s    = -4


.globl new_elem
.globl vector_reset
