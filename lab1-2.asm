    AREA ArrayData, DATA, READWRITE

ArrayA
    DCD -10, 11, 20, 50, -20, -3 ; Declare an array of 6 elements

    AREA Matrix, CODE, READONLY

num equ 6   ; set the number of elements in the array

    ENTRY

main
    ldr r0, =ArrayA

    ; sum signed numbers
    mov r1, #num ; loop times
    mov r7, #0 ; signed sum register
    mov r5, #0 ; set 1 if overflow (check V flag)
    add r2, pc, #4
    str r2, [sp]
    bl add_signed_sum

    ; sum unsigned numbers
    mov r1, #num ; loop times
    mov r8, #0 ; unsigned sum register
    mov r6, #0 ; set 1 if overflow (check C flag)
    bl add_unsigned_sum

    b stop

add_signed_sum
    ldr r9, [r0], #4 ; r9 = *r0, r0 = r0 + 4

    ; if (r9 < 0) do
    adds r9, r9, #0 ; check if r9 is negative
    mvnmi r9, r9 ; if r9 is negative, r9 = ~r9 (1's complement)
    addmi r9, r9, #1 ; if r9 is negative, r9 = r9 + 1 (2's complement)
    blmi negative

    ; else do
    blpl positive

    movvs r5, #1 ; move 1 to r5 if overflow

    subs r1, r1, #1 ; decrement loop times
    bne add_signed_sum ; loop if loop times are not zero
    ldr pc, [sp] ; branch to main function if loop times are zero

negative
    subs r7, r7, r9
    add lr, lr, #4 ; branch to `movvs r5, #1`
    mov pc, lr

positive
    adds r7, r7, r9
    mov pc, lr

add_unsigned_sum
    ldr r9, [r0], #4 ; r9 = *r0, r0 = r0 + 4
    adds r8, r8, r9
    movcs r6, #1 ; move 1 to r6 if overflow
    subs r1, r1, #1 ; decrement loop times
    bne add_unsigned_sum ; loop if loop times are not zero
    mov pc, lr ; branch to main function if loop times are zero

    
stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file