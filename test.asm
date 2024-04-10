    AREA ArrayData, DATA, READWRITE

ArrayA
    DCD -10, 11
    
    AREA adder, CODE, READONLY ; mark first instruction
    ENTRY

start
    ldr r0, =ArrayA

    ; signed condition
    ldr r1, [r0]
    mov r2, #0
    ldr r3, [r0, #4]
    adds r5, r1, r3 ; update condition flag (cpsr: NzcV)
    adc r4, r0, r2  ; add with carry

    b stop

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file
