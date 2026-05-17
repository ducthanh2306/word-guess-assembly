# word-guess-assembly
# Word Guess Game in Assembly x86

Một mini game đoán từ được xây dựng bằng **x86 Assembly (MASM/TASM)** trên môi trường DOS.  
Người chơi sẽ đoán một từ khóa gồm 5 ký tự được hệ thống chọn ngẫu nhiên từ danh sách có sẵn.

## Gameplay


::contentReference[oaicite:0]{index=0}


- Hệ thống chọn ngẫu nhiên 1 từ gồm 5 ký tự.
- Người chơi có tối đa **4 lượt đoán**.
- Sau mỗi lần đoán sai, hệ thống sẽ mở thêm **1 ký tự** trong đáp án.
- Nếu đoán đúng trước khi hết lượt → **Game Win**
- Nếu hết lượt mà chưa đoán đúng → **Game Over**

Ví dụ:

```txt
Tu bi an: *****

Nhap tu ban doan: HOUSE
Sai roi! Goi y them: T****

Nhap tu ban doan: WATER
Sai roi! Goi y them: TI***

Nhap tu ban doan: TIGER
Chuc mung! Ban da doan dung!
```

---

## Từ khóa trong game

Danh sách từ khóa hiện tại:

- APPLE
- HELLO
- WORLD
- GAMES
- WATER
- MOUSE
- TIGER
- CLOUD

---

## Các chức năng chính

### 1. Random từ khóa
Game sử dụng thuật toán **:contentReference[oaicite:1]{index=1} (LCG)** để sinh số ngẫu nhiên và chọn từ.

### 2. Xử lý input
- Nhập từ bằng bàn phím.
- Tự động chuyển chữ thường thành chữ in hoa.
- Kiểm tra độ dài phải đúng 5 ký tự.

### 3. So sánh chuỗi
Sử dụng các string instruction của x86:
- `MOVSB`
- `CMPSB`
- `REP`

### 4. Replay game
Sau khi kết thúc:
- Nhấn `Y` → chơi tiếp
- Nhấn `N` → thoát game

---

## Kiến thức Assembly sử dụng

Project này sử dụng:

- DOS Interrupt `INT 21h`
- Quản lý segment (`DS`, `ES`)
- String instructions
- Keyboard input buffer
- Pseudo random generation
- Memory addressing

---

## Cách build và chạy

### Với :contentReference[oaicite:2]{index=2} (TASM)

```bash
tasm game.asm
tlink game.obj
game.exe
```

### Với :contentReference[oaicite:3]{index=3} (MASM)

```bash
masm game.asm;
link game.obj;
game.exe
```

---

## Cấu trúc chương trình

```txt
Start Game
   ↓
Random Word
   ↓
Player Input
   ↓
Check Answer
   ├── Correct → Win
   └── Wrong → Reveal Hint
                   ↓
             Retry / Lose
```

---

## Mục tiêu dự án

Dự án được xây dựng nhằm luyện tập:

- Assembly cơ bản
- Xử lý chuỗi
- Input/Output trong DOS
- Thiết kế game logic ở mức low-level
