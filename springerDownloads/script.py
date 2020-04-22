#!/usr/bin/python3
import urllib.request
import os
import multiprocessing

def downloadFile (url):
    filenameStart = url.rfind("/")
    filename = url[filenameStart:]
    print("Downloading: [" + isbn + "] => " + url)
    try:
        urllib.request.urlretrieve(url, f"papers/{filename}")
    except Exception as error:
        print(f"error downloading isbn [{filename}], URL: {url}")
        print(error)
    return filename


if not os.path.exists("papers"):
    os.mkdir("papers")

urls = list()

with open("doiURL.txt") as txtFile:
    for line in txtFile:
        line = line.strip()
        if line:
            isbn = line.split('/')[-1:][0]
            line = line.replace("http://doi.org/", \
                    "https://link.springer.com/content/pdf/")
            url = line + ".pdf"
            urls.append(url)

print(urls)

results = multiprocessing.Pool(multiprocessing.cpu_count()).imap_unordered(downloadFile, urls)
for filename in results:
    print(f"Finished download of {filename}")
