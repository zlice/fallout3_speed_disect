;
; calls limb health for legs
; aim your missle launcher at the ground and fire to get here
; happens on cripple, i imagine there's something neat hiding in here
;

0x007181B0    push ecx
0x007181B1    push esi
0x007181B2    mov esi,dword ptr ss:[esp+C]
0x007181B6    test esi,esi
0x007181B8    je fallout3.71829E
0x007181BE    mov eax,dword ptr ss:[esp+1C]
0x007181C2    fld st(0),dword ptr ss:[esp+18]
0x007181C6    push edi
0x007181C7    mov edi,dword ptr ss:[esp+14]
0x007181CB    push eax
0x007181CC    sub esp,8
0x007181CF    fstp dword ptr ss:[esp+4],st(0)
0x007181D3    fld st(0),dword ptr ss:[esp+24]
0x007181D7    fstp dword ptr ss:[esp],st(0)
0x007181DA    push edi
0x007181DB    push esi
0x007181DC    call fallout3.717DC0
0x007181E1    add esp,14
0x007181E4    cmp edi,1D
0x007181E7    je fallout3.7181F2
0x007181E9    cmp edi,1E
0x007181EC    jne fallout3.71829D
0x007181F2    mov edx,dword ptr ds:[esi]
0x007181F4    mov eax,dword ptr ds:[edx+8]
0x007181F7    push 48
0x007181F9    mov ecx,esi
0x007181FB    call eax
0x007181FD    test eax,eax
0x007181FF    jne fallout3.71829D
0x00718205    fldz
0x00718207    add esi,FFFFFF64
0x0071820D    fcom st(0),dword ptr ss:[esp+18]
0x00718211    fnstsw ax
0x00718213    test ah,1
0x00718216    je fallout3.71821C
0x00718218    fstp st(0),st(0)
0x0071821A    fld1
0x0071821C    test esi,esi
0x0071821E    fstp dword ptr ss:[esp+10],st(0)
0x00718222    je fallout3.71822C
0x00718224    lea eax,dword ptr ds:[esi+9C]
0x0071822A    jmp fallout3.71822E
0x0071822C    xor eax,eax
0x0071822E    xor ecx,ecx
0x00718230    cmp edi,1D
0x00718233    sete cl
0x00718236    push 0
0x00718238    add ecx,1D
0x0071823B    push ecx
0x0071823C    push eax
0x0071823D    call fallout3.582B30
0x00718242    fstp dword ptr ss:[esp+14],st(0)
0x00718246    mov eax,dword ptr ds:[esi+60]
0x00718249    add esp,C
0x0071824C    test eax,eax
0x0071824E    je fallout3.71826F
0x00718250    mov eax,dword ptr ds:[eax+2C]
0x00718253    test eax,eax
0x00718255    je fallout3.71825E
0x00718257    and dword ptr ds:[eax+40],FFFFDFFF
0x0071825E    mov eax,dword ptr ds:[esi+60]
0x00718261    mov eax,dword ptr ds:[eax+2C]
0x00718264    test eax,eax
0x00718266    je fallout3.71826F
0x00718268    and dword ptr ds:[eax+40],FFFFEFFF
0x0071826F    fld st(0),dword ptr ss:[esp+8]
0x00718273    push ecx
0x00718274    fstp dword ptr ss:[esp],st(0)
0x00718277    push 0
0x00718279    lea edx,dword ptr ds:[esi+9C]
0x0071827F    push edi
0x00718280    push edx
0x00718281    call fallout3.582B30
0x00718286    fstp dword ptr ss:[esp+8],st(0)
0x0071828A    fld st(0),dword ptr ss:[esp+20]
0x0071828E    add esp,4
0x00718291    fstp dword ptr ss:[esp],st(0)
0x00718294    push esi
0x00718295    call fallout3.710D70
0x0071829A    add esp,10
0x0071829D    pop edi
0x0071829E    pop esi
0x0071829F    pop ecx
0x007182A0    ret

