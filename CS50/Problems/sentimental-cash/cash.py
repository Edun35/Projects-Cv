# import get float
from cs50 import get_float

# get change
money = 0
while money <= 0:
    money = get_float("Change owed: ")
    
# round change
m = money*100

# coin counter
c = 0

# loop to give change
while m > 0:
    if m >= 25:
        m -= 25
        c += 1
    elif m >= 10:
        m -= 10
        c += 1
    elif m >= 5:
        m -= 5
        c += 1
    else:
        m -= 1
        c += 1
       
# display num coins used       
print(c)