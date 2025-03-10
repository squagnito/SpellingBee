import requests
import re
import json
import os, sys
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials, firestore
os.chdir(sys.path[0])

def getLetters():
    url = "https://www.nytimes.com/puzzles/spelling-bee"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")

    element = element = soup.find('div', class_='pz-game-screen')
    element = element.find('script')
    data = element.contents[0].replace('window.gameData = ','')
    data = json.loads(data)
    #print(json.dumps(data, indent = 4))
    dt = data.get('today').get('printDate')

    with open('jsonData' + os.sep + dt + '.json','w') as fp:
        json.dump(data,fp, indent = 4)

    #print(dt)

if __name__ == "__main__":
    getLetters()