;
; IgnoreCrippledLimbs is a float for some reason
; accessed here, never really dug into it much
;
; this was one of the values i first tried to trace with access to the string, such a pain in the ass
;
; If you set ignorecrippledlimbs - your anim changes on the spot
; however
; if you get speed cripple and set ignorecrippled limbs - nothings happens
; probably because you don't have crippled limbs
;

0x0076AFC0    mov eax,dword ptr ss:[esp+4]
0x0076AFC4    push eax
0x0076AFC5    call fallout3.76A910
0x0076AFCA    mov edx,dword ptr ss:[esp+8]
0x0076AFCE    test eax,eax
0x0076AFD0    setne cl
0x0076AFD3    test eax,eax
0x0076AFD5    mov byte ptr ds:[edx],cl
0x0076AFD7    je fallout3.76AFE7
0x0076AFD9    fld st(0),dword ptr ds:[eax+4]          ; IgnoreCrippledLimbs
0x0076AFDC    fstp dword ptr ss:[esp+4],st(0)
0x0076AFE0    fld st(0),dword ptr ss:[esp+4]
0x0076AFE4    ret 8
0x0076AFE7    fldz
0x0076AFE9    fstp dword ptr ss:[esp+4],st(0)
0x0076AFED    fld st(0),dword ptr ss:[esp+4]
0x0076AFF1    ret 8


;
; big bad limb hell-th, where you get limb health and do a bunch i didn't bother to look in to
;
; the only other caller i saw, besides the bigger function above, was from the get/set_speed()
; which pushes some stack arguments like 1E or 1D for each leg
;
; returns 1 if good, 0 if bad, on the FPU st0 register
;


