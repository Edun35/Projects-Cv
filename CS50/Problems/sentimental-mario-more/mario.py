from cs50 import get_int
# height
N = 0
while N < 1 or N > 8:
    N = get_int("Height: ")

# rows
for i in range(1, N + 1, 1):
    # spaces
    for j in range(N, i, -1):
        print(" ", end="")
    # left    
    for q in range(0, i, 1):
        print("#", end="")
    # mid
    for w in range(1):
        print("  ", end="")
    # right
    for e in range(i):
        print("#", end="")
    print("")    