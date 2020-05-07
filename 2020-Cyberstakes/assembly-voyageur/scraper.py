from bs4 import BeautifulSoup

with open("AssemblyVoyageur.html", "r") as f:
    page = f.read()

soup = BeautifulSoup(page, 'html.parser')
print(soup.prettify())

regstate = soup.body.find_all("ul")[0]
snippets = soup.body.find_all("textarea")
i386 = snippets[0]
amd64 = snippets[1]
aarch64 = snippets[2]
mips = snippets[3]
ppc = snippets[4]

# Create i386
with open("i386.asm", "w") as f:
    f.write("BITS 32\n")
    f.write("SECTION .text\n")
    f.write("global main\n")
    f.write("main:\n")

    # Add the initial register state
    for reg in regstate.find_all("li"):
        v, r = reg.contents[0].split()
        r = r[:-2].lower()
        f.write("mov " + r + ", " + v + "\n")

    for line in i386.contents:
        f.write(line)
    f.write("db 0xcc")

# Create amd64
with open("amd64.asm", "w") as f:
    f.write("BITS 64\n")
    f.write("SECTION .text\n")
    f.write("global main\n")
    f.write("main:\n")

    for line in amd64.contents:
        f.write(line)
    f.write("db 0xcc")

# Create aarch64
with open("aarch64.asm", "w") as f:
    f.write(".global main\n")
    f.write(".text\n")
    f.write("main:\n")

    for line in aarch64.contents:
        f.write(line)

# Create mips
with open("mips.S", "w") as f:
    f.write("#define zero $0\n")
    f.write("#define AT   $1\n")
    f.write("#define v0   $2\n")
    f.write("#define v1   $3\n")
    f.write("#define a0   $4\n")
    f.write("#define a1   $5\n")
    f.write("#define a2   $6\n")
    f.write("#define a3   $7\n")
    f.write("#define s0   $16\n")
    f.write("#define s1   $17\n")
    f.write("#define s2   $18\n")
    f.write("#define s3   $19\n")
    f.write("#define s4   $20\n")
    f.write("#define s5   $21\n")
    f.write("#define s6   $22\n")
    f.write("#define s7   $23\n")
    f.write("#define t8   $24\n")
    f.write("#define t9   $25\n")
    f.write("#define jp   $25\n")
    f.write("#define k0   $26\n")
    f.write("#define k1   $27\n")
    f.write("#define gp   $28\n")
    f.write("#define sp   $29\n")
    f.write("#define fp   $30\n")
    f.write("#define s8   $30\n")
    f.write("#define ra   $31\n")

    f.write(".global main\n")
    f.write(".text\n")
    f.write("main:\n")

    for line in mips.contents:
        f.write(line)

# Create ppc
with open("ppc.asm", "w") as f:
    f.write(".global main\n")
    f.write(".text\n")
    f.write("main:\n")

    for line in ppc.contents:
        f.write(line)
