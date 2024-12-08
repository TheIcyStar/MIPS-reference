#set page(
  margin: 0.25in,
)

#grid(
  columns: (48%, 48%),
  column-gutter: (2%),
  [
    = Data types
    #table(
      columns: (auto, auto, auto, auto),
      [*Type*], [*Size*], [*Signed Range*], [*Unsigned*],
      [.byte], [1 Byte ($2^8$)], [-128 to 127], [0 to 255],
      [.half], [2 Bytes ($2^16$)], [-32,768\ to 32,767], [0 to 65,535],
      [.word], [4 Bytes ($2^32$)], [-2,147,483,648 to 2,147,483,647], [0 to 4,294,967,295],
    )
    #table(
      columns: (auto, auto, auto),
      [*Type*], [*Size*], [*Information*],
      [.float], [32 Bits], [IEEE Floating point number],
      [.double], [64 Bits], [IEEE Floating point number],
      [.ascii], [$4n$ Bytes], [ASCII String with length $n$],
      [.asciiz], [$4n+4$ Bytes], [NULL terminated ASCII String with length $n$],
      [.space `<n>`], [<$n$> Bytes], [$n$ bytes of uninitialized memory]
    )

    Variable declaration format: \ `myVariable: .dataType someValue`\

  ],
  [
    = List of Registers
    #table(
      columns: (auto, auto, auto),
      [*Register Name*], [*Register ID*], [*Register Usage*],
      [`$zero`],[`$0`],[Zero constant],
      [`$at`],[`$1`],[Assembler Temporary],
      [`$v0-$v1`],[`$2-$3`],[Function Result\ (low/high)],
      [`$a0-$a3`],[`$4-$7`],[Argument registers],
      [`$t0-$t7`],[`$8-$15`],[Temporary registers],
      [`$s0-$s7`],[`$16-$23`],[Saved Registers],
      [`$t8-$t9`],[`$24-$25`],[Temporary registers],
      [`$k0-$k1`],[`$26-$27`],[Reserved for OS kernel],
      [`$gp`],[`$28`],[Global pointer],
      [`$sp`],[`$29`],[Stack pointer],
      [`$fp`],[`$30`],[Frame pointer],
      [`$ra`],[`$31`],[Return address],
      [`$f0-$f31`],[],[Floating point registers\*]
    )
    Note: `$f0-$f31` have varying usage, like `$t0`, `$s0`, and `$a0`.
  ]
)


= Available Services for `syscall`
#table(
  columns: (auto, auto, auto, auto),
  align: (right, left, left, left),
  [*`$v0` code*],[*Service*],[*Arguments*], [*Return Values*],
  [1],[Print integer],[*`$a0`* - Integer to print],[],
  [2],[Print float],[*`$f12`* - Float to print],[],
  [3],[Print double],[*`$f12`* - Double to print ],[],
  [4],[Print string],[*`$a0`* - address of null-terminated string to print],[],
  [5],[Read integer],[],[*`$v0`* - Integer read],
  [6],[Read float],[],[*`$f0`* - Float read],
  [7],[Read double],[],[*`$f0`* - Double read],
  [8],[Read string],[*`$a0`* - Address of string input buffer \ *`$a1`* - Max bytes to read (i.e. length)],[],
  [9],[sbrk (Allocate heap memory)],[*`$a0`* - Bytes to allocate],[*`$v0`* - Address of allocated heap],
  [10],[Exit with 0 code (terminate)],[],[],
  [11],[Print character],[*`$a0`* - Character to print],[],
  [12],[Read character],[],[],
  [13],[Open file],[*`$a0`* - Address of null-terminated string of file path\ *`$a1`* - Flags\ *`$a2`* - Mode],[*`$v0`* - File descriptor, or negative if error],
  [14],[Read from file],[*`$a0`* - File descriptor\ *`$a1`* - Address of input buffer\ *`$a2`* - Max number of characters to read],[*`$v0`* - Number of bytes read, 0 if end of file, negative if error],
  [15],[Write to file],[*`$a0`* - File descriptor\ *`$a1`* - Address of output buffer\ *`$a2`* - Max number of characters to write],[*`$v0`* - Number of bytes written, 0 if end of file, negative if error],
  [16],[Close file],[*`$a0`* - File descriptor],[*`$v0`* - 0],
  [17],[Exit with code (terminate)],[*`$a0`* - Exit code],[],
)

