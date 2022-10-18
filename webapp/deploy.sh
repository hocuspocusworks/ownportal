#!/bin/bash

cp ./src/.server.prod.js ./src/.server.js
yarn build
zip -r dist.zip dist
scp dist.zip ownportal:/home/ownportal/.
ssh ownportal "rm -fr /home/ownportal/dist"
ssh ownportal "unzip /home/ownportal/dist.zip -d /home/ownportal"
ssh ownportal "rm /home/ownportal/dist.zip"

rm dist.zip
cp ./src/.server.dev.js ./src/.server.js
