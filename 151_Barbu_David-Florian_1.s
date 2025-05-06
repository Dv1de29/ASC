.section .note.GNU-stack

.data
    v:
    .rept 1048576
        .long 0
    .endr
    findex: .long 0
    lindex: .long 0
    id: .long 0
    size: .long 0
    lenght: .long 0
    remrow: .long 0
    path: .space 1024000
    read_value: .long 0
    blockvalue: .long 8
    row_size: .long 1024
    formatP: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatPGET: .asciz "((%d, %d), (%d, %d))\n"
    formatR: .asciz "%d"
    stringformat: .asciz "%s"
    stringprint: .asciz "%s\n"
    error_text: .asciz "The path is not valid"
    buffer: .space 1024
    stat_buffer: .space 1024
    singlepoint: .asciz "."
    doublepoint: .asciz ".."
    formatbuild: .asciz "%s/%s"
    file: .space 256
    formatconc: .asciz "%d:\n%d:\n%d: ((%d, %d), (%d, %d))\n"
    rempath: .space 1024

.text
addf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 16(%ebp), %eax
    xorl %edx, %edx
    divl blockvalue
    cmpl $0, %edx
    je continue
    addl $1, %eax

continue:
    movl 12(%ebp), %edx # id that needs to be stored
    movl %edx, id
    movl %eax, lenght   # number of blocks that the fd will ocuppy
    xorl %ebx, %ebx

iterate_row:
    cmpl $1024, %ebx
    jge no_space

    pushl %ebx

    movl %ebx, %eax
    xorl %edx, %edx
    mull row_size
    movl %eax, %ebx

    xorl %ecx, %ecx

iterate_col:
    cmpl $1024, %ecx
    jge exit_row

    cmpl $0, (%edi, %ebx, 4)
    je found_f0

    addl $1, %ecx
    addl $1, %ebx
    jmp iterate_col

found_f0:
    movl %ecx, findex
    movl %ecx, lindex
    addl $1, %ecx
    addl $1, %ebx
    movl lenght, %eax
    subl $1, %eax
    jmp find_l0

find_l0:
    cmpl $1024, %ecx
    jge exit_row

    cmpl $0, (%edi, %ebx, 4)
    jne reset

    addl $1, %ecx
    addl $1, %ebx
    decl %eax
    jnz find_l0
    jmp found_l0

found_l0:
    subl $1, %ecx
    movl %ecx, lindex
    movl lenght, %eax
    subl %eax, %ebx
    movl id, %edx
    jmp add_memory 
    
reset:
    movl $0, findex
    movl $0, lindex
    addl $1, %ecx
    addl $1, %ebx
    jmp iterate_col

exit_row:
    movl $0, findex
    movl $0, lindex
    popl %ebx   # restore row
    addl $1, %ebx   # increase row
    jmp iterate_row

no_space:
    movl $0, findex
    movl $0, lindex
    xorl %ebx, %ebx
    jmp exit_add

add_memory:
    movl %edx, (%edi, %ebx, 4)
    addl $1, %ebx
    decl %eax
    jnz add_memory
    popl %ebx

exit_add:
    popl %ebp
    ret

getf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    xorl %ebx, %ebx

track_row:
    cmpl $1024, %ebx
    jge not_found

    pushl %ebx

    movl %ebx, %eax
    xorl %edx, %edx
    mull row_size
    movl %eax, %ebx

    xorl %ecx, %ecx
    movl 12(%ebp), %edx # id of the fd to find

track_fid:
    cmpl $1024, %ecx
    jge exit_r

    cmpl %edx, (%edi, %ebx, 4)
    je found_fid

    addl $1, %ecx
    addl $1, %ebx
    jmp track_fid

found_fid:
    movl %ecx, findex
    movl %ecx, lindex
    addl $1, %ecx
    addl $1, %ebx
    jmp track_lid

track_lid:
    cmpl $1024, %ecx
    jge found_lid

    cmpl %edx, (%edi, %ebx, 4)
    jne found_lid

    addl $1, %ecx
    addl $1, %ebx
    jmp track_lid

found_lid:
    subl $1, %ecx
    movl %ecx, lindex
    popl %ebx
    jmp exit_get

exit_r:
    popl %ebx
    addl $1, %ebx
    jmp track_row

not_found:
    movl $0, lindex
    movl $0, findex
    xorl %ebx, %ebx
    jmp exit_get

exit_get:
    popl %ebp
    ret

delf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 12(%ebp), %eax
    xorl %edx, %edx
    mull row_size
    movl %eax, %ebx
    addl 16(%ebp), %ebx
    addl 20(%ebp), %eax

delete:
    cmpl %ebx, %eax
    jl exit_del

    movl $0, (%edi, %ebx, 4)
    addl $1, %ebx
    jmp delete

exit_del:
    popl %ebp
    ret

dfgf:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    movl 20(%ebp), %eax
    xorl %edx, %edx
    mull row_size
    movl %eax, %ebx

    pushl %ebx
    movl 12(%ebp), %edx
    movl %edx, id
    movl 16(%ebp), %eax
    movl %eax, lenght
    xorl %ecx, %ecx

