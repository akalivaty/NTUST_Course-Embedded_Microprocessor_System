    AREA adder, CODE, READONLY ; mark first instruction
n1 dcd 30
    ENTRY

start
    ldr r0, n1
    mov r1, #1
    mov r2, #1
    mov r3, #1
    bl square_func

    b stop

square_func
    add r3, r3, #2
    add r2, r2, r3
    cmp r2, r0
    addlt r1, r1, #1
    blt square_func
    movgt pc, lr

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file