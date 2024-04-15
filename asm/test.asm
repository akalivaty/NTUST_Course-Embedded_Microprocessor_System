    AREA ArrayData, DATA, READWRITE

ArrayA
    dcd -10, 11, 20, 50, -20, -3 ; Declare an array of 6 elements

ArrayB space 24

ArrayC space 24

    AREA Matrix, CODE, READONLY

num equ 6   ; set the number of elements in the array

    ENTRY

main

    ldr r0, =ArrayA
    ldr r1, =ArrayB
    ldr r2, =ArrayC

    ; copy ArrayA to ArrayB
    mov r3, #num ; loop times
    mov r9, r1 ; r9 = &r1
    bl copy_array

    ; sort signed numbers
    mov r8, r1 ; record head of the array
    mov r3, #num ; loop times
    add r4, pc, #4 ; record the return address
    str r4, [sp]
    bl sort_signed_numbers

    ; copy ArrayA to ArrayC
    mov r3, #num ; loop times
    mov r9, r2 ; r9 = &r2
    bl copy_array

    ; sort unsigned numbers
    mov r8, r2 ; record head of the array
    mov r3, #num ; loop times
    add r4, pc, #4 ; record the return address
    str r4, [sp]
    bl sort_unsigned_numbers

    b stop

copy_array
    ldr r10, [r0], #4
    str r10, [r9], #4
    subs r3, r3, #1
    bne copy_array
    mov pc, lr ; branch to the return address

sort_signed_numbers
    mov r5, r3 ; r5 = len
    add r4, pc, #4
    str r4, [sp, #4]!
    bl signed_outer_loop

    mov r1, r8 ; mov pointer to the head of the array
    subs r3, r3, #1 ; decrement loop times
    bne sort_signed_numbers ; loop if loop times are not zero
    ldr pc, [sp] ; branch to main function if loop times are zero

signed_outer_loop
    subs r5, r5, #1 ; r5 = len - 1
    blne signed_inner_loop

    cmp r5, #0
    bne signed_outer_loop
    ldr pc, [sp], #-4

signed_inner_loop
    ldr r9, [r1], #4 ; r9 = *r1, r1 = r1 + 4
    ldr r10, [r1] ; r10 = *r1
    subs r4, r9, r10
    movpl r12, r9
    strpl r12, [r1], #-4
    strpl r10, [r1], #4 ; move pointer to next element

    mov pc, lr

sort_unsigned_numbers
    mov r5, r3 ; r5 = len
    add r4, pc, #4
    str r4, [sp, #4]!
    bl unsigned_outer_loop

    mov r2, r8 ; mov pointer to the head of the array
    subs r3, r3, #1 ; decrement loop times
    bne sort_unsigned_numbers ; loop if loop times are not zero
    ldr pc, [sp] ; branch to main function if loop times are zero

unsigned_outer_loop
    subs r5, r5, #1 ; r5 = len - 1
    blne unsigned_inner_loop

    cmp r5, #0
    bne unsigned_outer_loop
    ldr pc, [sp], #-4

unsigned_inner_loop
    ldr r9, [r2], #4 ; r9 = *r2, r2 = r2 + 4
    ldr r10, [r2] ; r10 = *r2
    cmp r9, r10
    movcs r12, r9
    strcs r12, [r2], #-4
    strcs r10, [r2], #4 ; move pointer to next element

    mov pc, lr

    
stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file