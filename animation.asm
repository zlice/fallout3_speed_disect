; search for these to find animations in memory
;
;00 00 00 00 16 2D 19 32 95 6C 6F C0 00 00 00 00 00 88 08 3D 16 2D 19 32 94 6C 6F C0 00 D0 A3 3C 00 88 88 3D 16 2D 19 32 98 6C 6F C0 00 98 92 3D 00 CC CC 3D
;
;^mtff - 174 size


;18 00 00 00 00 00 00 00 00 F0 0F 32 00 90 D7 B3 21 30 EB C2 00 88 08 3D 2F 76 92 3C 00 00 80 35 8B 3F EB C2 00 88 88 3D 67 27 80 3D 00 00 80 36
;
;^mt ff hurt - 184 size



;
; loads your pointers structures to prep for animation elation
;


0x008B9BE0    mov eax,dword ptr ds:[ecx+2C]
0x008B9BE3    test eax,eax
0x008B9BE5    je fallout3.8B9C09
0x008B9BE7    movzx ecx,word ptr ds:[eax+A]
0x008B9BEB    mov edx,dword ptr ss:[esp+4]
0x008B9BEF    mov dword ptr ds:[edx],ecx
0x008B9BF1    mov ecx,dword ptr ds:[eax+14]
0x008B9BF4    mov edx,dword ptr ss:[esp+8]
0x008B9BF8    mov dword ptr ds:[edx],ecx
0x008B9BFA    mov cl,byte ptr ds:[eax+1D]
0x008B9BFD    mov edx,dword ptr ss:[esp+C]
0x008B9C01    mov byte ptr ds:[edx],cl
0x008B9C03    mov eax,dword ptr ds:[eax+24]               ; this eax gets overwritten
0x008B9C06    ret C                                       ; is your ptr1, then ptr to anim data
0x008B9C09    mov eax,dword ptr ss:[esp+4]
0x008B9C0D    mov ecx,dword ptr ss:[esp+8]
0x008B9C11    mov edx,dword ptr ss:[esp+C]
0x008B9C15    mov dword ptr ds:[eax],0
0x008B9C1B    mov dword ptr ds:[ecx],0
0x008B9C21    mov byte ptr ds:[edx],0
0x008B9C24    xor eax,eax
0x008B9C26    ret C





;
; easy to get lost in here
; different frames will be treated differently
; animations on certain frames and of certain sizes will loop in different ways
;
; tried to replace some animations while testing things and you can hit infinite loops here
; interesting - if you shift data by a decimal place, the animation is the same
;               no speed increase or anything. 0.3 and 0.03 will transform
;               the object the same if other values are adjusted accordingly
;
; as noted before, if you change ONE value to something outrageous like 600
; you could go forward like youre in space then hit the ground with a big *umph*
; right in front of where you started
;


