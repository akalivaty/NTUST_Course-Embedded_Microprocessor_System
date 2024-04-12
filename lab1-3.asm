    AREA ArrayData, DATA, READWRITE

ArrayA
    dcd -10, 11, 20, 50, -20, -3 ; declare an array of 6 elements

ArrayB space 24 ; declare an array (4 bytes * 6)

ArrayC space 24 ; declare an array (4 bytes * 6)

    AREA Matrix, CODE, READONLY

num equ 6 ; set the number of elements in the array

    ENTRY

main

    ldr r0, =ArrayA ; load ArrayA to r0
    ldr r1, =ArrayB ; load ArrayB to r1
    ldr r2, =ArrayC ; load ArrayB to r2

    ; copy ArrayA to ArrayB
    mov r3, #num ; set r3 as loop times
    mov r9, r1 ; r9 = &r1, set r1 as target array
    bl copy_array ; copy copy_array

    ; sort signed numbers
    mov r8, r1 ; record head pointer of the array
    mov r3, #num ; set r3 as loop times
    add r4, pc, #4 ; record the return address
    str r4, [sp]
    bl sort_signed_numbers ; branch to sort_signed_numbers

    ; copy ArrayA to ArrayC
    mov r3, #num ; set r3 as loop times
    mov r9, r2 ; r9 = &r2, set r2 as target array
    bl copy_array ; branch to copy_array

    ; sort unsigned numbers
    mov r8, r2 ; record head of the array
    mov r3, #num ; set r3 as loop times
    add r4, pc, #4 ; record the return address
    str r4, [sp]
    bl sort_unsigned_numbers ; branch to sort_unsigned_numbers

    b stop

; copy ArrayA (r0) to target array (r9)
copy_array
    ldr r10, [r0], #4 ; r10 = *r0, r0 = r0 + 4
    str r10, [r9], #4 ; *r9 = r10, r9 = r9 + 4
    subs r3, r3, #1 ; decrement loop times
    bne copy_array ; loop if loop times != 0
    mov pc, lr ; branch to main function

sort_signed_numbers
    mov r5, r3 ; r5 = num
    add r4, pc, #4 ; record the return address
    str r4, [sp, #4]!
    bl signed_outer_loop ; branch to signed_outer_loop

    mov r1, r8 ; mov pointer to the head of the array
    subs r3, r3, #1 ; decrement loop times
    bne sort_signed_numbers ; loop if loop times != 0
    ldr pc, [sp] ; branch to main function if loop times == 0

signed_outer_loop
    subs r5, r5, #1 ; r5 = num - 1
    blne signed_inner_loop ; branch to signed_inner_loop if r5 != 0

    cmp r5, #0 ; compare r5 with 0
    bne signed_outer_loop ; branch to signed_outer_loop if r5 != 0
    ldr pc, [sp], #-4 ; branch to sort_signed_numbers

signed_inner_loop
    ldr r9, [r1], #4 ; r9 = *r1, r1 = r1 + 4
    ldr r10, [r1] ; r10 = *r1
    subs r4, r9, r10 ; r4 = r9 - r10
    movpl r12, r9 ; r12 = r9 if r4 >= 0 (means r9 >= r10)
    strpl r12, [r1], #-4 ; *r1 = r12, r1 = r1 - 4
    strpl r10, [r1], #4 ; *r1 = r10, r1 = r1 + 4

    mov pc, lr ; branch to signed_outer_loop

sort_unsigned_numbers
    mov r5, r3 ; r5 = num
    add r4, pc, #4  ; record the return address
    str r4, [sp, #4]!
    bl unsigned_outer_loop ; branch to unsigned_outer_loop

    mov r2, r8 ; mov pointer to the head of the array
    subs r3, r3, #1 ; decrement loop times
    bne sort_unsigned_numbers ; loop if loop times != 0
    ldr pc, [sp] ; branch to main function if loop times == 0

unsigned_outer_loop
    subs r5, r5, #1 ; r5 = num - 1
    blne unsigned_inner_loop ; branch to unsigned_inner_loop if r5 != 0

    cmp r5, #0  ; compare r5 with 0
    bne unsigned_outer_loop ; branch to unsigned_outer_loop if r5 != 0
    ldr pc, [sp], #-4 ; branch to sort_unsigned_numbers

unsigned_inner_loop
    ldr r9, [r2], #4 ; r9 = *r2, r2 = r2 + 4
    ldr r10, [r2] ; r10 = *r2
    cmp r9, r10 ; compare r9 with r10
    movcs r12, r9 ; r12 = r9 if csrp C=1
    strcs r12, [r2], #-4 ; *r2 = r12, r2 = r2 - 4
    strcs r10, [r2], #4 ; *r2 = r10, r2 = r2 + 4

    mov pc, lr ; branch to unsigned_outer_loop

    
stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file