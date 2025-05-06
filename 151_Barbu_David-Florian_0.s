.section .note.GNU-stack

.data
    v:
    .rept 1024
        .long 0
    .endr
    findex: .long 0
    lindex: .long 0
    id: .long 0
    size: .long 0
    lenght: .long 0
    read_value: .long 0
    blockvalue: .long 8
    formatP: .asciz "%d: (%d, %d)\n"
    formatPGET: .asciz "(%d, %d)\n"
    formatR: .asciz "%d"
.text
addf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 12(%ebp), %eax
    xorl %edx, %edx
    divl blockvalue
    cmpl $0, %edx
    je continue
    addl $1, %eax
continue:
    movl 16(%ebp), %edx
    movl %eax, lenght
    xorl %ecx, %ecx

track_fid:
    cmpl $1024, %ecx
    jge no_space

    cmpl $0, (%edi, %ecx, 4)
    je found_f0

    addl $1, %ecx
    jmp track_fid

found_f0:
    movl %ecx, findex
    movl %ecx, lindex
    movl lenght, %eax

    cmpl $1, %eax
    je prepare_add

    addl $1, %ecx
    subl $1, %eax
    jmp track_lid

track_lid:
    cmpl $1024, %ecx
    jge no_space

    cmpl $0, (%edi, %ecx, 4)
    jne reset

    addl $1, %ecx
    decl %eax
    jnz track_lid

found_l0:
    subl $1, %ecx
    movl %ecx, lindex
    jmp prepare_add

reset:
    movl $0, findex
    movl $0, lindex
    addl $1, %ecx
    jmp track_fid

no_space:
    movl $0, findex
    movl $0, lindex
    jmp exit_add

prepare_add:
    movl findex, %ecx
    movl lindex, %ebx

add_memory:
    cmpl %ecx, %ebx
    jl exit_add

    movl %edx, (%edi, %ecx, 4)
    addl $1, %ecx
    jmp add_memory
    
exit_add:
    popl %ebp
    ret

getf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 12(%ebp), %edx
    xorl %ecx, %ecx

look_fid:
    cmpl $1024, %ecx
    jge not_found

    cmpl %edx, (%edi, %ecx, 4)
    je found_fid

    addl $1, %ecx
    jmp look_fid

found_fid:
    movl %ecx, findex
    addl $1, %ecx
    jmp look_lid

look_lid:
    cmpl $1024, %ecx
    jge found_lid

    cmpl %edx, (%edi, %ecx, 4)
    jne found_lid

    addl $1, %ecx
    jmp look_lid

found_lid:
    subl $1, %ecx
    movl %ecx, lindex
    jmp exit_get

not_found:
    movl $0, findex
    movl $0, lindex
    jmp exit_get

exit_get:
    popl %ebp
    ret

delf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 12(%ebp), %edx
    movl 16(%ebp), %ecx
    movl 20(%ebp), %ebx

delete:
    cmpl %ecx, %ebx
    jl exit_del

    movl $0, (%edi, %ecx, 4)
    addl $1, %ecx
    jmp delete

exit_del:
    popl %ebp
    ret

dfgf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 12(%ebp), %edx # id 
    movl 16(%ebp), %eax # number of blocks
    xorl %ecx, %ecx

add_tosapce:
    cmpl $1024, %ecx
    jge exit_dfg

    cmpl $0, (%edi, %ecx, 4)
    je found_toadd

    addl $1, %ecx
    jmp add_tosapce

found_toadd:
    movl %edx, (%edi, %ecx, 4)
    addl $1, %ecx
    decl %eax
    jnz found_toadd

exit_dfg:
    popl %ebp
    ret

print_vector:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    xorl %ecx, %ecx

iterate:    
    cmpl $1024, %ecx
    jge exit_print

    cmpl $0, (%edi, %ecx, 4)
    jne fid

    addl $1, %ecx
    jmp iterate

fid:
    movl %ecx, findex
    movl %ecx, lindex
    movl (%edi, %ecx, 4), %edx
    addl $1, %ecx
    jmp iterate_lid

iterate_lid:
    cmpl $1024, %ecx
    jge lid

    cmpl %edx, (%edi, %ecx, 4)
    jne lid

    addl $1, %ecx
    jmp iterate_lid

lid:
    subl $1, %ecx
    movl %ecx, lindex

    pushl %ecx
    pushl %edx

    pushl lindex
    pushl findex
    pushl %edx
    pushl $formatP
    call printf
    addl $16, %esp

    popl %edx
    popl %ecx

    addl $1, %ecx
    xorl %edx, %edx
    jmp iterate

exit_print:
    popl %ebp
    ret

.global main
main:
    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %ecx

read_operation:
    pushl %ecx

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %eax

    cmpl $1, %eax
    je readadd

    cmpl $2, %eax
    je readget

    cmpl $3, %eax
    je readdel

    cmpl $4, %eax
    je readdfg

readadd:
    # start of add part

    # read number of add operations
    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %ecx

id_space:
    pushl %ecx

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %edx
    movl %edx, id   # read the fd id

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %eax
    movl %eax, size   # read space storage of the fd

    pushl %edx

    pushl id
    pushl size
    pushl $v    
    call addf   # call add function
    addl $12, %esp

    popl %edx

    pushl lindex
    pushl findex
    pushl id
    pushl $formatP
    call printf
    addl $16, %esp

    popl %ecx
    decl %ecx
    jnz id_space    # jump back to read the remained add fds
    jmp read_another_op

    # end of add part

readget:
    # start of get part 


    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %edx
    movl %edx, id   # id of the fd

    pushl id
    pushl $v
    call getf
    addl $8, %esp

    pushl lindex
    pushl findex
    pushl $formatPGET
    call printf
    addl $12, %esp

    jmp read_another_op
    # end of get part

readdel:
    # start of delete part

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %edx   # read the fd's id that needs to be deleted
    movl %edx, id

    pushl id
    pushl $v
    call getf   # get the findex and lindex of the id
    addl $8, %esp

    cmpl $0, lindex
    je print_rest

    pushl lindex
    pushl findex
    pushl id
    pushl $v
    call delf
    addl $16, %esp

print_rest:

    pushl $v
    call print_vector
    addl $4, %esp

    jmp read_another_op

    # end of delete part

readdfg:
    # start of defragmentation part

    movl $v, %edi
    xorl %ecx, %ecx

iter:
    cmpl $1024, %ecx
    jge exit_it

    cmpl $0, (%edi, %ecx, 4)
    jne gotfid

    addl $1, %ecx
    jmp iter

gotfid:
    movl (%edi, %ecx, 4), %edx
    movl %edx, id

    pushl %ecx
    pushl %edx

    pushl id
    pushl $v
    call getf
    addl $8, %esp

    pushl lindex
    pushl findex
    pushl id
    pushl $v
    call delf
    addl $16, %esp 

    movl lindex, %eax
    addl $1, %eax
    subl findex, %eax
    movl %eax, lenght

    pushl lenght
    pushl id
    pushl $v
    call dfgf
    addl $12, %esp

    popl %edx
    popl %ecx

    movl lindex, %ecx
    addl $1, %ecx
    jmp iter

exit_it:
    pushl $v
    call print_vector
    addl $4, %esp

    jmp read_another_op

    # end of defragmentation part

read_another_op:
    popl %ecx
    decl %ecx
    jnz read_operation

flush:
    pushl $0
    call fflush
    popl %ebx

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
