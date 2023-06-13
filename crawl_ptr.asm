mov crawl_addy, [0107A104]
mov oset, 0
mov ptr, 0
mov cur_addy, crawl_addy
mov end_addy, crawl_addy+2000
;cmp crawl_addy, 107BE0C
; 01091D7C     0107C36C     01080000


log "looping from {$cur_addy} to {end_addy} --- ptr is {$ptr}"


LOOP:

mov cur_addy, crawl_addy + oset
mov ptr, [cur_addy]
log "cur_addy is {$cur_addy + oset} +{oset} --- ptr is {$ptr}"
cmp $ptr, ffff
jle SKIP
cmp $ptr, 50000000
jge SKIP
; yes, sort cmd needs the fucking 0x
savedata Z:\tmp\crawl\0x{p:oset}_{p:ptr}.dmp, $ptr, 1000

SKIP:
mov oset, oset+4

cmp cur_addy, end_addy
jle LOOP



DONE:
ret
