CF (carry flag)
PF (parity flag)
AF (auxiliary carry)
ZF (zero flag)
SF (sign flag)
OF (overflow flag)
-------------------

jz target #if zf=1 (result = 0)

jc  target #if cf=1 (perenos)

jo target #if of=1 (perepolnenie)

js target #if sf=1 (negative)

jg - signed and ja - unsigned

-------------

clc - clear carry
cmc - complement carry (cf = !cf)
cld - direction flag clear
cli - interrupt flag clear

stc - set carry
std - set direction
sti - set interrupt

pushf/popf and (pushfd/popfd for 32-bit)

---------------

as professional:

1. test eax, eax # set zf=1 if eax=0
and eax, eax
or eax, eax

2 manybytes arithmetics
#128-bytes sum: RDX:RAX + RCX:RBX
add %rbx, %rax #sum low 64 byte
adc %rcx, $rdx # sum high 64 bye + CF

#128-byte sub
sub %rbx, $rax #sub low 64 byte
sub %rcx, %rdx #sub high 64 byte

4.  uslovnie move (cmov)
cmp $rbx, $rax
cmovg $rcxc $rdx $rdx = rcx if rax > rbx
cmoz %r8, %r9 $r9 = r8 if zf=1

