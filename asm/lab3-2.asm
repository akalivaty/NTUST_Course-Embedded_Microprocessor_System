    AREA Data, DATA, READWRITE
ArrayA dcd 1,10,13
ArrayB dcd 2,5,15
ArrayC space 24
    
    AREA adder, CODE, READONLY ; mark first instruction
    ENTRY

start
    ldr r0, =ArrayA
    ldr r1, =ArrayB
    ldr r2, =ArrayC

    mov r11, r2

    ; copy ArrayA to ArrayC
    mov r3, #3 ; set r3 as loop times
    mov r8, r0 ; r9 = &r2, set r2 as target array
    mov r9, r2 ; r9 = &r2, set r2 as target array
    bl copy_array ; copy copy_array

    ; copy ArrayB to ArrayC
    add r2, r2, #12
    mov r3, #3 ; set r3 as loop times
    mov r8, r1
    mov r9, r2
    bl copy_array ; copy copy_array

    ; sort signed numbers
    mov r2, r11 ; record head pointer of the array
    mov r3, #6 ; set r3 as loop times
    add r4, pc, #4 ; record the return address
    str r4, [sp]
    bl sort_signed_numbers ; branch to sort_signed_numbers

    b stop

copy_array
    ldr r10, [r8], #4 ; r10 = *r0, r0 = r0 + 4
    str r10, [r9], #4 ; *r9 = r10, r9 = r9 + 4
    subs r3, r3, #1 ; decrement loop times
    bne copy_array ; loop if loop times != 0
    mov pc, lr ; branch to main function

sort_signed_numbers
    mov r5, r3 ; r5 = num
    add r4, pc, #4 ; record the return address
    str r4, [sp, #4]!
    bl signed_outer_loop ; branch to signed_outer_loop

    mov r2, r11 ; record head pointer of the array
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
    ldr r9, [r2], #4 ; r9 = *r2, r2 = r2 + 4
    ldr r10, [r2] ; r10 = *r2
    subs r4, r9, r10 ; r4 = r9 - r10
    movpl r12, r9 ; r12 = r9 if r4 >= 0 (means r9 >= r10)
    strpl r12, [r2], #-4 ; *r2 = r12, r2 = r2 - 4
    strpl r10, [r2], #4 ; *r2 = r10, r2 = r2 + 4

    mov pc, lr ; branch to signed_outer_loop    

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file