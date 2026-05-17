.model small
.stack 100h

.data
    ; --- Kho tu vung (5 chu cai) ---
    word0 db 'APPLE'
    word1 db 'HELLO'
    word2 db 'WORLD'
    word3 db 'GAMES'
    word4 db 'WATER'
    word5 db 'MOUSE'
    word6 db 'TIGER'
    word7 db 'CLOUD'

    target db 5 dup(?), '$'   ; Chua tu duoc chon ngau nhien
    hint   db '*****', '$'    ; Trang thai goi y hien tai
    reset_str db '*****'      ; Chuoi goc de reset hint
    
    seed   dw 0               ; Bien luu tru "hat giong" cho thuat toan random

    ; --- Cac cau thong bao ---
    msg_intro  db 13, 10, '--- GAME DOAN TU (5 CHU CAI) ---', 13, 10, '$'
    msg_first  db 'Tu bi an: $'
    msg_prompt db 13, 10, 'Nhap tu ban doan (5 ki tu): $'
    msg_hint   db 13, 10, 'Sai roi! Goi y them: $'
    msg_win    db 13, 10, 'Chuc mung! Ban da doan dung!', 13, 10, '$'
    msg_lose   db 13, 10, 'Ban thua roi! Tu dung la: $'
    msg_replay db 13, 10, 13, 10, 'Ban co muon choi tiep khong? (Y/N): $'
    newline    db 13, 10, '$'

    ; --- Buffer de nhan input tu ban phim ---
    buffer db 6           
    len    db ?           
    input  db 6 dup(0)    

.code
main proc
    mov ax, @data
    mov ds, ax
    mov es, ax
    cld                   ; FIX: Ð?m b?o chi?u thao tác chu?i luôn t? trái sang ph?i

    ; --- KHOI TAO SEED RANDOM BAN DAU ---
    mov ah, 2Ch
    int 21h               ; Lay thoi gian he thong
    mov byte ptr seed, dl   
    mov byte ptr seed+1, dh 

start_game:
    ; --- 0. RESET TRANG THAI ---
    lea si, reset_str
    lea di, hint
    mov cx, 5
    rep movsb             

    ; In loi chao
    mov ah, 09h
    lea dx, msg_intro
    int 21h

    ; --- 1. LAY TU NGAU NHIEN (Thuat toan LCG) ---
    mov ax, seed
    mov cx, 25173
    mul cx                
    add ax, 13849         
    mov seed, ax          

    mov dx, 0             
    mov cx, 8
    div cx                

    cmp dl, 0
    je pick_w0
    cmp dl, 1
    je pick_w1
    cmp dl, 2
    je pick_w2
    cmp dl, 3
    je pick_w3
    cmp dl, 4
    je pick_w4
    cmp dl, 5
    je pick_w5
    cmp dl, 6
    je pick_w6
    jmp pick_w7

pick_w0: lea si, word0
         jmp copy_target
pick_w1: lea si, word1
         jmp copy_target
pick_w2: lea si, word2
         jmp copy_target
pick_w3: lea si, word3
         jmp copy_target
pick_w4: lea si, word4
         jmp copy_target
pick_w5: lea si, word5
         jmp copy_target
pick_w6: lea si, word6
         jmp copy_target
pick_w7: lea si, word7
         jmp copy_target

copy_target:
    lea di, target
    mov cx, 5
    rep movsb

    ; --- 1.5 IN TRANG THAI ***** BAN DAU ---
    mov ah, 09h
    lea dx, msg_first
    int 21h
    lea dx, hint
    int 21h

game_loop:
    ; --- 2. NHAP TU NGUOI CHOI ---
    mov ah, 09h
    lea dx, msg_prompt
    int 21h

    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; --- 3. KIEM TRA DO DAI VA CHUYEN IN HOA ---
    mov cl, len
    mov ch, 0
    cmp cx, 5
    jne wrong_guess       

    lea si, input
to_upper:
    mov al, [si]
    cmp al, 'a'
    jb skip_upper
    cmp al, 'z'
    ja skip_upper
    sub byte ptr [si], 32 
skip_upper:
    inc si
    loop to_upper

    ; --- 4. SO SANH CHUOI ---
    lea si, input
    lea di, target
    mov cx, 5
    rep cmpsb
    je win                

wrong_guess:
    ; --- 5. XU LY KHI DOAN SAI ---
    lea si, hint
    lea di, target
    mov cx, 5
find_star:
    mov al, [si]
    cmp al, '*'
    je reveal_char        
    inc si
    inc di
    loop find_star
    
    jmp lose              

reveal_char:
    mov al, [di]
    mov [si], al          ; Mo ki tu moi vao bien hint

    ; --- KIEM TRA XEM DA MO HET CHUA ---
    lea bx, hint
    mov cx, 5
check_done:
    mov al, [bx]
    cmp al, '*'
    je continue_game      ; Neu van con it nhat 1 dau '*', tiep tuc choi
    inc bx
    loop check_done
    
    ; Neu vong lap chay het ma khong tim thay '*' nao -> THUA LUON
    jmp lose

continue_game:
    ; Neu chua thua, in ra goi y moi roi quay lai game
    mov ah, 09h
    lea dx, msg_hint
    int 21h
    lea dx, hint
    int 21h

    jmp game_loop

win:
    mov ah, 09h
    lea dx, msg_win
    int 21h
    jmp ask_replay

lose:
    mov ah, 09h
    lea dx, msg_lose
    int 21h
    lea dx, target
    int 21h
    mov ah, 09h
    lea dx, newline
    int 21h

ask_replay:
    ; --- 6. HOI CHOI LAI ---
    mov ah, 09h
    lea dx, msg_replay
    int 21h

    mov ah, 01h           
    int 21h

    cmp al, 'y'
    je start_game         
    cmp al, 'Y'
    je start_game         

exit_game:
    mov ah, 4Ch
    int 21h
main endp
end main