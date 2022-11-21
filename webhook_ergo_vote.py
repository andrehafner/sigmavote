import requests #dependency
import sys

arr = sys.argv[1]
print(arr)

arr2 = sys.argv[2]

arr3 = sys.argv[3]

#users = arr.split(',')

#print(users)



url = "webhookurlhere" #webhook url, from here: https://i.imgur.com/f9XnAew.png
#for all params, see https://discordapp.com/developers/docs/resources/webhook#execute-webhook
data = {
    "content" : (arr),
    "username" : "sigmavote"
}

#leave this out if you dont want an embed
#for all params, see https://discordapp.com/developers/docs/resources/channel#embed-object
data["embeds"] = [
    {
        "description" : (arr2),
        "title" : (arr3)
    }
]

result = requests.post(url, json = data)

try:
    result.raise_for_status()
except requests.exceptions.HTTPError as err:
    print(err)
else:
    print("Payload delivered successfully, code {}.".format(result.status_code))

#result: https://i.imgur.com/DRqXQzA.png
