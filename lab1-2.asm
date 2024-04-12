    AREA ArrayData, DATA, READWRITE

ArrayA
    dcd -10, 11, 20, 50, -20, -3 ; Declare an array of 6 elements

    AREA Matrix, CODE, READONLY

num equ 6 ; set the number of elements in the array

    ENTRY

main
    ldr r0, =ArrayA ; load array to r0
    mov r1, r0 ; make copy of array head pointer

    ; sum signed numbers
    mov r3, #num ; loop times
    mov r7, #0 ; signed sum register
    mov r5, #0 ; set 1 if overflow (check V flag)
    ; record the return address
    add r4, pc, #4
    str r4, [sp]
    bl sum_signed_numbers ; branch sum_signed_numbers

    ; sum unsigned numbers
    mov r0, r1 ; reset head pointer of array
    mov r3, #num ; loop times
    mov r8, #0 ; unsigned sum register
    mov r6, #0 ; set 1 if overflow (check C flag)
    bl sum_unsigned_numbers ; branch sum_unsigned_numbers

    b stop
    
sum_signed_numbers
    ldr r9, [r0], #4 ; r9 = *r0, r0 = r0 + 4

    ; if (r9 < 0) do
    adds r9, r9, #0 ; check if r9 is negative
    mvnmi r9, r9 ; if r9 is negative, r9 = ~r9 (1's complement)
    addmi r9, r9, #1 ; if r9 is negative, r9 = r9 + 1 (2's complement)
    blmi negative_number ; branch to negative_number if r9 is negative

    ; else do
    blpl positive_number

    movvs r5, #1 ; move 1 to r5 if overflow (V=1)

    subs r3, r3, #1 ; decrement loop times
    bne sum_signed_numbers ; loop if r3 (loop times) are not zero
    ldr pc, [sp] ; branch to main function if r3 == 0

negative_number
    subs r7, r7, r9 ; r7 = r7 - r9
    add lr, lr, #4 ; increment return address
    mov pc, lr  ; reutrn

positive_number
    adds r7, r7, r9 ; r7 = r7 + r9
    mov pc, lr ; return

sum_unsigned_numbers
    ldr r9, [r0], #4 ; r9 = *r0, r0 = r0 + 4
    adds r8, r8, r9 ; r8 = r8 + r9
    movcs r6, #1 ; move 1 to r6 if overflow (C=1)
    subs r3, r3, #1 ; decrement loop times
    bne sum_unsigned_numbers ; loop if loop times are not zero
    mov pc, lr ; branch to main function if loop times are zero

    
stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file