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

input_file_path = './github_11_02_2016.csv'

# the path to the file to be created containing the list of apps and projects
filePath = 'output_' + '12_02_2016' +'.csv'

# DO NOT CHANGE ANYTHING BELOW THIS LINE

rows = []

f = open(filePath, 'w')
rows.append(['Repository', 'App'])

writer = csv.writer(f)

current_repo = ''
current_googleplay = ''

index = 0

with open(input_file_path,'r') as input_file:
    for line in input_file:
        if(index != 0):
            try:
                current_repo = line.rstrip()
                url = 'http://www.github.com/' + current_repo

                response, payload = httplib2.Http().request(url)
                current_googleplay = re.findall("http[s]?://play.google.com/store/apps/details\?id=[\w\.^&^#]+", payload.decode('utf-8'))[0].rstrip().split('=')[1]

                print(str(index) + " - " + url)

                rows.append([current_repo, current_googleplay])
            except:
                print(str(index) + " - ERROR for: " + url)
        index = index + 1

    writer.writerows(rows)

print('Finished fetching.')
