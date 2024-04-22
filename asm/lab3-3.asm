    AREA Data, DATA, READWRITE
M dcd -1, 3, 8
  dcd 7, 12, -3
  dcd 3, 2, 3

det dcd 0
    
    AREA adder, CODE, READONLY ; mark first instruction
    ENTRY

start
    ldr r0, =M
    ldr r10, =det
    mov r1, r0 ; backup the head pointer
    mov r12, #0

    bl cal1
    bl cal2
    bl cal3

    str r12, [r10] ; store the result into det

    b stop

cal1
    mov r0, r1
    ldr r2, [r0]
    ldr r3, [r0, #32]!
    mul r4, r2, r3

    mov r0, r1
    ldr r5, [r0, #8]!
    ldr r6, [r0, #16]!
    mul r7, r5, r6

    sub r8, r4, r7

    mov r0, r1
    ldr r2, [r0, #16]!
    mla r12, r8, r2, r12
    
    mov pc, lr
cal2
    mov r0, r1
    ldr r2, [r0, #4]!
    ldr r3, [r0, #20]!
    mul r4, r2, r3

    mov r0, r1
    ldr r5, [r0]
    ldr r6, [r0, #28]!
    mul r7, r5, r6

    sub r8, r4, r7

    mov r0, r1
    ldr r2, [r0, #20]!
    mla r12, r8, r2, r12
    
    mov pc, lr
cal3
    mov r0, r1
    ldr r2, [r0, #8]!
    ldr r3, [r0, #20]!
    mul r4, r2, r3

    mov r0, r1
    ldr r5, [r0, #4]!
    ldr r6, [r0, #28]!
    mul r7, r5, r6

    sub r8, r4, r7

    mov r0, r1
    ldr r2, [r0, #12]!
    mla r12, r8, r2, r12
    
    mov pc, lr

    

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file