//Second page
= MIPS Assembly Instructions
#grid(
  columns: (35%, 35%, auto),
  [
    *R-Format Instructions*
    - *op* [6 bits]: opcode, always 000000
    - *rs* [5 bits]: 1st register source operand
    - *rt* [5 bits]: 2st register source operand
    - *rd* [5 bits]: Destination register
    - *shamt* [5 bits]: Shift amount
    - *funct* [6 bits]: Function code (See table)
  ],
  [
    *I-Format Instructions*
    - *op* [6 bits]: opcode (See table)
    - *rs* [5 bits]: 1st register source operand
    - *rt* [5 bits]: Destination operand
    - *immediate* [16 bits]: Constant or address
  ],
  [
    *J-Format Instructions*
    - *op* [6 bits]: opcode
    - *address* [26 bits]: Address of target label
  ],
)

#grid(
  columns: (16%, 24%, 22%, 6fr, 5fr, 5fr, 5fr, 5fr, 6fr),
  rows: (16pt),
  stroke: black,
  align: (left+horizon),
  inset: (4pt),

  [*Instruction*],[*Name*],[*Action*],grid.cell(colspan: 6, [*Machine Code Bitfields*]),
  grid.cell(colspan: 9, [#h(2%) _Arithmetic / Logic instructions_]),
  //add
  [ADD rd, rs, rt],[Add],[rd=rs+rt], [`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100000`],
  [ADDU rd, rs, rt],[Add unsigned],[rd=rs+rt], [`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100001`],
  [ADDI rt, rs, imm],[Add immediate],[rt=rs+imm], [`001000`],[`rs`],[`rt`], grid.cell(colspan: 3, [imm]),
  // [ADDIU rt, rs,imm],[Add immediate unsigned],[rt=rs+imm], [`001001`],[`rs`],[`rt`], grid.cell(colspan: 3, [imm]),

  //subtract
  [SUB rd, rs, rt],[Subtract],[rd=rs-rt], [`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100010`],
  [SUBU rd, rs, rt],[Subtract unsigned],[rd=rs-rt], [`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100011`],
  [SUBI rd, rs, imm],[Subtract immediate], grid.cell(colspan: 7, [(Converted by assembler)\*]),
  //Learned something new today: SUBI does not appear to exist, the assembler just uses ADDI then SUB!

  //logical
  [AND rd,rs,rt],[Bitwise AND],[rd=rs&rt],[`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100100`],
  // [ANDI rd,rs,imm],[Logical AND immediate],[rd=rs&imm],[`001100`],[`rs`],[`rt`],grid.cell(colspan: 3, [imm]),
  [OR rd,rs,rt],[Bitwise OR],[rd=rs|rt],[`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100101`],
  // [ORI rd,rs,imm],[Logical OR immediate],[rd=rs|imm],[`001101`],[`rs`],[`rt`],grid.cell(colspan: 3, [imm]),
  [XOR rd,rs,rt],[Bitwise XOR],[rd=rs$xor$rt],[`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100110`],
  // [XORI rd,rs,imm],[Logical XOR immediate],[rd=rs$xor$imm],[`001110`],[`rs`],[`rt`],grid.cell(colspan: 3, [imm]),
  [NOR rd,rs,rt],[Bitwise NOR],[rd=!(rs|rt)],[`000000`],[`rs`],[`rt`],[`rd`],[`00000`],[`100111`],


  grid.cell(colspan: 9, [#h(2%) _Multiply / Divide_]),
  //multiply
  [MULT rs, rt],[Multiply],[HI, LO = rs*rt],[`000000`],[`rs`],[`rt`],grid.cell(colspan: 2, [`00000 00000`]), [`011000`],
  [MULTU rs, rt],[Multiply unsigned],[HI, LO = rs*rt],[`000000`],[`rs`],[`rt`],grid.cell(colspan: 2, [`00000 00000`]), [`011001`],
  [DIV rs, rt],[Divide],[HI=rs%rt; LO=rs/rt],[`000000`],[`rs`],[`rt`],grid.cell(colspan: 2, [`00000 00000`]), [`011010`],
  [DIVU rs, rt],[Divide unsigned],[HI=rs%rt; LO=rs/rt],[`000000`],[`rs`],[`rt`],grid.cell(colspan: 2, [`00000 00000`]), [`011011`],
  //HI/LO moves
  [MFHI rd],[Move from HI],[rd=HI],[`000000`],grid.cell(colspan: 2, [`00000 00000`]),[`rd`],[`00000`],[`010000`],
  [MFLO rd],[Move from LO],[rd=LO],[`000000`],grid.cell(colspan: 2, [`00000 00000`]),[`rd`],[`00000`],[`010010`],
  [MTHI rs],[Move to HI],[HI=rs],[`000000`],[`rs`],grid.cell(colspan: 3, [`00000 00000 00000`]),[`010001`],
  [MTLO rs],[Move to LO],[LO=rs],[`000000`],[`rs`],grid.cell(colspan: 3, [`00000 00000 00000`]),[`010011`],


  grid.cell(colspan: 9, [#h(2%) _Branching_]),
  [B offset],[Branch unconditionally],[pc+=offset*4],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [BEQ rs, rt, offset],[Branch if equal],[if rs==rt: pc+=offset*4],[`000100`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  [BNE rs, rt, offset],[Branch if not equal],[if rs!=rt: pc+=offset*4],[`000101`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  [BGT rs, rt, offset],[Branch if >],[if rs>rt: pc+=offset*4],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [BGE rs, rt, offset],[Branch if >=],[if rs>=rt: pc+=offset*4],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [BGEZ rs, offset],[Branch if >= 0],[if rs>=0: pc+=offset*4],[`000001`],[`rs`],[`00001`],grid.cell(colspan: 3, [offset]),
  [BLT rs, rt, offset],[Branch if <],[if rs\<rt: pc+=offset*4],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [BLE rs, rt, offset],[Branch if <=],[if rs<=rt: pc+=offset*4],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [BLEZ rs, offset],[Branch if <= 0],[if rs<=0: pc+=offset*4],[`000110`],[`rs`],[`00000`],grid.cell(colspan: 3, [offset]),
  [J target],[Jump],[pc=pc_upper|(target<\<2)],[`000010`],grid.cell(colspan: 5, [target]),
  [JAL target],[Jump and link],[`$ra`=pc; pc=target<\<2],[`000011`],grid.cell(colspan: 5, [target]),
  [JR rs],[Jump register (used w/`$ra`)],[pc=rs],[`000000`],[`rs`],grid.cell(colspan: 3, [`00000 00000 00000`]),[`001000`],
  [SYSCALL],[System call],[epc=pc; pc=0x3c],[`000000`],grid.cell(colspan: 4, [`00000 00000 00000 00000`]), [`001100`],


  grid.cell(colspan: 9, [#h(2%) _Memory and Data Management_]),
  // [LB rt,offset(rs)],[Load byte],[rt=\*(b\*)(offset+rs)],[`100000`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  // [LH rt,offset(rs)],[Load halfword],[rt=\*(hw\*)(offset+rs)],[`100001`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  [LW rt, offset(rs)],[Load word from memory],[rt=\*(int\*)(offset+rs)],[`100011`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  // [SB rt,offset(rs)],[Store byte],[\*(b\*)(offset+rs)=rt],[`101000`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  // [SH rt,offset(rs)],[Store half],[\*(hw\*)(offset+rs)=rt],[`101001`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  [SW rt, offset(rs)],[Store word to memory],[\*(int\*)(offset+rs)=rt],[`101011`],[`rs`],[`rt`],grid.cell(colspan: 3, [offset]),
  [LI rd, imm],[Load immediate],[rd=imm],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [LA rd, label],[Load address of variable],[rd=(label address)],grid.cell(colspan: 6, [(Converted by assembler)\*]),
  [MOVE rd, rs],[Copy register contents],[rd=rs],grid.cell(colspan: 6, [(Converted by assembler)\*]),
)

\* Instruction is not basic; it gets turned into one or more basic instructions by the assembler.
