import requests
from bs4 import BeautifulSoup


# 10 years per ip address because of website limits
for year in range(1900, 1910):
    url = "http://www.historymole.com/cgi-bin/main/results.pl?type=advanced&search=&yearfr="+str(year)+"&yearto="+str(year)+"&geography=World&theme=All&I3.x=38&I3.y=10"
    html = requests.get(url)
    soup = BeautifulSoup(html.text, features="html.parser")
    # kill all script and style elements
    for script in soup(["script", "style"]):
        script.extract()  # rip it out

    # get text
    text = soup.get_text()
    # break into lines and remove leading and trailing space on each
    lines = (line.strip() for line in text.splitlines())
    # break multi-headlines into a line each
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    # drop blank lines
    text = '\n'.join(chunk for chunk in chunks if chunk)
    # saves files to desktop folder
    filename = "%userprofile%/Desktop/database/db"+str(year)+".txt"
    with open(filename, "w") as output_file:
        output_file.write(text)
        output_file.close()