search_space:
    cmpl $1024, %ecx
    jge not_this_row

    cmpl $0, (%edi, %ebx, 4)
    je found_fspace

    addl $1, %ecx
    addl $1, %ebx
    jmp search_space

found_fspace:
    addl lenght, %ecx
    cmpl $1024, %ecx
    jg not_this_row
    jmp realocate

not_this_row:
    addl $1, remrow
    popl %ebx
    addl $1024, %ebx

next_row:
    movl %edx, (%edi, %ebx, 4)
    addl $1, %ebx
    decl %eax
    jnz next_row
    jmp exit_dfg

realocate:
    movl %edx, (%edi, %ebx, 4)
    addl $1, %ebx
    decl %eax
    jnz realocate

    popl %ebx
    jmp exit_dfg

exit_dfg:
    popl %ebp
    ret

print_vector:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edi
    xorl %ebx, %ebx

look_row:
    cmpl $1024, %ebx
    jge exit_print

    pushl %ebx

    movl %ebx, %eax
    xorl %edx, %edx
    mull row_size
    movl %eax, %ebx

    xorl %ecx, %ecx

look_fid:
    cmpl $1024, %ecx
    jge e_row

    cmpl $0, (%edi, %ebx, 4)
    jne first_id

    addl $1, %ebx
    addl $1, %ecx
    jmp look_fid

first_id:
    movl (%edi, %ebx, 4), %edx
    movl %ecx, findex
    addl $1, %ebx
    addl $1, %ecx
    jmp look_lid

look_lid:
    cmpl $1024, %ecx
    jge last_id

    cmpl %edx, (%edi, %ebx, 4)
    jne last_id

    addl $1, %ebx
    addl $1, %ecx
    jmp look_lid

last_id:
    subl $1, %ecx
    movl %ecx, lindex
    
    pushl %ebx
    pushl %ecx
    pushl %edx

    pushl lindex
    pushl -4(%ebp)
    pushl findex  # row number
    pushl -4(%ebp)
    pushl %edx
    pushl $formatP
    call printf
    addl $24, %esp

    popl %edx
    popl %ecx
    popl %ebx

    addl $1, %ecx
    jmp look_fid

e_row:
    popl %ebx
    addl $1, %ebx
    jmp look_row

exit_print:
    popl %ebp
    ret

addconc:
    pushl %ebp
    movl %esp, %ebp

    movl $0, lindex
    movl $0, findex

    movl path, %eax

    movl $8, blockvalue

    movl 16(%ebp), %edi
    movl 8(%ebp), %eax
    xorl %edx, %edx
    divl blockvalue
    cmpl $0, %edx
    je cont_1

    incl %eax       # number of blocks
    movl %eax, size

cont_1:
    movl 12(%ebp), %edx  # id
    movl %edx, id
    xorl %ebx, %ebx

row_loop:
    cmpl $1024, %ebx
    jge row_notfound

    pushl %ebx

    pushl %eax
    pushl %edx

    movl %ebx, %eax
    xorl %edx, %edx
    mull row_size
    movl %eax, %ebx
    xorl %ecx, %ecx

    popl %edx
    popl %eax

cauta_f0:
    cmpl $1024, %ecx
    jge rand_gresit

    movl size, %eax

    cmpl %edx, (%edi, %ebx, 4)
    je row_notfound

    cmpl $0, (%edi, %ebx, 4)
    je gasit_f0

    incl %ecx
    incl %ebx
    jmp cauta_f0

gasit_f0:
    movl %ecx, findex
    movl %ecx, lindex
    incl %ecx
    incl %ebx
    jmp cauta_l0

cauta_l0:
    cmpl $1024, %ecx
    jge rand_gresit

    cmpl %edx, (%edi, %ebx, 4)
    je row_notfound

    cmpl $0, (%edi, %ebx, 4)
    jne check

    incl %ecx
    incl %ebx
    decl %eax
    jnz cauta_l0

check:
    cmpl $0, %eax
    jne cauta_f0

    movl %ecx, lindex
    movl size, %eax
    subl %ecx, %ebx
    addl findex, %ebx

adding:
    movl %edx, (%edi, %ebx, 4)
    incl %ebx
    decl %eax
    jnz adding

    popl %ebx
    jmp exit_addconc

rand_gresit:
    movl $0, lindex
    movl $0, findex
    popl %ebx
    incl %ebx
    jmp row_loop

row_notfound:
    xorl %ebx, %ebx
    movl $0, lindex
    movl $0, findex
    jmp exit_addconc

exit_addconc:
    popl %ebp
    ret

.global main
main:
    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %ecx    # number of operations

read_operation:
    pushl %ecx

    pushl $read_value
    pushl $formatR
    call scanf  
    addl $8, %esp

    movl read_value, %eax   # code of the operation
    cmpl $1, %eax
    je readadd

    cmpl $2, %eax
    je readget

    cmpl $3, %eax
    je readdel

    cmpl $4, %eax
    je readdfg

    cmpl $5, %eax
    je readconc

readadd:
    # start of add part

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %ecx   # number of add fd

