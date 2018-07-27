import httplib2
import lxml
from lxml import etree
from lxml import html
import cssselect
import csv
import time
import math
import random
import re

input_file_path = './with_google_play_page_14_02_2016.csv'

# the path to the file to be created containing the list of apps and projects
filePath = 'with_number_commits_' + '16_02_2016' +'.csv'

# DO NOT CHANGE ANYTHING BELOW THIS LINE

rows = []

f = open(filePath, 'w')
rows.append(['Repository', 'App', 'Source', 'Commits'])

writer = csv.writer(f)

current_repo = ''
current_googleplay = ''

index = 0

with open(input_file_path,'r') as input_file:
    for line in input_file:
        if(index != 0):
            try:
                current_repo = line.rstrip().split(",")[0]
                current_googleplay = line.rstrip().split(",")[1]
                current_source = line.rstrip().split(",")[2]
                url = 'http://www.github.com/' + current_repo

                response, payload = httplib2.Http().request(url)

                num_commits = re.findall('<spanclass="numtext-emphasized">[\d,]+</span>commit', payload.replace("\n", "").replace(" ", "").replace("\t", ""))[0].replace('<spanclass="numtext-emphasized">', "").replace('</span>commit', "").replace(",", "")#[0].rstrip()
                print(str(index) + " - " + url + " - " + num_commits)
                rows.append([current_repo, current_googleplay, current_source, num_commits])
            except:
                print(str(index) + " - ERROR for: " + url)
                rows.append([current_repo, current_googleplay, current_source, "na"])
        index = index + 1

    writer.writerows(rows)

print('Finished fetching.')
