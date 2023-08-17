#!/usr/bin/env bash

JENKINS_URL='http://aczjenkins.eastus.cloudapp.azure.com:8080/'

JENKINS_CRUMB=$(curl -s --cookie-jar /tmp/cookies -u aczepiel:'G1i2z3z4m5o6h7()=' ${JENKINS_URL}/crumbIssuer/api/json | jq .crumb -r)

JENKINS_TOKEN=$(curl -s -X POST -H "Jenkins-Crumb:${JENKINS_CRUMB}" --cookie /tmp/cookies "${JENKINS_URL}/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken?newTokenName=demo-token66" -u aczepiel:'G1i2z3z4m5o6h7()=' | jq .data.tokenValue -r)

echo $JENKINS_URL
echo $JENKINS_CRUMB
echo $JENKINS_TOKEN

while read plugin; do
   echo "........Installing ${plugin} .."
   curl -s POST --data "<jenkins><install plugin='${plugin}' /></jenkins>" -H 'Content-Type: text/xml' "$JENKINS_URL/pluginManager/installNecessaryPlugins" --user "aczepiel:$JENKINS_TOKEN"
done < plugins.txt


#### we also need to do a restart for some plugins

#### check all plugins installed in jenkins
# 
# http://<jenkins-url>/script

# Jenkins.instance.pluginManager.plugins.each{
#   plugin -> 
#     println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}")
# }


#### Check for updates/errors - http://<jenkins-url>/updateCenter
