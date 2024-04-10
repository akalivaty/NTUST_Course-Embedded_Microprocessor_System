    AREA ArrayData, DATA, READWRITE

ArrayA
    ; DCD -10, 11, 20, 50, -20, -3
    DCD 0x7f000000, 0x7f000000, 0x7f000000;, 20, 50, -20, -3

    AREA adder, CODE, READONLY ; mark first instruction
num equ 6
    ENTRY

main
    ldr r1, =ArrayA
    mov r2, #num ; loop times
    mov r4, #0 ; sum
    mov r5, #0 ; set 1 if overflow
    str pc, [sp, #-4]! ; save main function address
    bl signed_adder
    b stop

signed_adder
    ldr r3, [r1], #4 ; load array element, then r1 = r1 + 4
    bl check_data
    sub r2, r2, #1 ; decrease loop times
    cmp r2, #0 ; check if loop times is 0
    bne signed_adder
    mov pc, lr ; run out of loop times, return main function

check_data
    cmp r3, #0
    bge positive ; jump to positive
    blt negative ; jump to negative

positive
    adds r4, r4, r3 ; sum
    movvs r5, #1 ; check if overflow
    mov pc, lr

negative
    mvn r3, r3 ; 1's complement
    add r3, r3, #1 ; 2's complement
    subs r4, r4, r3 ; sum
    movvs r5, #1 ; check if overflow
    mov pc, lr

stop
    mov r1, #0x18               ; angel_SWIreason_ReportException
    ldr r2, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file
