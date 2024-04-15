        AREA data, DATA, READONLY

n1 dcd 1
n2 dcd 1
num dcd 10 ;Number of items
Sequence space 40 ; Storage for the Fibonacci sequence
    
    AREA Fibon, CODE, READONLY ; name this block of code
    ENTRY ; mark first instruction

main
    ldr r1, n1 ; load first Fibonacci number (a1 = 1)
    ldr r2, n2 ; load second Fibonacci number (a2 = 1)
    ldr r3, num ; load the number of Fibonacci numbers to calculate
    ldr r4, =Sequence

    str r1, [r4], #4 ; *r4 = r1, r4 += 4
    str r2, [r4], #4 ; *r4 = r2, r4 += 4
    sub r3, r3, #2 ; decrement count
    bl fib_loop

    b stop ; stop the program

fib_loop
    add r0, r1, r2 ; an = an-1 + an-2
    str r0, [r4], #4 ; *r4 = r0, r4 += 4
    mov r1, r2 ; an-2 = an-1
    mov r2, r0 ; an-1 = an
    subs r3, r3, #1 ; decrement the loop counter
    bne fib_loop ; if count != 0, continue loop
    mov pc, lr ; return to main function

stop
    mov r0, #0x18               ; angel_SWIreason_ReportException
    ldr r1, =0x20026            ; ADP_Stopped_ApplicationExit
    swi 0x123456                ; ARM semihosting SWI

    end ; Mark end of file