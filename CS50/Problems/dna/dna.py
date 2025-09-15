# import
import sys
import csv

# check command valid
if len(sys.argv) != 3:
    print("ERROR")
    print("Usage: python dna.py data.csv sequence.txt")
    sys.exit(1)

# open database.csv
with open(sys.argv[1], newline='') as csvfile:
    # store in memory
    reader = csv.DictReader(csvfile)
    # lis of each dict
    db = list(reader)

# open sequences.txt
with open(sys.argv[2], "r") as file:
    # store in memory
    seq = file.read()

# list to store str count
STR_count = []

# loop database for each str
for i in range(1, len(reader.fieldnames)):
    STR = reader.fieldnames[i]
    STR_count.append(0)
    # loop sequence to find STR
    for j in range(len(seq)):
        count = 0
        # if found start count
        if seq[j: j + len(STR)] == STR:
            # var for jumping length STR
            a = 0
            # loop consequtive str
            while seq[(j + a):(j + a + len(STR))] == STR:
                a += len(STR)
                count += 1
            # check + update longest count
            if count > STR_count[i - 1]:
                STR_count[i - 1] = count

# compare to database
for i in range(len(db)):
    match_count = 0
    for j in range(1, len(reader.fieldnames)):
        # add to counter
        if int(STR_count[j - 1]) == int(db[i][reader.fieldnames[j]]):
            match_count += 1
        # display name if match
        if match_count == (len(reader.fieldnames) - 1):
            print(db[i]['name'])
            sys.exit(0)
# else display no match
print("No Match")