0x008A1900    push esi
0x008A1901    mov esi,dword ptr ss:[esp+C]
0x008A1905    push edi
0x008A1906    mov edi,dword ptr ss:[esp+C]
0x008A190A    push esi
0x008A190B    push edi
0x008A190C    call fallout3.8B7370
0x008A1911    add esp,8
0x008A1914    push edi
0x008A1915    lea ecx,dword ptr ds:[esi+4]
0x008A1918    call fallout3.83FA20
0x008A191D    pop edi
0x008A191E    pop esi
0x008A191F    ret
0x008A1920    sub esp,1C
0x008A1923    push ebx
0x008A1924    mov ebx,dword ptr ss:[esp+34]
0x008A1928    cmp ebx,1
0x008A192B    je fallout3.8A1B1D
0x008A1931    fld st(0),dword ptr ss:[esp+28]
0x008A1935    fcom st(0),qword ptr ds:[DB7268]
0x008A193B    fnstsw ax
0x008A193D    test ah,44
0x008A1940    jnp fallout3.8A1B1B
0x008A1946    mov eax,dword ptr ss:[esp+38]
0x008A194A    push ebp
0x008A194B    mov ebp,dword ptr ss:[esp+30]
0x008A194F    push esi
0x008A1950    movzx esi,byte ptr ss:[esp+44]
0x008A1955    push edi
0x008A1956    mov edi,dword ptr ds:[eax]                 ; "current animation frame" from stack (see code at bottom)
0x008A1958    mov ecx,esi                                ; copy animation frame "chunk" size
0x008A195A    imul ecx,edi                               ; calc animation frame "chunk" (10 * frame, will add to addy)
0x008A195D    add ebx,FFFFFFFF                           ; subtracts 1 from your "max animation length"
0x008A1960    mov dword ptr ss:[esp+1C],ebx
0x008A1964    fld st(0),dword ptr ds:[ecx+ebp]           ; load next frame to FPU
0x008A1967    fstp dword ptr ss:[esp+10],st(0)
0x008A196B    fld st(0),dword ptr ss:[esp+10]
0x008A196F    fcomp st(0),st(1)
0x008A1971    fnstsw ax
0x008A1973    test ah,41
0x008A1976    jne fallout3.8A1981
0x008A1978    fld st(0),dword ptr ss:[ebp]
0x008A197B    xor edi,edi
0x008A197D    fstp dword ptr ss:[esp+10],st(0)
0x008A1981    fldz
0x008A1983    lea ecx,dword ptr ds:[edi+1]               ; math, "loads" "current frame" + 1
0x008A1986    mov edx,ebx                                ; copy "max" frame to "remaining frames"
0x008A1988    fstp dword ptr ss:[esp+40],st(0)
0x008A198C    sub edx,ecx                                ; subtract "current frame + 1" from "remaining frame - 1" (17 - 1 - 1 = 15)
0x008A198E    add edx,1                                  ; add 1 to "remaining frame" (back to 16 - but this is a net loss at higher frames)
0x008A1991    cmp edx,4                                  ;    ^ buffer afaict, you can't play over or under frame count
0x008A1994    jl fallout3.8A1A9A                         ; compare "remain frame", if it's low it jumps past this to prevent overflows
0x008A199A    lea eax,dword ptr ds:[ecx+3]               ; "loads" 3 + ecx, this does more frame grabbing based on chunk size
0x008A199D    imul eax,esi                               ; e.g. get 40 here, will add to a anim ptr of 05DDC248
0x008A19A0    add eax,ebp
0x008A19A2    mov dword ptr ss:[esp+18],eax
0x008A19A6    mov ebx,esi
0x008A19A8    lea eax,dword ptr ds:[ecx+2]               ; another chunk, this can result in 30
0x008A19AB    imul ebx,ecx
0x008A19AE    imul eax,esi
0x008A19B1    add eax,ebp
0x008A19B3    add ebx,ebp
0x008A19B5    lea ebp,dword ptr ds:[ecx+1]               ; and this 20, all frames next to each other in order
0x008A19B8    imul ebp,esi
0x008A19BB    add ebp,dword ptr ss:[esp+38]
0x008A19BF    lea edx,dword ptr ds:[esi*4]
0x008A19C6    mov dword ptr ss:[esp+14],eax
0x008A19CA    jmp fallout3.8A19CE                        ; skips 2 spots ahead...
0x008A19CC    fstp st(0),st(0)
0x008A19CE    fld st(0),dword ptr ds:[ebx]               ; to here ^^^
0x008A19D0    fstp dword ptr ss:[esp+40],st(0)
0x008A19D4    fld st(0),dword ptr ss:[esp+40]
0x008A19D8    fcom st(0),st(1)                           ; FPU compares are weird...they can kinda get "opposite"
0x008A19DA    fnstsw ax                                  ; FPU flags stored in ax
0x008A19DC    test ah,1                                  ; then the high bits are compared - this means > iirc
0x008A19DF    je fallout3.8A1AB6                         ; will not/only jump once certain animation frame data is above the previous
0x008A19E5    fstp dword ptr ss:[esp+10],st(0)           ; it's double negative logic, i kept having to ref x87 pages
0x008A19E9    fld st(0),dword ptr ss:[ebp]
0x008A19EC    fstp dword ptr ss:[esp+40],st(0)
0x008A19F0    fld st(0),dword ptr ss:[esp+40]
0x008A19F4    fcom st(0),st(1)
0x008A19F6    fnstsw ax
0x008A19F8    test ah,1
0x008A19FB    je fallout3.8A1AA0                         ; similar - this is where infinite loops can happen if you manually
0x008A1A01    mov eax,dword ptr ss:[esp+14]              ;           muck with animation floats
0x008A1A05    fstp dword ptr ss:[esp+10],st(0)
0x008A1A09    fld st(0),dword ptr ds:[eax]
0x008A1A0B    fstp dword ptr ss:[esp+40],st(0)
0x008A1A0F    fld st(0),dword ptr ss:[esp+40]
0x008A1A13    fcom st(0),st(1)
0x008A1A15    fnstsw ax
0x008A1A17    test ah,1
0x008A1A1A    je fallout3.8A1AA8
0x008A1A20    mov eax,dword ptr ss:[esp+18]
0x008A1A24    fstp dword ptr ss:[esp+10],st(0)
0x008A1A28    fld st(0),dword ptr ds:[eax]
0x008A1A2A    fstp dword ptr ss:[esp+40],st(0)
0x008A1A2E    fld st(0),dword ptr ss:[esp+40]
0x008A1A32    fcom st(0),st(1)
0x008A1A34    fnstsw ax
0x008A1A36    test ah,1
0x008A1A39    je fallout3.8A1AB0
0x008A1A3B    mov eax,dword ptr ss:[esp+1C]
0x008A1A3F    fst dword ptr ss:[esp+10],st(0)
0x008A1A43    add dword ptr ss:[esp+14],edx
0x008A1A47    add dword ptr ss:[esp+18],edx
0x008A1A4B    add ecx,4
0x008A1A4E    add eax,FFFFFFFD
0x008A1A51    add edi,4
0x008A1A54    add ebx,edx
0x008A1A56    add ebp,edx
0x008A1A58    cmp ecx,eax
0x008A1A5A    jbe fallout3.8A19CC
0x008A1A60    mov ebx,dword ptr ss:[esp+1C]
0x008A1A64    mov ebp,dword ptr ss:[esp+38]
0x008A1A68    cmp ecx,ebx
0x008A1A6A    ja fallout3.8A1ABA
0x008A1A6C    mov edx,esi
0x008A1A6E    imul edx,ecx
0x008A1A71    add edx,ebp
0x008A1A73    fstp st(0),st(0)
0x008A1A75    fld st(0),dword ptr ds:[edx]
0x008A1A77    fstp dword ptr ss:[esp+40],st(0)
0x008A1A7B    fld st(0),dword ptr ss:[esp+40]
0x008A1A7F    fcom st(0),st(1)
0x008A1A81    fnstsw ax
0x008A1A83    test ah,1
0x008A1A86    je fallout3.8A1ABA
0x008A1A88    add ecx,1
0x008A1A8B    fst dword ptr ss:[esp+10],st(0)
0x008A1A8F    add edi,1
0x008A1A92    add edx,esi
0x008A1A94    cmp ecx,ebx
0x008A1A96    jbe fallout3.8A1A73
0x008A1A98    jmp fallout3.8A1ABA
0x008A1A9A    fld st(0),dword ptr ss:[esp+40]            ; if "animation max frame" < 4 - jumps here
0x008A1A9E    jmp fallout3.8A1A68
0x008A1AA0    add ecx,1
0x008A1AA3    add edi,1
0x008A1AA6    jmp fallout3.8A1AB6
0x008A1AA8    add ecx,2
0x008A1AAB    add edi,2
0x008A1AAE    jmp fallout3.8A1AB6
0x008A1AB0    add ecx,3
0x008A1AB3    add edi,3
0x008A1AB6    mov ebp,dword ptr ss:[esp+38]              ; eventually you'll hit here or past
0x008A1ABA    fld st(0),dword ptr ss:[esp+10]
0x008A1ABE    mov eax,esi
0x008A1AC0    imul esi,edi
0x008A1AC3    fld st(0),st(0)
0x008A1AC5    fsubp st(3),st(0)
0x008A1AC7    fsubp st(1),st(0)
0x008A1AC9    fdivp st(1),st(0)
0x008A1ACB    lea edx,dword ptr ss:[esp+20]
0x008A1ACF    push edx
0x008A1AD0    add esi,ebp
0x008A1AD2    imul eax,ecx
0x008A1AD5    fstp dword ptr ss:[esp+44],st(0)
0x008A1AD9    fld st(0),dword ptr ss:[esp+44]
0x008A1ADD    add eax,ebp
0x008A1ADF    push eax
0x008A1AE0    push esi
0x008A1AE1    push ecx
0x008A1AE2    mov ecx,dword ptr ss:[esp+4C]
0x008A1AE6    mov edx,dword ptr ds:[ecx*4+10924F0]
0x008A1AED    fstp dword ptr ss:[esp],st(0)
0x008A1AF0    call edx                                   ; call to multiple functions from 10924F0 table
0x008A1AF2    mov eax,dword ptr ss:[esp+54]
0x008A1AF6    mov ecx,dword ptr ss:[esp+30]
0x008A1AFA    mov edx,dword ptr ss:[esp+34]
0x008A1AFE    add esp,10
0x008A1B01    mov dword ptr ds:[eax],edi
0x008A1B03    mov eax,dword ptr ss:[esp+30]
0x008A1B07    pop edi
0x008A1B08    mov dword ptr ds:[eax],ecx
0x008A1B0A    mov ecx,dword ptr ss:[esp+24]
0x008A1B0E    pop esi
0x008A1B0F    pop ebp
0x008A1B10    mov dword ptr ds:[eax+4],edx
0x008A1B13    mov dword ptr ds:[eax+8],ecx
0x008A1B16    pop ebx
0x008A1B17    add esp,1C
0x008A1B1A    ret
0x008A1B1B    fstp st(0),st(0)
0x008A1B1D    mov ecx,dword ptr ss:[esp+2C]
0x008A1B21    mov edx,dword ptr ds:[ecx+4]
0x008A1B24    mov eax,dword ptr ss:[esp+24]
0x008A1B28    mov dword ptr ds:[eax],edx
0x008A1B2A    mov edx,dword ptr ds:[ecx+8]
0x008A1B2D    mov ecx,dword ptr ds:[ecx+C]
0x008A1B30    mov dword ptr ds:[eax+4],edx
0x008A1B33    mov dword ptr ds:[eax+8],ecx
0x008A1B36    pop ebx
0x008A1B37    add esp,1C
0x008A1B3A    ret


