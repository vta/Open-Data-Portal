# library for working with xml data
from bs4 import BeautifulSoup
# library to read content from the api url
import urllib
from urllib import request
# library to work with arguments
import sys
import argparse
# library to work with csv files
import csv
# library for working with CKAN
from ckanapi import RemoteCKAN

# Read the arguments passed - URL for the API and name of the csv file to which the data needs to be saved
parser = argparse.ArgumentParser()
parser.add_argument("dataurl", type=str, help="Enter the URL for API")
parser.add_argument("filename", type=str, help="Filename without extension")
parser.add_argument("apikey", type=str, help="API Key for CKAN")
parser.add_argument("packageid", type=str, help="Identifies the CKAN package to add resource to")
parser.add_argument("-ua", "--useragent", type=str, help="User Agent for CKAN")

args = parser.parse_args()

if args.useragent == None:
    ua = "City of San Jose"
else:
    ua = args.useragent

# Call the API URL and read the content
url = request.urlopen(args.dataurl)
content = url.read()

# Read the content from API to a BeautifulSoup object to work with XML
soup = BeautifulSoup(content, "html.parser")

# Get the tags that contain the data
data = soup("m:properties")

# Open csv file to read in the data
with open(args.filename + ".csv", "w") as csvFile:
    # Define csv writer to write to csv file
    csvWriter = csv.writer(csvFile, quoting = csv.QUOTE_ALL, lineterminator='\n')
    headerrow = list()
    # Read the tag names in to the header row and write it to csv file
    for tags in data[0]:
        headerrow.append(tags.name[2:])
    csvWriter.writerow(headerrow)
    datarow = list()

    # Read the data and write it to csv file
    for properties in data:
        for tags in properties:
            datarow.append(tags.text)
        csvWriter.writerow(datarow)
        datarow = list()

#upload the data to CKAN portal
demo = RemoteCKAN('http://data2.vta.org', user_agent=ua, apikey=args.apikey)
demo.action.resource_create(package_id=args.packageid, url='', upload=open(args.filename + ".csv", 'rb'))
