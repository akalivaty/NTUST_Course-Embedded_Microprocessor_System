; main -> func1 -> func2 -> func3 -> 
; func2 -> func1 -> main

; sp (stack pointer) == r13
; lr (link register) == r14
; pc (program counter) == r15

    AREA adder, CODE, READONLY
    ENTRY

main
    add r0, pc, #4
    str r0, [sp]
    bl func1
    b stop

func1
    ; do something
    mov r4, #2
    mov r5, #3

    add r0, pc, #4
    str r0, [sp, #4]!
    bl func2

    ldr pc, [sp, #-4]! ; sp = sp -4, load lr from stack to pc

func2
    ; do something
    mov r4, #2
    mov r5, #3

    add r0, pc, #4
    str r0, [sp, #4]!
    bl func3

    ldr pc, [sp, #-4]! ; sp = sp -4, load lr from stack to pc

func3
    ; do something
    mov r4, #2
    mov r5, #3

    ldr pc, [sp]

stop
    mov r1, #0x18               ; angel_SWIreason_ReportException
    ldr r2, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end                         ; Mark end of file
