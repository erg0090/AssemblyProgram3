// pa3.S - Recursive Factorial Calculator
// ARMv8 assembly program that calculates the factorial of a user input integer using recursion

.data
prompt:     .asciz "Enter a non-negative integer: "
result_msg: .asciz "Factorial: "
input_fmt:  .asciz "%ld"
output_fmt: .asciz "%ld\n"
error_msg:  .asciz "Error: Please enter a non-negative integer.\n"
overflow_msg: .asciz "Error: Factorial result too large (overflow).\n"

.text
.global main
.balign 4

// Main function
main:
    // Save frame pointer and link register for recursion
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Print prompt message
    ldr x0, =prompt
    bl      printf

    // Read integer input
    sub     sp, sp, #16             // Allocate space for input
    mov     x2, sp                  // Address to store input
    ldr     x0, =input_fmt
    mov     x1, x2                  // Pass address to scanf
    bl      scanf

    // Load the input value
    ldr     x0, [sp]
    add     sp, sp, #16             // Restore stack

    // Check if input is negative
    cmp     x0, #0
    b.lt    negative_error

    // Call recursive factorial function
    bl      factorial

    // Save result
    mov     x19, x0

    // Print result message
    ldr x0, =result_msg
    bl      printf

    // Print factorial result
    ldr x0, =output_fmt
    mov     x1, x19
    bl      printf

    // Return success
    mov     x0, #0
    b       exit

negative_error:
    // Print error message for negative input
    ldr x0, =error_msg
    bl      printf
    mov     x0, #1                  // Return error code
    b       exit

overflow_error:
    // Print overflow error message
    ldr x0, =overflow_msg
    bl      printf
    mov     x0, #1                  // Return error code
    b       exit

// Recursive factorial function
// Input: x0 = n
// Output: x0 = n!
factorial:
    // Save link register and frame pointer
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Save input parameter
    stp     x0, x1, [sp, #-16]!

    // Base case: if n <= 1, return 1
    cmp     x0, #1
    b.le    base_case

    // Recursive case: return n * factorial(n-1)
    sub     x0, x0, #1              // n-1
    bl      factorial               // Call factorial(n-1)

    // Restore n and prepare for multiplication
    ldp     x1, x2, [sp], #16       // x1 = original n
    
    // Check for potential overflow before multiplying
    mul     x2, x0, x1              // Result = factorial(n-1) * n
    cmp     x2, x0                  // Check if result is smaller than previous
    b.lo    overflow_detect         // If so, overflow occurred
    
    mov     x0, x2                  // Store result in x0
    b       factorial_done

base_case:
    // Return 1 for base case
    mov     x0, #1
    ldp     x1, x2, [sp], #16       // Restore saved registers
    
factorial_done:
    // Restore registers and return
    ldp     x29, x30, [sp], #16
    ret

overflow_detect:
    // Clean up stack before jumping to error
    ldp     x29, x30, [sp], #16
    b       overflow_error

exit:
    // Restore registers and return
    ldp     x29, x30, [sp], #16
    ret
