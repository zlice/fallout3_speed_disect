; x64dbg script
; asm like syntax

; log buffer too small to do more than 50? don't use data?
mov cnt, 55
jmp FRWD

mov anim_addy, 66DF08C
mov anim_sz, [anim_addy+4]
mov anim_type, [anim_addy+8]

log "starting BACK crawl"
log "addy: {$anim_addy} --- size: {$anim_sz} --- type: {$anim_type}"
;log "{mem;$anim_sz@$anim_addy+8}"

LOOP:

mov anim_addy, [anim_addy]
mov anim_sz, [anim_addy+4]
mov anim_type, [anim_addy+8]

;cmp anim_type, 17
;jne SKIP
log "==============="
log "addy: {$anim_addy} --- size: {$anim_sz} --- type: {$anim_type}"
cmp anim_sz, 40000000
jge SKIP
log "{mem;$anim_sz@$anim_addy+8}"
SKIP:

dec cnt
test cnt, cnt
jnz LOOP

jmp END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FRWD:

mov cnt, 55

log "starting FRWD crawl"

mov anim_addy, 67920E8
mov anim_sz, [anim_addy+4]
mov anim_type, [anim_addy+8]
;mov anim_addy, [anim_addy+anim_sz]

log "addy: {$anim_addy} --- size: {$anim_sz} --- type: {$anim_type}"

LOOPF:

mov anim_addy, anim_addy+anim_sz+8
mov anim_sz, [anim_addy+4]
mov anim_type, [anim_addy+8]

log "==============="
log "addy: {$anim_addy} --- size: {$anim_sz} --- type: {$anim_type}"
cmp anim_sz, 40000000
jge SKIPF
log "{mem;$anim_sz@$anim_addy+8}"
jmp SKIPFF
SKIPF:
xor anim_sz, 40000000

SKIPFF:
dec cnt
test cnt, cnt
jnz LOOPF

END:

ret
