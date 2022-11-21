import discord
import sys

arr = sys.argv[1]
print(arr)

arr2 = sys.argv[2]

users = arr.split(',')

print(users)


client = discord.Client(intents=discord.Intents.default())


@client.event
async def on_ready():
    for x in range(len(users)):
        users[x] = await client.fetch_user(users[x])
        await users[x].send(arr2)
    raise SystemExit('end of data')



client.run("discordkeyhere")