0x00582B30    push ecx
0x00582B31    fld1
0x00582B33    mov eax,dword ptr ss:[esp+C]
0x00582B37    cmp eax,19
0x00582B3A    fstp dword ptr ss:[esp],st(0)
0x00582B3D    jl fallout3.582B8A
0x00582B3F    cmp eax,1F
0x00582B42    jg fallout3.582B8A
0x00582B44    mov ecx,dword ptr ss:[esp+8]
0x00582B48    mov edx,dword ptr ds:[ecx]
0x00582B4A    push eax
0x00582B4B    mov eax,dword ptr ds:[edx+C]
0x00582B4E    call eax
0x00582B50    fstp dword ptr ss:[esp+C],st(0)
0x00582B54    fld st(0),dword ptr ss:[esp+C]
0x00582B58    fcom st(0),qword ptr ds:[DBA730]
0x00582B5E    fnstsw ax
0x00582B60    test ah,41
0x00582B63    jne fallout3.582B6D
0x00582B65    fstp st(0),st(0)
0x00582B67    fld st(0),dword ptr ds:[DC0BC8]
0x00582B6D    cmp byte ptr ss:[esp+10],0
0x00582B72    fstp dword ptr ss:[esp],st(0)
0x00582B75    jne fallout3.582B8A
0x00582B77    fldz
0x00582B79    fcom st(0),dword ptr ss:[esp]
0x00582B7C    fnstsw ax
0x00582B7E    test ah,5
0x00582B81    jp fallout3.582B87
0x00582B83    fstp st(0),st(0)
0x00582B85    fld1
0x00582B87    fstp dword ptr ss:[esp],st(0)
0x00582B8A    fld st(0),dword ptr ss:[esp]
0x00582B8D    pop ecx
0x00582B8E    ret
0x00582B8F    int3
0x00582B90    push ecx
0x00582B91    mov eax,dword ptr ss:[esp+C]
0x00582B95    cmp eax,9
0x00582B98    ja fallout3.582C37
0x00582B9E    movzx eax,byte ptr ds:[eax+582C84]
0x00582BA5    jmp dword ptr ds:[eax*4+582C7C]
0x00582BAC    push esi
0x00582BAD    mov esi,dword ptr ss:[esp+C]
0x00582BB1    mov edx,dword ptr ds:[esi]
0x00582BB3    mov eax,dword ptr ds:[edx+C]
0x00582BB6    push 1B
0x00582BB8    mov ecx,esi
0x00582BBA    call eax
0x00582BBC    fstp dword ptr ss:[esp+10],st(0)
0x00582BC0    fld st(0),dword ptr ss:[esp+10]
0x00582BC4    fcom st(0),qword ptr ds:[DBA730]
0x00582BCA    fnstsw ax
0x00582BCC    fldz
0x00582BCE    test ah,41
0x00582BD1    je fallout3.582BE0
0x00582BD3    fcom st(0),st(1)
0x00582BD5    fnstsw ax
0x00582BD7    fstp st(1),st(0)
0x00582BD9    test ah,5
0x00582BDC    jp fallout3.582BE6
0x00582BDE    jmp fallout3.582BE2
0x00582BE0    fstp st(1),st(0)
0x00582BE2    fstp st(0),st(0)
0x00582BE4    fld1
0x00582BE6    mov edx,dword ptr ds:[esi]
0x00582BE8    fstp dword ptr ss:[esp+4],st(0)
0x00582BEC    mov eax,dword ptr ds:[edx+C]
0x00582BEF    push 1C
0x00582BF1    mov ecx,esi
0x00582BF3    call eax
0x00582BF5    fstp dword ptr ss:[esp+10],st(0)
0x00582BF9    fld st(0),dword ptr ss:[esp+10]
0x00582BFD    pop esi
0x00582BFE    fcom st(0),qword ptr ds:[DBA730]
0x00582C04    fnstsw ax
0x00582C06    test ah,41
0x00582C09    je fallout3.582C18
0x00582C0B    fldz
0x00582C0D    fcom st(0),st(1)
0x00582C0F    fnstsw ax
0x00582C11    fstp st(1),st(0)
0x00582C13    test ah,5
0x00582C16    jp fallout3.582C1C
0x00582C18    fstp st(0),st(0)
0x00582C1A    fld1
0x00582C1C    fstp dword ptr ss:[esp+C],st(0)
0x00582C20    fld st(0),dword ptr ss:[esp+C]
0x00582C24    fadd st(0),dword ptr ss:[esp]
0x00582C27    fmul st(0),qword ptr ds:[DB7DE8]
0x00582C2D    fstp dword ptr ss:[esp+C],st(0)
0x00582C31    fld st(0),dword ptr ss:[esp+C]
0x00582C35    pop ecx
0x00582C36    ret
0x00582C37    mov ecx,dword ptr ss:[esp+8]
0x00582C3B    mov edx,dword ptr ds:[ecx]
0x00582C3D    mov eax,dword ptr ds:[edx+C]
0x00582C40    push 1C
0x00582C42    call eax
0x00582C44    fstp dword ptr ss:[esp+C],st(0)
0x00582C48    fld st(0),dword ptr ss:[esp+C]
0x00582C4C    fcom st(0),qword ptr ds:[DBA730]
0x00582C52    fnstsw ax
0x00582C54    test ah,41
0x00582C57    je fallout3.582C66
0x00582C59    fldz
0x00582C5B    fcom st(0),st(1)
0x00582C5D    fnstsw ax
0x00582C5F    fstp st(1),st(0)
0x00582C61    test ah,5
0x00582C64    jp fallout3.582C6A
0x00582C66    fstp st(0),st(0)
0x00582C68    fld1
0x00582C6A    fstp dword ptr ss:[esp+C],st(0)
0x00582C6E    fld st(0),dword ptr ss:[esp+C]
0x00582C72    fstp dword ptr ss:[esp+C],st(0)
0x00582C76    fld st(0),dword ptr ss:[esp+C]
0x00582C7A    pop ecx
0x00582C7B    ret
0x00582C7C    lodsb
0x00582C7D    sub ebx,dword ptr ds:[eax]
0x00582C80    aaa
0x00582C81    sub al,58
0x00582C83    add byte ptr ds:[eax],al
0x00582C85    add dword ptr ds:[eax],eax
0x00582C87    add dword ptr ds:[ecx],eax
0x00582C89    add byte ptr ds:[eax],al
0x00582C8B    add byte ptr ds:[eax],al
0x00582C8D    add ah,cl
0x00582C8F    int3
0x00582C90    sub esp,10
0x00582C93    push ebx
0x00582C94    push esi
0x00582C95    push edi
0x00582C96    mov edi,dword ptr ss:[esp+24]
0x00582C9A    test edi,edi
0x00582C9C    je fallout3.582CAA
0x00582C9E    mov ecx,edi
0x00582CA0    call fallout3.73B220
0x00582CA5    cmp eax,FFFFFFFF
0x00582CA8    jne fallout3.582CAF
0x00582CAA    mov eax,2D
0x00582CAF    fld st(0),dword ptr ds:[F603CC]
0x00582CB5    mov esi,dword ptr ss:[esp+20]
0x00582CB9    fmul st(0),dword ptr ss:[esp+28]
0x00582CBD    push eax
0x00582CBE    mov ecx,esi
0x00582CC0    fadd st(0),dword ptr ds:[F603C0]
0x00582CC6    fstp dword ptr ss:[esp+14],st(0)
0x00582CCA    call fallout3.5A29A0
0x00582CCF    test edi,edi
0x00582CD1    mov dword ptr ss:[esp+24],eax
0x00582CD5    fild st(0),dword ptr ss:[esp+24]
0x00582CD9    fmul st(0),dword ptr ds:[F603E4]
0x00582CDF    fadd st(0),dword ptr ds:[F603D8]
0x00582CE5    fstp dword ptr ss:[esp+C],st(0)
0x00582CE9    je fallout3.582CF4
0x00582CEB    movsx eax,byte ptr ds:[edi+F4]
0x00582CF2    jmp fallout3.582CF6
0x00582CF4    xor eax,eax
0x00582CF6    push eax
0x00582CF7    push esi
0x00582CF8    call fallout3.582B90
0x00582CFD    fstp dword ptr ss:[esp+28],st(0)
0x00582D01    fld st(0),dword ptr ds:[F603FC]
0x00582D07    mov eax,dword ptr ds:[esi]
0x00582D09    fmul st(0),dword ptr ss:[esp+28]
0x00582D0D    mov edx,dword ptr ds:[eax+C]
0x00582D10    add esp,8
0x00582D13    push 19
0x00582D15    fadd st(0),dword ptr ds:[F603F0]
0x00582D1B    mov ecx,esi
0x00582D1D    fstp dword ptr ss:[esp+2C],st(0)
0x00582D21    call edx
0x00582D23    fstp dword ptr ss:[esp+24],st(0)
0x00582D27    fld st(0),dword ptr ss:[esp+24]
0x00582D2B    fcom st(0),qword ptr ds:[DBA730]
0x00582D31    fnstsw ax
0x00582D33    fldz
0x00582D35    test ah,41
0x00582D38    je fallout3.582D47
0x00582D3A    fcom st(0),st(1)
0x00582D3C    fnstsw ax
0x00582D3E    fstp st(1),st(0)
0x00582D40    test ah,5
0x00582D43    jp fallout3.582D4D
0x00582D45    jmp fallout3.582D49
0x00582D47    fstp st(1),st(0)
0x00582D49    fstp st(0),st(0)
0x00582D4B    fld1
0x00582D4D    fstp dword ptr ss:[esp+24],st(0)
0x00582D51    movzx eax,byte ptr ss:[esp+30]
0x00582D56    fld st(0),dword ptr ds:[F6042C]
0x00582D5C    movzx ecx,byte ptr ss:[esp+34]
0x00582D61    fmul st(0),dword ptr ss:[esp+24]
0x00582D65    movzx edx,byte ptr ss:[esp+38]
0x00582D6A    fadd st(0),dword ptr ds:[F60420]
0x00582D70    mov dword ptr ss:[esp+30],eax
0x00582D74    fstp dword ptr ss:[esp+24],st(0)
0x00582D78    movzx eax,byte ptr ss:[esp+3C]
0x00582D7D    fld st(0),dword ptr ss:[esp+2C]
0x00582D81    fabs
0x00582D83    fstp dword ptr ss:[esp+2C],st(0)
0x00582D87    push 48
0x00582D89    fld st(0),dword ptr ss:[esp+30]
0x00582D8D    fmul st(0),dword ptr ds:[F60444]
0x00582D93    fmul st(0),qword ptr ds:[DCD110]
0x00582D99    fadd st(0),dword ptr ds:[F60438]
0x00582D9F    fstp dword ptr ss:[esp+30],st(0)
0x00582DA3    fld st(0),dword ptr ds:[F6045C]
0x00582DA9    fild st(0),dword ptr ss:[esp+34]
0x00582DAD    mov dword ptr ss:[esp+34],ecx
0x00582DB1    mov ecx,esi
0x00582DB3    fmulp st(1),st(0)
0x00582DB5    fadd st(0),dword ptr ds:[F60450]
0x00582DBB    fstp dword ptr ss:[esp+18],st(0)
0x00582DBF    fld st(0),dword ptr ds:[F60474]
0x00582DC5    fild st(0),dword ptr ss:[esp+34]
0x00582DC9    mov dword ptr ss:[esp+34],edx
0x00582DCD    mov edx,dword ptr ds:[esi]
0x00582DCF    fmulp st(1),st(0)
0x00582DD1    fadd st(0),dword ptr ds:[F60468]
0x00582DD7    fstp dword ptr ss:[esp+38],st(0)
0x00582DDB    fld st(0),dword ptr ds:[F6048C]
0x00582DE1    fild st(0),dword ptr ss:[esp+34]
0x00582DE5    mov dword ptr ss:[esp+34],eax
0x00582DE9    mov eax,dword ptr ds:[edx+8]
0x00582DEC    fmulp st(1),st(0)
0x00582DEE    fadd st(0),dword ptr ds:[F60480]
0x00582DF4    fstp dword ptr ss:[esp+1C],st(0)
0x00582DF8    fld st(0),dword ptr ds:[F604A4]
0x00582DFE    fild st(0),dword ptr ss:[esp+34]
0x00582E02    fmulp st(1),st(0)
0x00582E04    fadd st(0),dword ptr ds:[F60498]
0x00582E0A    fstp dword ptr ss:[esp+3C],st(0)
0x00582E0E    call eax
0x00582E10    test eax,eax
0x00582E12    je fallout3.582E1E
0x00582E14    fldz
0x00582E16    fst dword ptr ss:[esp+28],st(0)
0x00582E1A    fstp dword ptr ss:[esp+24],st(0)
0x00582E1E    mov edx,dword ptr ds:[esi-9C]
0x00582E24    mov eax,dword ptr ds:[edx+35C]
0x00582E2A    lea ecx,dword ptr ds:[esi-9C]
0x00582E30    mov bl,1
0x00582E32    call eax
0x00582E34    fldz
0x00582E36    test al,al
0x00582E38    je fallout3.582E40
0x00582E3A    fst dword ptr ss:[esp+24],st(0)
0x00582E3E    xor bl,bl
0x00582E40    cmp byte ptr ss:[esp+3C],0
0x00582E45    fld st(0),dword ptr ss:[esp+C]
0x00582E49    fadd st(0),dword ptr ss:[esp+10]
0x00582E4D    fadd st(0),dword ptr ss:[esp+24]
0x00582E51    fadd st(0),dword ptr ss:[esp+2C]
0x00582E55    fstp dword ptr ss:[esp+30],st(0)
0x00582E59    fld st(0),dword ptr ss:[esp+30]
0x00582E5D    fmul st(0),dword ptr ss:[esp+14]
0x00582E61    fstp dword ptr ss:[esp+30],st(0)
0x00582E65    fld st(0),dword ptr ss:[esp+30]
0x00582E69    fmul st(0),dword ptr ss:[esp+34]
0x00582E6D    fstp dword ptr ss:[esp+30],st(0)
0x00582E71    fld st(0),dword ptr ss:[esp+30]
0x00582E75    je fallout3.582E7D
0x00582E77    fmul st(0),dword ptr ss:[esp+38]
0x00582E7B    jmp fallout3.582E81
0x00582E7D    fmul st(0),dword ptr ss:[esp+18]
0x00582E81    fstp dword ptr ss:[esp+30],st(0)
0x00582E85    fld st(0),dword ptr ss:[esp+30]
0x00582E89    fcom st(0),st(1)
0x00582E8B    fnstsw ax
0x00582E8D    test ah,5
0x00582E90    jp fallout3.582E9C
0x00582E92    fstp st(0),st(0)
0x00582E94    fstp dword ptr ss:[esp+30],st(0)
0x00582E98    fld1
0x00582E9A    jmp fallout3.582EAF
0x00582E9C    fstp st(1),st(0)
0x00582E9E    fld1
0x00582EA0    fcom st(0),st(1)
0x00582EA2    fnstsw ax
0x00582EA4    fstp st(1),st(0)
0x00582EA6    test ah,5
0x00582EA9    jp fallout3.582EAF
0x00582EAB    fst dword ptr ss:[esp+30],st(0)
0x00582EAF    fld st(0),dword ptr ss:[esp+30]
0x00582EB3    pop edi
0x00582EB4    fadd st(0),dword ptr ss:[esp+24]
0x00582EB8    pop esi
0x00582EB9    test bl,bl
0x00582EBB    pop ebx
0x00582EBC    fstp dword ptr ss:[esp+24],st(0)
0x00582EC0    je fallout3.582EE9
0x00582EC2    fcomp st(0),dword ptr ss:[esp+14]
0x00582EC6    fnstsw ax
0x00582EC8    test ah,41
0x00582ECB    jne fallout3.582EEB
0x00582ECD    fld st(0),dword ptr ds:[F60414]
0x00582ED3    fmul st(0),dword ptr ss:[esp+24]
0x00582ED7    fadd st(0),dword ptr ds:[F60408]
0x00582EDD    fstp dword ptr ss:[esp+24],st(0)
0x00582EE1    fld st(0),dword ptr ss:[esp+24]
0x00582EE5    add esp,10
0x00582EE8    ret
0x00582EE9    fstp st(0),st(0)
0x00582EEB    fld st(0),dword ptr ss:[esp+24]
0x00582EEF    add esp,10
0x00582EF2    ret





