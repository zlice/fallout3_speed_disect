;
; note: if you player.additem 4340 20 (20 missle launchers)
;       and get over-encumbered, none of these "player speed" calls break
;       once you remove enough weight to not be over-encumbered they will get called
;       your "player speed" is essentially "stuck"
;

;
; this code is actually after the get/set_speed() in memory
; but if while running it's called first as a wrapper


0x00584710    push ecx
0x00584711    mov eax,dword ptr ss:[esp+1C]       ; crouch/sneak_mult    0x200(512) or 0x601(1537)
0x00584715    fld st(0),dword ptr ss:[esp+C]      ; 0xe18101(14778625)
0x00584719    mov ecx,dword ptr ss:[esp+14]       ; bool is_wep_holstered?    0 or 1
0x0058471D    mov edx,dword ptr ss:[esp+10]
0x00584721    push eax
0x00584722    mov eax,dword ptr ss:[esp+1C]
0x00584726    push ecx
0x00584727    push edx
0x00584728    push eax
0x00584729    push ecx
0x0058472A    mov ecx,dword ptr ss:[esp+1C]
0x0058472E    fstp dword ptr ss:[esp],st(0)
0x00584731    push ecx
0x00584732    call fallout3.5845B0                ; real_speed_town()
0x00584737    fadd st(0),qword ptr ds:[DB38B0]
0x0058473D    fstp dword ptr ss:[esp+18],st(0)
0x00584741    fld st(0),dword ptr ds:[F61098]     ; F61098 (fMoveRunMult)
0x00584747    fmul st(0),dword ptr ss:[esp+18]
0x0058474B    fstp dword ptr ss:[esp+18],st(0)    ; puts speed on stack
0x0058474F    fld st(0),dword ptr ss:[esp+18]     ; reloads to FPU stack
0x00584753    add esp,1C
0x00584756    ret


;
; get/set_speed()
;
; some of these comments are just float values, may not be consistent
;
; can get called twice+ on pipboy leave
; and from different spots
;    reload dash effect???? unpause did it again until anim done
;
; healing, changing armor, drawing new weapon, getting crippled - all trigger this
;


0x005845B0    fld st(0),dword ptr ss:[esp+8]      ; 20 - 20 becomes 140 with vault armor on (armor speed adjust)
0x005845B4    sub esp,8
0x005845B7    fld st(0),dword ptr ds:[F610B0]     ; 150
0x005845BD    fcom st(0),st(1)                    ; FPU compares are weird, all you need to know
0x005845BF    fnstsw ax
0x005845C1    fstp st(1),st(0)
0x005845C3    test ah,5
0x005845C6    jp fallout3.5845CE
0x005845C8    fstp dword ptr ss:[esp+10],st(0)
0x005845CC    jmp fallout3.5845D0
0x005845CE    fstp st(0),st(0)
0x005845D0    push esi
0x005845D1    mov esi,dword ptr ss:[esp+10]
0x005845D5    push 0
0x005845D7    push 1E
0x005845D9    push esi
0x005845DA    call fallout3.582B30
                                                  ; limb health(1E) (ret 1 if good, 0 if bad)
                                                  ; see ignorecrippledlimb
                                                  ; long func
                                                  ; hardcode city   F603CC, F603C0
                                                  ; F603E4, F603D8, F603FC, F603F0
                                                  ; F60444, DCD110, F60438, F60450,
                                                  ; F60468, F6048C, F60480, F604A4,
                                                  ; F60498, F60414, F60408
                                                  ; gets 1 on fpu
