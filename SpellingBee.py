import requests
import re
import json
import os, sys
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials, firestore
os.chdir(sys.path[0])

def initialize_firestore():
    cred_path = "/Users/aaronmedina/Developer/SpellingBee/spellingbee-6a615-firebase-adminsdk-fbsvc-937864aead.json"
    cred = credentials.Certificate(cred_path)
    firebase_admin.initialize_app(cred)
    return firestore.client()

def get_letters(db):
    url = "https://www.nytimes.com/puzzles/spelling-bee"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")

    element = element = soup.find('div', class_='pz-game-screen')
    element = element.find('script')
    data = element.contents[0].replace('window.gameData = ','')
    data = json.loads(data)
    #print(json.dumps(data, indent = 4))

    today_data = data.get('today')
    if not today_data:
        print("No data found for today.")
        return

    dt = today_data.get('printDate')

    with open('jsonData' + os.sep + dt + '.json','w') as fp:
        json.dump(today_data,fp, indent = 4)

    doc_ref = db.collection('words_lists').document(dt)
    doc_ref.set(today_data)
    print(f"Data for {dt} uploaded to Firestore.")

if __name__ == "__main__":
    db = initialize_firestore()

    get_letters(db)