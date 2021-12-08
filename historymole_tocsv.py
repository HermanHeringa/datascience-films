import csv

with open("C:/Users/noliv/Desktop/prog/fulldb.txt", "r") as dbtxt:
    lines = dbtxt.readlines()
    array_form = []
    array_form.append(["date", "event"])
    for year in range(1900, 2007):
        stryear = str(year)
        for line in lines:
            line = line.replace(u'\xa0', ' ')
            if stryear in line[:12]:
                split = line.split(stryear)
                array_form.append([split[0]+stryear, split[1][:-1][1:]])
    dbtxt.close()

for i in array_form:
    print(i)
with open("C:/Users/noliv/Desktop/prog/sortedDb.csv", "w", encoding='UTF8', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter='|')
    for i in array_form:
        writer.writerow(i)
    csvfile.close()
