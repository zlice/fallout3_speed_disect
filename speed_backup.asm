;
; speed was stored in two locations, this one was dynamic and seemed to be what
; the rest of the game would actually access when getting player speed
; must be in the character data somewhere and the other was more for the save file and game status
;


0x007E8DD0    mov eax,dword ptr ss:[esp+4]
0x007E8DD4    mov edx,dword ptr ds:[eax]
0x007E8DD6    mov dword ptr ds:[ecx+88],edx
0x007E8DDC    mov edx,dword ptr ds:[eax+4]                ; write to speed 'backup' address here
0x007E8DDF    mov dword ptr ds:[ecx+8C],edx
0x007E8DE5    mov eax,dword ptr ds:[eax+8]
0x007E8DE8    mov dword ptr ds:[ecx+90],eax
0x007E8DEE    ret 4


;
; quickload would pass this and mess with 'backup speed'
;


0x007E8ED0    mov eax,dword ptr ss:[esp+4]
0x007E8ED4    push esi
0x007E8ED5    push eax
0x007E8ED6    mov esi,ecx
0x007E8ED8    call fallout3.7DF970
0x007E8EDD    fld st(0),dword ptr ds:[DB38B8]
0x007E8EE3    mov ecx,dword ptr ds:[108EC68]
0x007E8EE9    mov dword ptr ds:[esi+88],ecx               ; old speed backup ?
0x007E8EEF    mov edx,dword ptr ds:[108EC6C]
0x007E8EF5    mov dword ptr ds:[esi+8C],edx
0x007E8EFB    mov eax,dword ptr ds:[108EC70]
0x007E8F00    fstp dword ptr ds:[esi+9C],st(0)
0x007E8F06    mov dword ptr ds:[esi+90],eax
0x007E8F0C    xor eax,eax
0x007E8F0E    mov dword ptr ds:[esi+94],eax
0x007E8F14    mov dword ptr ds:[esi+98],eax
0x007E8F1A    pop esi
0x007E8F1B    ret 4
0x007E8F1E    int3
0x007E8F1F    int3
0x007E8F20    mov eax,dword ptr ss:[esp+4]
0x007E8F24    or dword ptr ds:[ecx+94],eax
0x007E8F2A    ret 4
0x007E8F2D    int3
0x007E8F2E    int3
0x007E8F2F    int3
0x007E8F30    mov eax,dword ptr ss:[esp+4]
0x007E8F34    not eax
0x007E8F36    and dword ptr ds:[ecx+94],eax
0x007E8F3C    ret 4
0x007E8F3F    int3
0x007E8F40    push esi
0x007E8F41    mov esi,ecx
0x007E8F43    mov dword ptr ds:[esi],fallout3.E1EE04
0x007E8F49    call fallout3.7DFAB0
0x007E8F4E    test byte ptr ss:[esp+8],1
0x007E8F53    je fallout3.7E8F60
0x007E8F55    push esi
0x007E8F56    mov ecx,fallout3.1090A78
0x007E8F5B    call fallout3.86BA60
0x007E8F60    mov eax,esi
0x007E8F62    pop esi
0x007E8F63    ret 4