id_space:
    pushl %ecx

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl  read_value, %edx  # id of the fd
    movl %edx, id

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %eax   # size for the fd
    movl %eax, size

    pushl size
    pushl id
    pushl $v
    call addf
    addl $12, %esp

    pushl lindex
    pushl %ebx
    pushl findex
    pushl %ebx
    pushl id
    pushl $formatP
    call printf
    addl $24, %esp

    popl %ecx

    decl %ecx
    jnz id_space

    jmp read_another_op

    # end of add part

readget:
    # start of get part

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %edx
    movl %edx, id   # id of the fd to find

    pushl id
    pushl $v
    call getf
    addl $8, %esp

    pushl lindex
    pushl %ebx
    pushl findex
    pushl %ebx
    pushl $formatPGET
    call printf
    addl $20, %esp

    jmp read_another_op

    # end of get part

readdel:
    # start of delete part

    pushl $read_value
    pushl $formatR
    call scanf
    addl $8, %esp

    movl read_value, %edx
    movl %edx, id   # id of the fd that need to be deleted

    pushl id
    pushl $v
    call getf
    addl $8, %esp

    cmpl $0, lindex
    je print_rest

    # this jumps directly to printing the vector if the lindex is 0 because if the fd's sizes cannot be lower than 9 it means the lindex must be greater than 0
    # cmpl $0, lindex   
    # je print_rest

    pushl lindex
    pushl findex
    pushl %ebx
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
    movl $0, remrow

iter:
    cmpl $1048576, %ecx
    jge exit_ir

    cmpl $0, (%edi, %ecx, 4)
    jne searched_id

    addl $1, %ecx
    jmp iter

searched_id:
    movl (%edi, %ecx, 4), %edx
    movl %edx, id

    pushl %ecx

    pushl id
    pushl $v
    call getf
    addl $8, %esp

    pushl lindex
    pushl findex
    pushl %ebx
    pushl $v
    call delf
    addl $16, %esp

    movl lindex, %eax
    addl $1, %eax
    subl findex, %eax
    movl %eax, lenght

    pushl remrow
    pushl lenght
    pushl id
    pushl $v
    call dfgf
    addl $16, %esp

    popl %ecx
    addl lenght, %ecx
    addl $1, %ecx
    jmp iter

exit_ir:
    pushl $v 
    call print_vector
    addl $4, %esp

    jmp read_another_op

    # end of defragmentation part

readconc:
    # start of concrete part

    pushl $path
    pushl $stringformat
    call scanf
    addl $8, %esp

    pushl $path
    call opendir        # %eax = opendir(path)
    addl $4, %esp

    movl %eax, %esi     # dir pointer

    cmpl $0, %esi
    je error_opening

    movl %esi, buffer  # auxiliar for *dir

readdir_loop:

    pushl %esi
    call readdir
    addl $4, %esp

    movl %eax, %edi

    cmpl $0, %edi
    je close_dir

    addl $11, %edi      # d_name pointer
    
assurance:
    cmpl $0x2e, (%edi)    # if edi == "."
    je next_file

    cmpl $0x2e2e, (%edi)       # if edi == ".."
    je next_file

   # pushl %edi
   # pushl $stringprint
   # call printf
   # addl $8, %esp

    pushl %edi
    pushl $path
    pushl $formatbuild
    pushl $1024
    pushl $file
    call snprintf
    addl $20, %esp

    movl $5, %eax       # open(file, 0_RNDLY)
    movl $file, %ebx
    movl $0, %ecx
    int $0x80

    cmpl $0, %eax       # error not opening file
    jl readdir_loop

    movl %eax, %edi     # esi = file descriptor

    movl $108, %eax     # fstat(fd, &file_stat)
    movl %edi, %ebx
    movl $stat_buffer, %ecx
    int $0x80

    cmpl $0, %eax
    jl readdir_loop

    movl %edi, %eax
    movl $255, %ebx
    xorl %edx, %edx
    divl %ebx
    movl %edx, %eax
    incl %eax               # file id
    movl %eax, id

    movl $stat_buffer, %eax
    addl $44, %eax
    movl (%eax), %edx       # file size
    movl %edx, %eax
    xorl %edx, %edx
    divl row_size
    movl %eax, size

    pushl %eax
    pushl %edi

    pushl $v
    pushl id
    pushl size
    call addconc
    addl $12, %esp

    popl %edi
    popl %eax

    pushl %ebx
    pushl lindex
    pushl %ebx
    pushl findex
    pushl id
    pushl %eax
    pushl id  # fd fara mod 255 + 1
    pushl $formatconc
    call printf
    addl $32, %esp

    movl $6, %eax
    movl $file, %ebx
    int $0x80

    jmp readdir_loop

next_file:
    jmp readdir_loop

close_dir:
    pushl %esi
    call closedir       # closedir(dir)
    addl $4, %esp

    jmp read_another_op

error_opening:
    pushl $error_text
    pushl $stringprint
    call printf
    addl $8, %esp

    jmp read_another_op


    # end of concrete part

read_another_op:
    popl %ecx
    decl %ecx
    jnz read_operation

flush:
    pushl $0
    call fflush
    addl $4, %esp

et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
    