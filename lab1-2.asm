    AREA ArrayData, DATA, READWRITE

ArrayA
    DCD -10, 11, 20, 50, -20, -3 ; Declare an array of 6 elements

    AREA Matrix, CODE, READONLY

num equ 6   ; set the number of elements in the array

    ENTRY

start
    ldr r0, =ArrayA

    mov r1, #num ; loop times
    mov r7, #0 ; signed sum register
    mov r5, #0 ; set 1 if overflow
    bl add_signed_sum

    ; ldr r0, =ArrayA
    ; mov r1, #num ; loop times
    ; mov r8, #0 ; unsigned sum register
    ; mov r6, #0 ; set 1 if overflow
    ; bl add_unsigned_sum

    b stop

add_signed_sum
    ldr r9, [r0], #4 ; r9 = *r0, r0 = r0 + 4
    adds r7, r7, r9 ; sum with signed
    ; movvs r5, #1 ; move 1 to r5 if overflow
    sub r1, r1, #1
    bne add_signed_sum
    mov pc, lr

add_unsigned_sum
    ldr r9, [r0], #4 ; r9 = *r0, r0 = r0 + 4
    adds r8, r8, r9
    movvs r6, #1 ; move 1 to r6 if overflow
    sub r1, r1, #1
    bne add_unsigned_sum
    mov pc, lr

    
stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file