0x005845DF    fld1
0x005845E1    push 0
0x005845E3    fsubrp st(1),st(0)
0x005845E5    push 1D
0x005845E7    push esi
0x005845E8    fstp qword ptr ss:[esp+1C],st(0)
0x005845EC    call fallout3.582B30                ; limb health for 1D now
0x005845F1    fld1
0x005845F3    add esp,18
0x005845F6    fsubrp st(1),st(0)
0x005845F8    fadd st(0),qword ptr ss:[esp+4]
0x005845FC    fstp dword ptr ss:[esp+4],st(0)
0x00584600    fld1
0x00584602    fst dword ptr ss:[esp+10],st(0)     ; store crippled limb mult
0x00584606    fld st(0),dword ptr ss:[esp+4]
0x0058460A    fucom st(0),st(1)
0x0058460C    fnstsw ax
0x0058460E    fstp st(1),st(0)
0x00584610    test ah,44
0x00584613    jp fallout3.58461F
0x00584615    fstp st(0),st(0)
0x00584617    fld st(0),dword ptr ds:[F62298]     ; 0.85 (fMoveOneCrippledLegSpeedMult)
0x0058461D    jmp fallout3.584634
0x0058461F    fld st(0),dword ptr ds:[DBCBD0]     ; 2.0  (hardcoded limb count check ?)
0x00584625    fucompp
0x00584627    fnstsw ax
0x00584629    test ah,44
0x0058462C    jp fallout3.584638
0x0058462E    fld st(0),dword ptr ds:[F622A4]     ; 0.75 (fMoveTwoCrippledLegsSpeedMult)
0x00584634    fstp dword ptr ss:[esp+10],st(0)    ; store crippled mult
0x00584638    cmp byte ptr ss:[esp+24],0          ; (check?)
0x0058463D    jne fallout3.584654
0x0058463F    mov eax,dword ptr ds:[esi]
0x00584641    mov edx,dword ptr ds:[eax+8]
0x00584644    push 48
0x00584646    mov ecx,esi
0x00584648    call edx                            ; 2 0s near of of fpu now (limb code - see ignorecrippledlimb)
                                                  ; calls to c00690 ? display code? 'you got hurt' ?
0x0058464A    test eax,eax
0x0058464C    je fallout3.584654
0x0058464E    fld1
0x00584650    fstp dword ptr ss:[esp+10],st(0)
0x00584654    mov eax,dword ptr ds:[esi]
0x00584656    mov edx,dword ptr ds:[eax+C]
0x00584659    push 15
0x0058465B    mov ecx,esi
0x0058465D    call edx                            ; 100 fpu
0x0058465F    fmul st(0),qword ptr ds:[DCF568]    ; 64bit, .01 = 1
0x00584665    cmp byte ptr ss:[esp+20],0
0x0058466A    pop esi
0x0058466B    fstp dword ptr ss:[esp],st(0)
0x0058466E    fld st(0),dword ptr ds:[F610A4]     ; 0
0x00584674    fld st(0),st(0)
0x00584676    fadd st(0),dword ptr ss:[esp+10]    ; 20 (armor speed adjust, 20 is nude)
0x0058467A    fld st(0),dword ptr ds:[F610B0]     ; 150
0x00584680    fsubrp st(2),st(0)                  ; 0, swaps to 20 and 150 on FPU stack
0x00584682    fdivrp st(1),st(0)                  ; .1333  (140 and 150 w/ armor = .9333)
0x00584684    fstp dword ptr ss:[esp+20],st(0)
0x00584688    fld st(0),dword ptr ds:[F610D4]     ; 77 (77 bases are common)
0x0058468E    fmul st(0),dword ptr ss:[esp]       ; 77 still
0x00584691    fmul st(0),dword ptr ss:[esp+C]     ;    still
0x00584695    fstp dword ptr ss:[esp+10],st(0)
0x00584699    je fallout3.5846C0
0x0058469B    cmp byte ptr ss:[esp+18],0          ; weapon check
0x005846A0    je fallout3.5846C0                  ; skip if nothing is out
0x005846A2    fld st(0),dword ptr ds:[F6108C]     ; 0.3000
0x005846A8    fmul st(0),dword ptr ss:[esp+20]    ; 0.0400
0x005846AC    fstp dword ptr ss:[esp+20],st(0)
0x005846B0    fld st(0),dword ptr ds:[F610BC]     ; 1.1000
0x005846B6    fmul st(0),dword ptr ss:[esp+10]    ; 84.7 (from 77)
0x005846BA    fstp dword ptr ss:[esp+10],st(0)
0x005846BE    jmp fallout3.5846CE
0x005846C0    fld st(0),dword ptr ds:[F61080]     ; 0.4000 (.1333 from above, missle out and armor?)
0x005846C6    fmul st(0),dword ptr ss:[esp+20]
0x005846CA    fstp dword ptr ss:[esp+20],st(0)    ; ^weapon code end
0x005846CE    cmp byte ptr ss:[esp+14],0
0x005846D3    fld st(0),dword ptr ss:[esp+20]     ; 0.4000
0x005846D7    fld1
0x005846D9    fsubrp st(1),st(0)                  ; 0.95999 - this is armor adjust - x/150 *
0x005846DB    fmul st(0),dword ptr ss:[esp+10]    ; 81.31 (from 77 >> 84)
                                                  ; would get 48.253 with .6266 140/150 vault armor
