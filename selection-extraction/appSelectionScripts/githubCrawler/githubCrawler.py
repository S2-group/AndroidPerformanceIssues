import httplib2
import lxml
from lxml import etree
from lxml import html
import cssselect
import csv
import time
import math
import random

# the ranges of dates to search
dates = ['\"2016-01-25+..+2016-02-12\"', '\"2015-08-01+..+2016-01-24\"'] #, '\"2015-02-01+..+2015-07-31\"', '\"2014-07-01+..+2015-01-31\"', '\"2013-10-01+..+2014-06-30\"', '\"2012-01-01+..+2013-09-30\"', '\"2001-01-01+..+2011-12-31\"']

# the number of search results on GitHub (all these numbers must be below 1000)
# remember to change this to the actual number of results of the real search on the github.com website
# TEST LINK BELOW:
# https://github.com/search?utf8=%E2%9C%93&q=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3D+in%3Areadme+created%3A%222015-08-01..2016-02-01%22&type=Repositories&ref=searchresults
dates_num_results = [339, 981] #, 967, 977, 989, 987, 86]
# the index of the page from which we want to start the search
dates_start_index = [1, 1]#, 1, 1, 1, 1, 1]

# DO NOT CHANGE ANYTHING BELOW THIS LINE

url_fragment_1 = 'https://github.com/search?p='
url_fragment_2 = '&q=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3D+in%3Areadme+created%3A'
url_fragment_3 = '&ref=searchresults&type=Repositories&utf8=%E2%9C%93'

for dates_index, current_date in enumerate(dates):
    print('Fetching for dates: ' + current_date)
    filePath = 'repos' + str(dates_index) + '.csv'

    page_index = dates_start_index[dates_index]
    to_page_index = math.ceil(dates_num_results[dates_index] / 10.0)

    rows = []
    append = True

    if(append):
        f = open(filePath, 'a')
    else:
        f = open(filePath, 'w')
        rows = [['Repository']]

    writer = csv.writer(f)

    while(page_index <= to_page_index):
        waitingTime = random.randrange(1, 10)
        url = url_fragment_1 + str(page_index) + url_fragment_2 + current_date + url_fragment_3
        response, payload = httplib2.Http().request(url)
        rootHtml = lxml.html.fromstring(payload)
        elements = rootHtml.cssselect('.repo-list-name a')
        rows = []
        if len(elements) != 0:
            for elem in elements:
                rows.append([elem.text])
            writer.writerows(rows)
            print('Fetched GitHub page: ' + str(page_index))
            page_index = page_index + 1
        else:
            print("Error while fetching page: " + str(page_index))
        print("Sleeping for " + str(waitingTime) + " seconds")
        time.sleep(waitingTime)
    print('Finished to fetch for dates: ' + current_date)
print('Finished fetching.')
