#!/usr/bin/env python3

###############################################################################
##                                                                           ##
##  @author Kiro47                                                           ##
##  @date 2019-04-20                                                         ##
##  @usage:                                                                  ##
##    Used to restore several thousand news articles from an old discord     ##
##    server to a new one for refernce and archival purposes.  Content       ##
##    was archived with DiscordChatExport and was unarchived directly from   ##
##    the archived html file.                                                ##
##  @externalTools                                                           ##
##    -DiscordChatExport:                                                    ##
##       https://github.com/Tyrrrz/DiscordChatExporter                       ##
##                                                                           ##
###############################################################################

from bs4 import BeautifulSoup
import urllib
import requests

import re
import json
import time

archiveFile="./news.html"
hook='https://discordapp.com/api/webhooks/??????????????????/????????????????????????????????????????????????????????????????????'


# removes duplicate urls
def ar(seq):
    seen = set()
    seen_add = seen.add
    return [x for x in seq if not (x in seen or seen_add(x))]


listing=list('')

# pulls URLs from html anchors
with open(archiveFile) as news:
    soup = BeautifulSoup(news, "lxml")
    for link in soup.findAll('a', attrs={'href': re.compile("^[http://|https://]")}):
        listing.append(link.get('href'))

listing=ar(listing)
target=list('')

# yes ther's better ways to do this, I didn't care too much in the 
# 10 minutes it took to write this
for link in listing:
    if not link.endswith("png")\
            and not link.endswith("jpg") \
            and not link.endswith("gif"):
                target.append(link)


for link in target:
    values = {
            'username': 'News Recovery',
            'content': link
            }
    header = {
            'Content-Type': 'application/json',
            }
    data = json.dumps(values)
    req = requests.post(hook, data=json.dumps(values), headers=header)
    print("{} for {}".format(req, link))
    time.sleep(5) # this exists because discord kept rate limiting me with 429s
