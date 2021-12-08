import string

newlines = []
for year in range(1900, 2007):
    filename = "%userprofile%/Desktop/prog/database/db" + str(year) + ".txt"
    timelineFound = 0
    with open(filename, "r") as file:
        lines = file.readlines()
        for line in lines[1:]:
            if timelineFound == 1:
                if line[0] not in string.digits:
                    if line[:3] not in ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]:
                        timelineFound = 0
                        break
                if line.endswith(".More:\n"):
                    line = line[:-7] + "\n"
                elif line.endswith("More:\n"):
                    line = line[:-6] + "\n"
                elif line.endswith(".More\n"):
                    line = line[:-6] + "\n"
                elif line.endswith("More\n"):
                    line = line[:-5] + "\n"
                line = line.replace(" CE", "")
                newlines.append(line)
            if "Timeline" in line:
                timelineFound = 1
        file.close()

with open("%userprofile%/Desktop/prog/fulldb.txt", "w") as savefile:
    for line in newlines:
        savefile.write(line)
    savefile.close()
