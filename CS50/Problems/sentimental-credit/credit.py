# import functions
from cs50 import get_int

# card num
card = get_int("Card Number: ")

# vars
d = 0
count = 0
sum1 = 0
sum2 = 0
chsm = 0
switch = True
d13 = 0
d14 = 0
d15 = 0
d16 = 0

# checksum
while card > 0:
    if card >= 10:
        d = int(card % 10)
        card = int(card / 10)
        count += 1
    else:
        d = int(card)
        card = int(card / 10)
        count += 1
    
    # 1st 2nd switch    
    if switch == True:
        sum1 = sum1 + d
        switch = False
    elif switch == False:
        d1 = d * 2
        if d1 >= 10:
            d2 = int(d1 % 10)
            d1 = int(d1 / 10)
            sum2 = sum2 + d1 + d2
        else:
            sum2 = sum2 + d1
        switch = True
    
    # digits for card type
    if count == 13:
        d13 = d
    if count == 14:
        d14 = d
    if count == 15:
        d15 = d
    if count == 16:
        d16 = d

# checksum result
chsm = sum1 + sum2
chsm = chsm % 10

# display cardtype
if chsm == 0 and count >= 13:
    if count == 16:
        # master check
        if d16 == 5 and d15 <= 5:
            print("MASTERCARD")
        # visa check
        elif d16 == 4:
            print("VISA")
        else:
            print("INVALID")
    # AMEX check
    elif count == 15:
        if d15 == 3:
            if d14 == 4 or d14 == 7:
                print("AMEX")
            else: 
                print("INVALID")
    # visa check
    elif count == 13:
        if d13 == 4:
            print("VISA")
        else:
            print("INVALID")
    else:
        print("INVALID")
else:
    print("INVALID")