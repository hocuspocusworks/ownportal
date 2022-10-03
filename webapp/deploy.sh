#!/bin/bash

yarn build
zip -r dist.zip dist
scp dist.zip rack:/html/ownportal/.
ssh rack "rm -fr /html/ownportal/dist"
ssh rack "unzip /html/ownportal/dist.zip -d /html/ownportal"
ssh rack "rm /html/ownportal/dist.zip"

rm dist.zip