;
; call edx - form above
;
; one of a few areas animation data can be used
; i didn't bother going into depth in the math, got lost enough as is
; but these values don't varry much, more or less the same until
; you get a different player speed or animation
;

0x008A4C50    sub esp,24
0x008A4C53    fld st(0),dword ptr ss:[esp+28]
0x008A4C57    mov eax,dword ptr ss:[esp+2C]
0x008A4C5B    fld st(0),st(0)
0x008A4C5D    fld1
0x008A4C5F    fsubrp st(1),st(0)
0x008A4C61    fstp dword ptr ss:[esp+2C],st(0)
0x008A4C65    fld st(0),dword ptr ds:[eax+4]
0x008A4C68    fld st(0),dword ptr ss:[esp+2C]
0x008A4C6C    fld st(0),st(0)
0x008A4C6E    fmulp st(2),st(0)
0x008A4C70    fxch st(0),st(1)
0x008A4C72    fstp dword ptr ss:[esp+C],st(0)
0x008A4C76    fld st(0),dword ptr ds:[eax+8]
0x008A4C79    fmul st(0),st(1)
0x008A4C7B    fstp dword ptr ss:[esp+10],st(0)
0x008A4C7F    fmul st(0),dword ptr ds:[eax+C]
0x008A4C82    mov eax,dword ptr ss:[esp+30]
0x008A4C86    fstp dword ptr ss:[esp+14],st(0)
0x008A4C8A    fld st(0),dword ptr ds:[eax+4]
0x008A4C8D    fmul st(0),st(1)
0x008A4C8F    fstp dword ptr ss:[esp],st(0)
0x008A4C92    fld st(0),dword ptr ds:[eax+8]
0x008A4C95    fmul st(0),st(1)
0x008A4C97    fstp dword ptr ss:[esp+4],st(0)
0x008A4C9B    fmul st(0),dword ptr ds:[eax+C]
0x008A4C9E    mov eax,dword ptr ss:[esp+34]
0x008A4CA2    fstp dword ptr ss:[esp+8],st(0)
0x008A4CA6    fld st(0),dword ptr ss:[esp]
0x008A4CA9    fadd st(0),dword ptr ss:[esp+C]
0x008A4CAD    fstp dword ptr ss:[esp+18],st(0)
0x008A4CB1    mov ecx,dword ptr ss:[esp+18]
0x008A4CB5    fld st(0),dword ptr ss:[esp+10]
0x008A4CB9    mov dword ptr ds:[eax],ecx
0x008A4CBB    fadd st(0),dword ptr ss:[esp+4]
0x008A4CBF    fstp dword ptr ss:[esp+1C],st(0)
0x008A4CC3    mov edx,dword ptr ss:[esp+1C]
0x008A4CC7    fld st(0),dword ptr ss:[esp+8]
0x008A4CCB    mov dword ptr ds:[eax+4],edx
0x008A4CCE    fadd st(0),dword ptr ss:[esp+14]
0x008A4CD2    fstp dword ptr ss:[esp+20],st(0)
0x008A4CD6    mov ecx,dword ptr ss:[esp+20]
0x008A4CDA    mov dword ptr ds:[eax+8],ecx
0x008A4CDD    add esp,24
0x008A4CE0    ret


