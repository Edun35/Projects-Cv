from cs50 import get_int
# height
N = 0
while N < 1 or N > 8:
    N = get_int("Height: ")

# rows
for i in range(N):
    # columns
    for j in range(N, i + 1, -1):
        print(" ", end="")
    # bricks    
    for q in range(-1, i, 1):
        print("#", end="")
    print("")    