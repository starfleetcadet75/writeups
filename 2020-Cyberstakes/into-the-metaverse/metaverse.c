
void add_0x43(struct CPU* state) {
    int16_t op1 = *state->sp;
    int16_t op2 = *(state->sp - 2);
    state->sp -= 2;
    *state->sp = op2 + op1;
    state->pc += 1;
}

void sub_0x51(struct CPU* state)
    int16_t op1 = *state->sp;
    int16_t op2 = *(state->sp - 2);
    state->sp -= 2;
    *state->sp = op2 - op1;
    state->pc += 1;
}

void xor_0xf0(struct CPU* state) {
    int16_t op1 = (*state->sp);
    int16_t op2 = (*state->sp - 2);
    state->sp -= 2;
    *state->sp = op1 ^ op2;
    state->pc += 1;
}

void handle_0x12(struct CPU* state) {
    int16_t op = *state->sp;
    state->sp += 2;
    *state->sp = op;
    state->pc += 1;
}

void handle_0x38(struct CPU* state) {
    int16_t op = *state->sp;
    *state->sp = *(state->sp - 2);
    *(state->sp - 2) = op;
    state->pc += 1;
}

void handle_0x93(struct CPU* state) {
    state->sp += 2;   // Allocate 2 bytes on the stack
    *state->pc += 1;  // Increment the next byte of code by 1
    *state->sp = pc;  // Store the pc on the stack
    state->pc += 2;   // Increment the pc by 2 bytes
}

// ld [op]
void load_0x02(struct CPU* state) {
    uint64_t op = *state->sp;
    *state->sp = *(op + op + state->code);
    state->pc++;
}

// str op1, [op2]
void store_0xc1(struct CPU* state) {
    int16_t op1 = *state->sp;
    int16_t op2 = *state->sp - 2;
    state->sp -= 4;
    *(op2 + op2 + state->code) = op1;
    state->pc++;
}

// cmp op1, op2
void cmp_0xa4(struct CPU* state) {
    int16_t op1 = *state->sp;
    int16_t op2 = *state->sp - 2;
    state->sp = state->sp - 2;
    *state->sp = (op1 == op2);
    state->pc++;
}

// sal op
void sal_0x22(struct CPU* state) {
    int16_t op = *state->sp;
    *state->sp = (0 | (op << 4) | ((op >> 4) & 0xf));
    state->pc++;
}

void handle_0xd7(struct CPU* state) {
    int16_t op = *state->sp;
    *state->sp = ((op >> 4) & 0x0f00 | (op << 4) & 0xf000 | op);
    state->pc++;
}

void handle_0x8a(struct CPU* state) {
    // Argument is the pc
    int16_t op = *state->sp;
    state->sp -= 2;

    *(state->code + 0x600) = 0;
    *(state->code + 0x602) = op;

    if (op == 0) {
        int i = 0;
        while (i < ((state->code + 0x800) - state->pc) - 1) {
            // If next value in code is 0xb24b jump somewhere
            if ((*(i + state->pc)) == 0xb2 &&
                    (*(state->pc + i + 1)) == 0x4b) {
                state->pc = i + 2 + state->pc;
                break;
            }
            i++;
        }
    }
    else {
        state->pc += 2;
    }
}

// Branching?
void handle_0xb2(struct CPU* state) {
    if (*(state->code + 0x600) >= *(state->code + 0x602)) {
        state->pc += 2;
    }
    else {
        int32_t i = 1;
        while (i < state->pc - (state + 16)) {
            if (*(state->pc + neg(i) - 1) == 0x8a &&
                    *(neg(i) + state->pc) == 0x1a) {
                state->pc = neg(i) + 1 + state->pc;
                break;
            }
            i++;
        }
    }
}

// nop
void nop_0x90(struct CPU* state) {
    state->pc++;
}

// halt
void halt_0x62(struct CPU* state) {
    if (*state->sp != 1) {
        puts("Wrong");
    }
    else {
        puts("Flag Captured!");
    }
    exit(0);
}