0x005846DF    fstp dword ptr ss:[esp+10],st(0)
0x005846E3    je fallout3.5846F3
0x005846E5    fld st(0),dword ptr ds:[F610C8]
0x005846EB    fmul st(0),dword ptr ss:[esp+10]
0x005846EF    fstp dword ptr ss:[esp+10],st(0)
0x005846F3    fldz
0x005846F5    fld st(0),dword ptr ss:[esp+10]     ; 81.31
0x005846F9    fcom st(0),st(1)
0x005846FB    fnstsw ax
0x005846FD    test ah,5
0x00584700    jp fallout3.584708
0x00584702    fstp st(0),st(0)
0x00584704    add esp,8
0x00584707    ret
0x00584708    fstp st(1),st(0)                    ; 2x 81.31 on FPU stack
0x0058470A    add esp,8
0x0058470D    ret

;
;
;  after all is said and done, the result gets stored here
;

0x006F5A90    push ecx
0x006F5A91    push esi
0x006F5A92    mov esi,ecx
0x006F5A94    mov eax,dword ptr ds:[esi-A0]
0x006F5A9A    mov edx,dword ptr ds:[eax+44C]
0x006F5AA0    lea ecx,dword ptr ds:[esi-A0]
0x006F5AA6    call edx
0x006F5AA8    fstp dword ptr ss:[esp+4],st(0)
0x006F5AAC    mov eax,dword ptr ds:[esi-40]
0x006F5AAF    fld st(0),dword ptr ss:[esp+4]
0x006F5AB3    test eax,eax
0x006F5AB5    pop esi
0x006F5AB6    je fallout3.6F5ACE
0x006F5AB8    cmp dword ptr ds:[eax+2C],0
0x006F5ABC    je fallout3.6F5ACE
0x006F5ABE    mov ecx,dword ptr ds:[eax+2C]
0x006F5AC1    fst dword ptr ds:[ecx+38],st(0)      ;  player speed stored at 2500907C
0x006F5AC4    mov eax,dword ptr ds:[eax+2C]
0x006F5AC7    or dword ptr ds:[eax+40],2000
0x006F5ACE    pop ecx
0x006F5ACF    ret
0x006F5AD0    mov eax,dword ptr ds:[ecx+60]
0x006F5AD3    test eax,eax
0x006F5AD5    je fallout3.6F5AEC
0x006F5AD7    cmp dword ptr ds:[eax+2C],0
0x006F5ADB    je fallout3.6F5AEC
0x006F5ADD    add ecx,A0
0x006F5AE3    push ecx
0x006F5AE4    mov ecx,eax
0x006F5AE6    call fallout3.6F4760
0x006F5AEB    ret
0x006F5AEC    mov eax,dword ptr ds:[ecx]
0x006F5AEE    mov edx,dword ptr ds:[eax+448]
0x006F5AF4    jmp edx
