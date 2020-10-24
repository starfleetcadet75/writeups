#!/usr/bin/env python3

# Usage: docker run -it --rm -v $PWD:/local angr/angr
import logging
import claripy
import angr

def hook(l=None):
    if l:
        locals().update(l)
    import IPython
    IPython.embed(banner1='', confirm_exit=False)
    exit(0)

logging.getLogger("angr").setLevel(logging.INFO)
proj = angr.Project("./target", load_options={"auto_load_libs": False})

# Start the program from an arbitrary point
state = proj.factory.blank_state(addr=0x80484c1)

# Call a specific function with arguments
# func = proj.factory.callable(0x40030)
# func(0x824, 0x82c, 0x82b, 0x82c)
# print(func.result_state.posix.stdout.concretize())

# Start from the entry point with symbolic arguments or input
# arg1 = claripy.BVS('arg1', 34 * 8)
# state = proj.factory.entry_state(args=[filename, arg1], stdin=arg1)
# state = proj.factory.entry_state(add_options=angr.options.unicorn)

# Constrain all chars to be printable
# for char in arg1.chop(8):
#     state.solver.add(char != '\x00')  # null
#     state.solver.add(char >= ' ')  # '\x20'
#     state.solver.add(char <= '~')  # '\x7e'

# Create a symbolic string and constrain specific byte values
char = state.solver.BVS("char", 4 * 8)
state.solver.add(char.get_byte(2) == state.solver.BVV(0x30, 8))
state.solver.add(char.get_byte(1) == state.solver.BVV(0x2d, 8))
state.solver.add(char.get_byte(0) == state.solver.BVV(0x00, 8))

# Since we started from inside a function, we need to setup
# the arguments that should have been passed to it. We pass
# the symbolic string as an argument to the function in memory.
state.memory.store(state.regs.ebp + 0x8, char)
state.memory.store(state.regs.ebp + 0xc, 0x20)

# Create a concrete file
simfile = angr.SimFile('key', content='A'*32)
state.fs.insert('./key', simfile)

# Create simgr from the state
# Veritesting helps reduce useless loops
simgr = proj.factory.simgr(state, veritesting=True)

# Use history of active states to identify bottleneck locations
# list(map(hex, simgr.active[0].history.bbl_addrs))
#
# Example: Hook the strcspn function and remove it to speed up exploration
# def nop(state):
#     state.regs.rax = 36
# proj.hook(addr=0x400fef, hook=nop, length=5)

print_flag = proj.loader.find_symbol("read_and_print_flag").rebased_addr
simgr.explore(find=print_flag, avoid=[0x400c58])

if simgr.found:
    found = simgr.found[0]

    # Concretize a value from stdin
    # print(found.posix.stdin.concretize())

    # Retrieve the value of a string in memory
    # output = found.memory.load(0x8049b20, 32)

    # Constrain the value of `eax` and solve for char
    found.state.solver.add(found.memory.regs.eax == 0x61548feb)
    solution = found.state.solver.eval(char, cast_to=bytes)
    print(solution)

else:
    print("Failed to find a path")

hook(locals())

