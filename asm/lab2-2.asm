        AREA data, DATA, READONLY

matrixA dcd 1, 2, 3
        dcd 4, 5, 6

matrixB dcd 7, 8
        dcd 9, 10
        dcd 11, 12

matrixC dcd 0, 0
        dcd 0, 0

    AREA MatrixMultiplication, CODE, READONLY ; name this block of code
    ENTRY ; mark first instruction

main
    ldr r0, =matrixA
    ldr r1, =matrixB
    ldr r2, =matrixC

    mov r6, r0 ; backup the head pointer of matrixA
    mov r7, r1 ; backup the head pointer of matrixB

    mov r12, #3 ; calculation times
    mov r5, #0 ; sum = 0
    bl matrixMLA

    mov r0, r6 ; restore the head pointer of matrixA
    mov r1, r7 ; restore the head pointer of matrixB
    add r1, r1, #4 ; set 2nd column of matrixB
    mov r12, #3 ; calculation times
    mov r5, #0 ; sum = 0
    bl matrixMLA

    mov r0, r6 ; restore the head pointer of matrixA
    mov r1, r7 ; restore the head pointer of matrixB
    add r0, r0, #12 ; set 2nd row of matrixA
    mov r12, #3 ; calculation times
    mov r5, #0 ; sum = 0
    bl matrixMLA

    mov r0, r6 ; restore the head pointer of matrixA
    mov r1, r7 ; restore the head pointer of matrixB
    add r0, r0, #12 ; set 2nd row of matrixA
    add r1, r1, #4 ; set 2nd column of matrixB
    mov r12, #3 ; calculation times
    mov r5, #0 ; sum = 0
    bl matrixMLA

    b stop ; stop the program

matrixMLA
    ldr r3, [r0], #4 ; load an element from matrixA, r0 += 4 (horizontal direction)
    ldr r4, [r1], #8 ; load an element from matrixB, r1 += 8 (vertical direction)
    mla r5, r3, r4, r5 ; sum = r3 * r4 + r5

    subs r12, r12, #1 ; calculation times -= 1
    bne matrixMLA ; branch this loop if calculation times != 0
    str r5, [r2], #4 ; store the sum to matrixC, and move r2 pointer to next element
    mov pc, lr ; return main function

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file