;
; frame counting
;


0x008BA085    lea eax,dword ptr ss:[esp+14]
0x008BA089    push eax
0x008BA08A    lea ecx,dword ptr ss:[esp+1C]
0x008BA08E    push ecx
0x008BA08F    lea edx,dword ptr ss:[esp+18]
0x008BA093    push edx
0x008BA094    mov ecx,ebx
0x008BA096    call fallout3.8B9BE0
0x008BA09B    mov ecx,dword ptr ss:[esp+10]
0x008BA09F    test ecx,ecx
0x008BA0A1    jbe fallout3.8BA0EB
0x008BA0A3    movzx edx,word ptr ds:[ebx+30]         ; this loads the ptr2 "current animation frame"
0x008BA0A7    fld st(0),dword ptr ss:[esp+30]
0x008BA0AB    mov dword ptr ss:[esp+C],edx           ; this puts it on the stack, it get's used a couple more times
0x008BA0AF    mov edx,dword ptr ss:[esp+14]
0x008BA0B3    push edx
0x008BA0B4    lea edx,dword ptr ss:[esp+10]
0x008BA0B8    push edx
0x008BA0B9    push ecx
0x008BA0BA    mov ecx,dword ptr ss:[esp+24]
0x008BA0BE    push ecx
0x008BA0BF    push eax
0x008BA0C0    push ecx
0x008BA0C1    lea edx,dword ptr ss:[esp+34]
0x008BA0C5    fstp dword ptr ss:[esp],st(0)
0x008BA0C8    push edx
0x008BA0C9    call fallout3.8A1920
0x008BA0CE    mov ecx,dword ptr ds:[eax]
0x008BA0D0    mov dword ptr ds:[ebx+C],ecx
0x008BA0D3    mov edx,dword ptr ds:[eax+4]
0x008BA0D6    mov cx,word ptr ss:[esp+28]            ; get the next frame off the stack
0x008BA0DB    mov dword ptr ds:[ebx+10],edx
0x008BA0DE    mov eax,dword ptr ds:[eax+8]
0x008BA0E1    mov dword ptr ds:[ebx+14],eax
0x008BA0E4    add esp,1C
0x008BA0E7    mov word ptr ds:[ebx+30],cx            ; the next frame is put back to ptr2's struct
0x008BA0EB    lea edx,dword ptr ss:[esp+14]
0x008BA0EF    push edx
0x008BA0F0    lea eax,dword ptr ss:[esp+1C]
0x008BA0F4    push eax
0x008BA0F5    lea ecx,dword ptr ss:[esp+18]
0x008BA0F9    push ecx
0x008BA0FA    mov ecx,ebx
0x008BA0FC    call fallout3.507B30
0x008BA101    mov ecx,dword ptr ss:[esp+10]
0x008BA105    test ecx,ecx
0x008BA107    jbe fallout3.8BA157
0x008BA109    movzx edx,word ptr ds:[ebx+32]
0x008BA10D    fld st(0),dword ptr ss:[esp+30]
0x008BA111    mov dword ptr ss:[esp+C],edx
0x008BA115    mov edx,dword ptr ss:[esp+14]
0x008BA119    push edx
0x008BA11A    lea edx,dword ptr ss:[esp+10]
0x008BA11E    push edx
0x008BA11F    push ecx
0x008BA120    mov ecx,dword ptr ss:[esp+24]
0x008BA124    push ecx
0x008BA125    push eax
0x008BA126    push ecx
0x008BA127    lea edx,dword ptr ss:[esp+34]
0x008BA12B    fstp dword ptr ss:[esp],st(0)
0x008BA12E    push edx
0x008BA12F    call fallout3.8A2BE0
0x008BA134    mov ecx,dword ptr ds:[eax]
0x008BA136    mov dword ptr ds:[ebx+18],ecx
0x008BA139    mov edx,dword ptr ds:[eax+4]
0x008BA13C    mov dword ptr ds:[ebx+1C],edx
0x008BA13F    mov ecx,dword ptr ds:[eax+8]
0x008BA142    mov dword ptr ds:[ebx+20],ecx
0x008BA145    mov edx,dword ptr ds:[eax+C]
0x008BA148    mov ax,word ptr ss:[esp+28]
0x008BA14D    mov dword ptr ds:[ebx+24],edx
0x008BA150    add esp,1C
0x008BA153    mov word ptr ds:[ebx+32],ax
0x008BA157    lea ecx,dword ptr ss:[esp+14]
0x008BA15B    push ecx
0x008BA15C    lea edx,dword ptr ss:[esp+1C]
0x008BA160    push edx
0x008BA161    lea eax,dword ptr ss:[esp+18]
0x008BA165    push eax
0x008BA166    mov ecx,ebx
0x008BA168    call fallout3.8B9C30
0x008BA16D    mov ecx,dword ptr ss:[esp+10]
0x008BA171    test ecx,ecx
0x008BA173    jbe fallout3.8BA1AA
0x008BA175    movzx edx,word ptr ds:[ebx+34]
0x008BA179    fld st(0),dword ptr ss:[esp+30]
0x008BA17D    mov dword ptr ss:[esp+C],edx
0x008BA181    mov edx,dword ptr ss:[esp+14]
0x008BA185    push edx
0x008BA186    lea edx,dword ptr ss:[esp+10]
0x008BA18A    push edx
0x008BA18B    push ecx
0x008BA18C    mov ecx,dword ptr ss:[esp+24]
0x008BA190    push ecx
0x008BA191    push eax
0x008BA192    push ecx
0x008BA193    fstp dword ptr ss:[esp],st(0)
0x008BA196    call fallout3.8A1080
0x008BA19B    mov dx,word ptr ss:[esp+24]
0x008BA1A0    fstp dword ptr ds:[ebx+28],st(0)
0x008BA1A3    add esp,18
0x008BA1A6    mov word ptr ds:[ebx+34],dx
0x008BA1AA    mov edi,dword ptr ss:[esp+38]
0x008BA1AE    lea edx,dword ptr ds:[ebx+C]
0x008BA1B1    mov ecx,8
0x008BA1B6    mov esi,edx
0x008BA1B8    rep movsd
0x008BA1BA    fld st(0),dword ptr ds:[edx+1C]
0x008BA1BD    fld st(0),qword ptr ds:[DB7268]
0x008BA1C3    fucom st(0),st(1)
0x008BA1C5    fnstsw ax
0x008BA1C7    fstp st(1),st(0)
0x008BA1C9    test ah,44
0x008BA1CC    jp fallout3.8BA1F0
0x008BA1CE    fld st(0),dword ptr ds:[edx+10]
0x008BA1D1    fucomp st(0),st(1)
0x008BA1D3    fnstsw ax
0x008BA1D5    test ah,44
0x008BA1D8    jp fallout3.8BA1F0
0x008BA1DA    fld st(0),dword ptr ds:[edx]
0x008BA1DC    fucompp
0x008BA1DE    fnstsw ax
0x008BA1E0    test ah,44
0x008BA1E3    jp fallout3.8BA1F2
0x008BA1E5    pop edi
0x008BA1E6    pop esi
0x008BA1E7    xor al,al
0x008BA1E9    pop ebx
0x008BA1EA    add esp,20
0x008BA1ED    ret C
0x008BA1F0    fstp st(0),st(0)
0x008BA1F2    fld st(0),dword ptr ss:[esp+30]
0x008BA1F6    fstp dword ptr ds:[ebx+8],st(0)
0x008BA1F9    pop edi
0x008BA1FA    pop esi
0x008BA1FB    mov al,1
0x008BA1FD    pop ebx
0x008BA1FE    add esp,20
0x008BA201    ret C