;
; LeftMobilityCondition - use player.modav to get here
;


0x0076E570    fild st(0),dword ptr ss:[esp+8]
0x0076E574    push esi
0x0076E575    mov esi,dword ptr ss:[esp+8]
0x0076E579    push edi
0x0076E57A    push ecx
0x0076E57B    fstp dword ptr ss:[esp],st(0)
0x0076E57E    push esi
0x0076E57F    mov edi,ecx
0x0076E581    call fallout3.76CED0
0x0076E586    test al,al
0x0076E588    je fallout3.76E68C
0x0076E58E    mov eax,dword ptr ds:[esi*4+1073EB8]
0x0076E595    mov ecx,dword ptr ds:[eax+44]
0x0076E598    shr ecx,8
0x0076E59B    test cl,1
0x0076E59E    jne fallout3.76E68C
0x0076E5A4    mov edx,dword ptr ss:[esp+10]
0x0076E5A8    push ebx
0x0076E5A9    mov ebx,dword ptr ss:[esp+18]
0x0076E5AD    push ebp
0x0076E5AE    push ebx
0x0076E5AF    push edx
0x0076E5B0    push esi
0x0076E5B1    mov ecx,edi
0x0076E5B3    call fallout3.6FAAD0
0x0076E5B8    mov ebp,eax
0x0076E5BA    push esi
0x0076E5BB    mov dword ptr ss:[esp+1C],ebp
0x0076E5BF    call fallout3.5A25B0
0x0076E5C4    add esp,4
0x0076E5C7    test al,al
0x0076E5C9    je fallout3.76E5DF
0x0076E5CB    mov eax,dword ptr ds:[edi+9C]
0x0076E5D1    mov edx,dword ptr ds:[eax+C]
0x0076E5D4    lea ecx,dword ptr ds:[edi+9C]
0x0076E5DA    push esi
0x0076E5DB    call edx
0x0076E5DD    jmp fallout3.76E5E1
0x0076E5DF    fldz
0x0076E5E1    cmp esi,FFFFFFFF
0x0076E5E4    fstp dword ptr ss:[esp+14],st(0)
0x0076E5E8    fild st(0),dword ptr ss:[esp+18]
0x0076E5EC    fstp dword ptr ss:[esp+18],st(0)
0x0076E5F0    fld st(0),dword ptr ss:[esp+18]
0x0076E5F4    fstp dword ptr ss:[esp+1C],st(0)
0x0076E5F8    je fallout3.76E620
0x0076E5FA    fld st(0),dword ptr ss:[esp+1C]
0x0076E5FE    push 2
0x0076E600    sub esp,8
0x0076E603    fstp dword ptr ss:[esp+4],st(0)
0x0076E607    fld st(0),dword ptr ds:[edi+esi*4+324]
0x0076E60E    fstp dword ptr ss:[esp],st(0)
0x0076E611    call fallout3.76A7A0
0x0076E616    fstp dword ptr ds:[edi+esi*4+324],st(0)         ; LeftMobilityCondition stored
0x0076E61D    add esp,C
0x0076E620    push esi
0x0076E621    call fallout3.61B6D0
0x0076E626    add esp,4
0x0076E629    cmp esi,10
0x0076E62C    jne fallout3.76E647
0x0076E62E    test ebp,ebp
0x0076E630    jge fallout3.76E647
0x0076E632    mov eax,dword ptr ds:[edi]
0x0076E634    fld st(0),dword ptr ss:[esp+18]
0x0076E638    mov edx,dword ptr ds:[eax+4A8]
0x0076E63E    push ecx
0x0076E63F    fstp dword ptr ss:[esp],st(0)
0x0076E642    push ebx
0x0076E643    mov ecx,edi
0x0076E645    call edx
0x0076E647    push 0
0x0076E649    push esi
0x0076E64A    mov ecx,edi
0x0076E64C    call fallout3.634F80
0x0076E651    test ebx,ebx
0x0076E653    je fallout3.76E65D
0x0076E655    lea ecx,dword ptr ds:[ebx+9C]
0x0076E65B    jmp fallout3.76E65F
0x0076E65D    xor ecx,ecx
0x0076E65F    test edi,edi
0x0076E661    pop ebp
0x0076E662    pop ebx
0x0076E663    je fallout3.76E66D
0x0076E665    lea eax,dword ptr ds:[edi+9C]
0x0076E66B    jmp fallout3.76E66F
0x0076E66D    xor eax,eax
0x0076E66F    fld st(0),dword ptr ss:[esp+10]
0x0076E673    push ecx
0x0076E674    sub esp,8
0x0076E677    fstp dword ptr ss:[esp+4],st(0)
0x0076E67B    fld st(0),dword ptr ss:[esp+18]
0x0076E67F    fstp dword ptr ss:[esp],st(0)
0x0076E682    push esi
0x0076E683    push eax
0x0076E684    call fallout3.5A25E0
0x0076E689    add esp,14
0x0076E68C    pop edi
0x0076E68D    pop esi
0x0076E68E    ret C





