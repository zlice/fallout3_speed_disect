;
; the global "direction" / "move" / "anim" / "player" _status_ whatever you want to call it
; this gets tossed around and set from different calls
; input got passed from somewhere but i'm not sure i ever saw "where"
; just the correlation between direction, status(fighting?), looking/turning
;
; there's more after this function snippet that looked like mouse/look/turn
; just didn't look at it since it wasn't likely to be related to speed cripple
;
; note: if you break here, it's every frame. you have to hold direction while un-pausing
;       of there will be a "no direction" ever time
;

0x00720612    mov ecx,dword ptr ds:[107A104]
0x00720618    cmp esi,ecx
0x0072061A    jne fallout3.72062D
0x0072061C    push 1
0x0072061E    call fallout3.76CCE0
0x00720623    add eax,11C
0x00720628    cmp dword ptr ds:[eax],0
0x0072062B    jne fallout3.720644
0x0072062D    mov eax,dword ptr ss:[esp+50]
0x00720631    test eax,eax
0x00720633    je fallout3.72063B
0x00720635    cmp byte ptr ds:[eax+E],14
0x00720639    ja fallout3.720644
0x0072063B    mov ebp,1
0x00720640    mov dword ptr ss:[esp+18],ebp
0x00720644    test bl,F                                              ; F is no movement direction
0x00720647    fld st(0),dword ptr ss:[esp+6C]
0x0072064B    fstp dword ptr ss:[esp+30],st(0)
0x0072064F    je fallout3.72073B                                     ; skip all this if not moving
0x00720655    test ebx,200                                           ; here "status" (keypress?) is in ebx
0x0072065B    je fallout3.7206BD                                     ; and 200 or'd if moving
0x0072065D    test bl,1                                              ; direction is bl
0x00720660    je fallout3.720669
0x00720662    mov ebp,7                                              ; 7 is forward
0x00720667    jmp fallout3.72068B
0x00720669    test bl,2
0x0072066C    je fallout3.720675
0x0072066E    mov ebp,8                                              ; 8 is back
0x00720673    jmp fallout3.72068B
0x00720675    test bl,4
0x00720678    je fallout3.720681
0x0072067A    mov ebp,9                                              ; 9 is left
0x0072067F    jmp fallout3.72068B
0x00720681    test bl,8
0x00720684    je fallout3.72068F
0x00720686    mov ebp,A                                              ; A is right
0x0072068B    mov dword ptr ss:[esp+18],ebp
0x0072068F    mov edx,dword ptr ds:[esi]
0x00720691    mov eax,dword ptr ds:[edx+38C]                         ; get micro call
0x00720697    mov ecx,esi
0x00720699    call eax                                               ; "mov eax, 2 - ret" when moving
0x0072069B    test eax,eax
0x0072069D    mov ecx,esi

;
; there is a hardcode with an offset that hits "anim status"
; hardcode is only referenced here
; believe "status" becomes dynamic in calls
;

0x005337B5    call fallout3.54B750
0x005337BA    mov ecx,dword ptr ds:[eax*4+F5AC5C]
0x005337C1    mov edx,dword ptr ds:[edi*4+F5C728]        ; "player" status here
0x005337C8    add esp,4
0x005337CB    push ecx
0x005337CC    push edx
0x005337CD    push fallout3.DD7D0C
0x005337D2    call fallout3.6195D0

;
; "status" init i guess you could call it
;

0x0045DC59    call edx
0x0045DC5B    cmp edi,1
0x0045DC5E    jne fallout3.45DC6C
0x0045DC60    mov eax,dword ptr ds:[esi+E4]
0x0045DC66    mov dword ptr ds:[esi+100],eax
0x0045DC6C    mov dword ptr ds:[esi+edi*4+E0],0
0x0045DC77    mov eax,FF                                  ; FF is "nothing"
0x0045DC7C    mov word ptr ds:[esi+edi*2+4C],ax           ; offsets to status var here
0x0045DC81    mov word ptr ds:[esi+edi*2+9C],ax           ; another var
0x0045DC89    mov dword ptr ds:[esi+edi*4+5C],FFFFFFFF    ; these vars get set to F's the start of every frame/cycle
0x0045DC91    pop edi
0x0045DC92    pop esi
0x0045DC93    ret 8

;
; one of the calls that grabs "status"
;

0x0045F790    call fallout3.45DB50
0x0045F795    mov ax,word ptr ss:[esp+40]
0x0045F79A    mov word ptr ds:[esi+ebx*2+4C],ax         ; get "status"
0x0045F79F    mov dword ptr ds:[esi+ebx*4+E0],ebp
0x0045F7A6    call fallout3.619160

;
;the bigger picture got set here
;

0x0045F79F    mov dword ptr ds:[esi+ebx*4+E0],ebp
