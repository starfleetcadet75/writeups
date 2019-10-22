from scapy.all import *

pkts = rdpcap("./challenge.pcap")

# The seed determined from running the client program
key = bytearray(b'\x67\xc6\x69\x73\x51\xff\x4a\xec\x29')
index = 0
flag = ''

for pkt in pkts:
    # Only care about UDP packets
    if (pkt.haslayer(UDP)):
        chars = bytes(pkt[UDP].payload)[-4:]

        # Check if this payload has part of the flag
        if chars != '\x00\x00\x00\x00':
            for c in chars:
                flag += chr(ord(c) ^ key[index])

            index = index + 1

print(flag)
