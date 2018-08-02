import urllib2
from bs4 import BeautifulSoup
import csv
import time
import math
import random
import re
import string

input_file_path = './input.csv'   

# the path to the file to be created containing the list of apps and projects
filePath = './detail.csv'

# DO NOT CHANGE ANYTHING BELOW THIS LINE

rows = []
rows2 = []

f = open(filePath, 'w')
rows.append(['UniqueCommitId', 'RepoName', 'RepoId', 'CommitId', 'StartTimeStamp', 'Cateogary', 'Line', 'Error'])

writer = csv.writer(f)
index = 0
current_repo = ''
commit_id = ''

def hasNumbers(inputString):
    return any(char.isdigit() for char in inputString)

def IssueMessage(nam):
    x = 0
    mess =nam.findNext('span', {'class': 'message'})  
    if mess:
        return mess.text
    else:
        return 'na'



def IssueError(nam):
    x = 0
    err =nam.findNext('pre', {'class': 'errorlines'})  
    if err:
        for be in err.findAll('span', {'class': 'errorspan'}):
            return be.text
        
    else:
        return 'na'
    

with open(input_file_path,'r') as input_file:
    for line in input_file:
        if(index != 0):
            try:
                unqeid = line.rstrip().split(",")[0]
                current_repo = line.rstrip().split(",")[1]
                repoid = line.rstrip().split(",")[2]
                commit_id = line.rstrip().split(",")[3]
                timestamp = line.rstrip().split(",")[4]
                catg = line.rstrip().split(",")[5]
                url = './result-2-6-17/' +current_repo +'/' +commit_id +'.html'
                print url
                response = urllib2.urlopen(url)
                page=response.read()
                soup=BeautifulSoup(page, 'html.parser')
                s = ['DrawAllocation','Wakelock','Recycle','ViewTag','ViewHolder','HandlerLeak','UseSparseArrays','UseValueOf','FloatMath']
                for issue in s:
                    new = issue + 'Div'
                    tab =soup.find('a', {'name': issue})
                    if tab:
                        td = tab.findNext('div', {'class': 'warningslist'})
                        if td:
                             for b in td.findAll('span', {'class': 'location'}):
                                 if b.parent('div') or b.parent('pre'):
                                     file_name = b.text.split(":")[0]
                                     if 'png' in file_name or 'jpg' in file_name:
                                         msg = IssueMessage (b)
                                         #commit_msg=commit_msg.encode('utf-8').strip()
                                         rows.append([unqeid, current_repo, repoid, commit_id, timestamp, catg, 'na', 'na'])
                                     else:
                                         line_no = b.text.split(":")[1]
                                         msg = IssueMessage (b)
                                         error = IssueError (b)
                                         print file_name
                                         print line_no
                                         #print msg
                                         print error
                                         #error=error.encode('utf-8').strip()
                                         #commit_msg=commit_msg.encode('utf-8').strip()
                                         rows.append([unqeid, current_repo, repoid, commit_id, timestamp, catg, line_no, error])
                        td2 = tab.findNext('div', {'id': new})
                        if td2:
                             for b in td2.findAll('span', {'class': 'location'}):
                                 if b.parent('div') or b.parent('pre'):
                                     file_name = b.text.split(":")[0]
                                     if 'png' in file_name or 'jpg' in file_name:
                                         msg = IssueMessage (b)
                                         #commit_msg=commit_msg.encode('utf-8').strip()
                                         rows.append([unqeid, current_repo, repoid, commit_id, timestamp, catg, issue, 'na', 'na'])
                                     else:
                                         line_no = b.text.split(":")[1]
                                         msg = IssueMessage (b)
                                         error = IssueError (b)
                                         print file_name
                                         print line_no
                                         #print msg
                                         print error
                                         #error=error.encode('utf-8').strip()
                                         #commit_msg=commit_msg.encode('utf-8').strip()
                                         rows.append([unqeid, current_repo, repoid, commit_id, timestamp, catg, line_no, error])                                                                            
            except:
                 rows.append([unqeid, current_repo, repoid, commit_id, 'na', 'na', 'na', 'na'])
        index = index + 1
                    #genre=genre.encode('utf-8').strip()
                #print(str(index) + " - " + url + " - " + genre)

    writer.writerows(rows)

print('Finished fetching.')
