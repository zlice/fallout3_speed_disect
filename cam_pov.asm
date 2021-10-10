;
; trying to catch key processes directly is out of the question
; but pressing your switch camera key breaks here (probably scroll wheel too?)
; this does trigger off some calls
; switching 1st>3rd and 3rd>1st have some transitions, one more than the other
;

0x00775430    mov al,byte ptr ss:[esp+4]
0x00775434    push ebx
0x00775435    push esi
0x00775436    mov esi,ecx
0x00775438    cmp byte ptr ds:[esi+5AA],al
0x0077543E    sete bl
0x00775441    test al,al
0x00775443    sete al
0x00775446    test al,al
0x00775448    mov byte ptr ds:[esi+5AA],al
0x0077544E    je fallout3.77546C
0x00775450    mov eax,dword ptr ds:[esi]
0x00775452    mov edx,dword ptr ds:[eax+22C]
0x00775458    push 0
0x0077545A    call edx
0x0077545C    test al,al
0x0077545E    je fallout3.77546C
0x00775460    fld st(0),dword ptr ds:[F5E9C8]
0x00775466    fstp dword ptr ds:[107BDBC],st(0)
0x0077546C    cmp byte ptr ds:[107BA5B],0
0x00775473    jne fallout3.7754E2
0x00775475    mov eax,dword ptr ds:[esi+5F0]
0x0077547B    test eax,eax
0x0077547D    je fallout3.7754E2
0x0077547F    cmp byte ptr ds:[esi+5AA],0
0x00775486    je fallout3.7754C8
0x00775488    test bl,bl
0x0077548A    je fallout3.7754C8
0x0077548C    mov eax,dword ptr ds:[107BA78]
0x00775491    mov ecx,dword ptr ds:[eax+8C]
0x00775497    mov dword ptr ds:[107BAA8],ecx
0x0077549D    mov edx,dword ptr ds:[eax+90]
0x007754A3    mov dword ptr ds:[107BAAC],edx
0x007754A9    mov eax,dword ptr ds:[eax+94]
0x007754AF    mov dword ptr ds:[107BAB0],eax
0x007754B4    cmp byte ptr ds:[esi+5AA],0
0x007754BB    sete cl
0x007754BE    push ecx
0x007754BF    mov ecx,esi
0x007754C1    call fallout3.7700B0
0x007754C6    jmp fallout3.7754E2
0x007754C8    test eax,eax
0x007754CA    je fallout3.7754E2
0x007754CC    test byte ptr ds:[eax+30],1
0x007754D0    je fallout3.7754E2
0x007754D2    cmp byte ptr ds:[esi+5AA],0           ; compares camera pov
0x007754D9    jne fallout3.7754E2
0x007754DB    mov byte ptr ds:[esi+5A8],1
0x007754E2    test bl,bl
0x007754E4    je fallout3.77550D
0x007754E6    cmp byte ptr ds:[108D018],0
0x007754ED    je fallout3.77550D
0x007754EF    cmp byte ptr ds:[108D019],0
0x007754F6    je fallout3.77550D
0x007754F8    mov dl,byte ptr ds:[esi+5AA]          ; puts camera pov in dl for call below
0x007754FE    push 1
0x00775500    mov ecx,esi
0x00775502    mov byte ptr ds:[esi+5A8],dl
0x00775508    call fallout3.7700B0
0x0077550D    pop esi
0x0077550E    mov al,bl
0x00775510    pop ebx
0x00775511    ret 4
