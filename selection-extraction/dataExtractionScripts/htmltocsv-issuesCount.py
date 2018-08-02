import urllib2
from bs4 import BeautifulSoup
import httplib2
import cssselect
import csv
import time
import math
import random
import re

# input csv file with repo name of targeted apps.
input_file_path = './input.csv'
# the path to the file to be created containing the list of apps and projects
filePath = './outputPCount.csv'

# DO NOT CHANGE ANYTHING BELOW THIS LINE

rows = []
rows2 = []

index = 0
f = open(filePath, 'w')
rows.append(['UniqueCommitId', 'RepoName', 'RepoId', 'GitHubCommitId', 'StartTimeStamp', 'Cateogary', 'DrawAllocation', 'Wakelock',
             'Recycle', 'ObsoleteLayoutParam', 'ObsoleteSdkInt',
             'UseCompoundDrawables', 'ViewTag', 'WearableBindListener',
             'LogConditional', 'ViewHolder', 'AnimatorKeep', 'DuplicateDivider',
             'FieldGetter', 'HandlerLeak', 'MergeRootFrame', 'UseOfBundledGooglePlayServices',
             'UseSparseArrays', 'UseValueOf', 'DisableBaselineAlignment', 'FloatMath', 'InefficientWeight',
             'NestedWeights', 'Overdraw', 'UnusedResources', 'UselessLeaf', 'UselessParent', 'TooDeepLayout',
             'TooManyViews', 'UnusedIds', 'UnusedNamespace'])

writer = csv.writer(f)
x = 0
w = 0
current_repo = ''
commit_id = ''

def issuess(Name):
    x = 0
    perf=tab.find('a', attrs={'href': Name})   
    if perf:
        tf = perf.parent.parent
        td = tf.findNext('td')
        return td.text
    else:
        return x

    

with open(input_file_path,'r') as input_file:
    for line in input_file:
        if(index != 0):
            try:
                unqeid = line.rstrip().split(",")[0]
                current_repo = line.rstrip().split(",")[1]
                repid = line.rstrip().split(",")[2]
                commit_id = line.rstrip().split(",")[3]
                print commit_id
                print current_repo
                timestamp = line.rstrip().split(",")[4]
                category = line.rstrip().split(",")[5]
                url = './result/' +current_repo +'/' +commit_id +'.html'
                print url
                response = urllib2.urlopen(url)
                page=response.read()
                soup=BeautifulSoup(page, 'html.parser')
                tab = soup.find('table', {'class': 'overview'})
                if tab:
                    s = ['#DrawAllocation','#Wakelock','#Recycle','#ObsoleteLayoutParam','#ObsoleteSdkInt','#UseCompoundDrawables','#ViewTag','#WearableBindListener','#LogConditional','#ViewHolder','#AnimatorKeep','#DuplicateDivider','#FieldGetter','#HandlerLeak','#MergeRootFrame','#UseOfBundledGooglePlayServices','#UseSparseArrays','#UseValueOf','#DisableBaselineAlignment','#FloatMath','#InefficientWeight','#NestedWeights','#Overdraw','#UnusedResources','#UselessLeaf','#UselessParent','#TooDeepLayout','#TooManyViews','#UnusedIds','#UnusedNamespace']
                #s = ['DrawAllocation','Wakelock','Recycle','ObsoleteLayoutParam','ObsoleteSdkInt','UseCompoundDrawables','ViewTag','WearableBindListener','LogConditional','ViewHolder','AnimatorKeep','DuplicateDivider','FieldGetter','HandlerLeak','MergeRootFrame','UseOfBundledGooglePlayServices','UseSparseArrays','UseValueOf','DisableBaselineAlignment','FloatMath','InefficientWeight','NestedWeights','Overdraw','UnusedResources','UselessLeaf','UselessParent','TooDeepLayout','TooManyViews','UnusedIds','UnusedNamespace']
                    b = [unqeid, current_repo, repid, commit_id, timestamp, category]
                    for issue in s:
                    #issue1= '#' + issue
                   # print issuess(issue)
                        b.append(issuess(issue))
                        print 'run'
                    rows.append(b)
                else:
                    rows.append([unqeid, current_repo, repid, commit_id, timestamp, category, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w, w]) 
                    #genre=genre.encode('utf-8').strip()
                #print(str(index) + " - " + url + " - " + genre)
            except:
                rows.append([unqeid, current_repo, repid, commit_id, timestamp, category, "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na", "na"])
        index = index + 1                

    writer.writerows(rows)

print('Finished fetching.')
