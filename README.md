# kbot
devops app from scratch


### Link on the bot:

https://t.me/oleksiihead_bot

### How to use bot
Clone this repo and follow the next steps

1. Create telegram bot with BotFather and receive token
2. Export TELE_TOKEN with token from previous step
``` 
read -s TELE_TOKEN
export TELE_TOKEN
```
3. Build app
``` 
go build -ldflags "-X="github.com/oleksiihead/kbot/cmd.appVersion=v1.0.0 
```
4. Run app
``` 
./kbot start
```
5. Options you can use in the telegram
``` 
/start hello
/start menu
```

### Makefile

If we want to build app for OS Linux and arm64 architecture we can use one of the following methods

### 1 method

- Change TARGETOS and TARGETARCH, save changes and run command:
```
make build_linux
```

### 2 method 
- Run command
```
make build TARGETOS=linux TARGETARCH=arm64
```
