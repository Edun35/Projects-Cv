from cs50 import get_string

# get text
text = get_string("Text: ")

# vars
let = 0
word = 1
sent = 0

# loop through text

for char in text:
    if str.isalpha(char):
        let += 1
    if char == ' ':
        word += 1
    if char == '.' or char == '?' or char == '!':
        sent += 1

# index
l = let / word * 100
s = sent / word * 100
index = 0.0588 * l - 0.296 * s - 15.8

# display grade
if index < 1.0:
    print("Before Grade 1")
elif index >= 16.0:
    print("Grade 16+")
else:
    index = round(index)
    print(f"Grade {index}")