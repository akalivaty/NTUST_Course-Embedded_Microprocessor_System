    AREA data, DATA, READONLY

n1 dcd 18
n2 dcd 48

    AREA GCD, CODE, READONLY ; name this block of code
    ENTRY ; mark first instruction
    
main
    ldr r1, n1 ; load value of n1
    ldr r2, n2 ; load value of n2

    add r3, pc, #4 ; save return address
    str r3, [sp]
    bl gcd_loop ; branch to gcd_loop

    b stop ; Stop the program

; Loop to find GCD
gcd_loop
    cmp r1, r2 ; compare r1 and r2
    beq gcd_done ; if r1 == r2, GCD found
    subgt r1, r1, r2 ; else if r1 > r2, r1 = r1 - r2
    sublt r2, r2, r1 ; else r1 = r2 - r1
    b gcd_loop ; repeat loop

gcd_done
    mov r0, r1 ; Move result (GCD) to r0
    ldr pc, [sp]

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file