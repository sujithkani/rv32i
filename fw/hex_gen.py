with open("boot.bin", "rb") as f:
    d=f.read()
words=[]
#Binary to 32-bit words
for i in range(0,len(d),4):
    w=d[i:i+4]
    w+=b'\x00'*(4-len(w))  #Pad if less than 4 bytes
    words.append("{:02x}{:02x}{:02x}{:02x}".format(w[3], w[2], w[1], w[0]))
    
#Pad up to 1024 lines
while len(words)<1024:
    words.append("00000000")
#boot.hex
with open("boot.hex", "w") as f:
    f.write("\n".join(words))
    f.write("\n")
