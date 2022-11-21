import tweepy
import sys


arr = sys.argv[1]
print(arr)

arr2 = sys.argv[2]

users = arr.split(',')
print(users)


auth = tweepy.OAuthHandler("tokens", "tokens")

auth.set_access_token("tokens", "tokens")

api = tweepy.API(auth)


#user = api.get_user(screen_name="andrehafner")
for x in range(len(users)):
    recipient_id = users[x]
    api.send_direct_message(recipient_id, arr2)
