#!/bin/bash

###############################################################################################
#Varaiblies to be set with Jamf Pro, Script Parameters. They can also be hard coded if desired#
###############################################################################################

#Varaiblies to be set relating to the information required for an API connection
apiUser="$4"
apiPass="$5"
jamfProURL="$6"

##############################################################
#Actions performed by the script, do not edit below this line# 
##############################################################


#Obtain Serial Number 
serialnumber=$(system_profiler SPHardwareDataType | awk '/Serial Number/{print $4}')

#Get JAMF ID 
jamfID=$(curl -sku ${apiUser}:${apiPass} -H "accept: text/xml" "${jamfProURL}/JSSResource/computers/serialnumber/$serialnumber" | xmllint --xpath '/computer/general/id/text()' -)


#Prompt User if they would like to procced
returnCode=$("/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType hud -title "Erase Content and Settings" -description "You are about to erase all contents and settings of this device, this action is permanent and there will be data loss. If you do not wish to proceed select cancel now.  " -button1 "OK" -button2 "Cancel") 
	
	if [[ $returnCode == 0 ]]; then 
		curl -u "$apiUser":"$apiPass" \
		${jamfProURL}/JSSResource/computercommands/comand/EraseDevice/passcode/123456/id/$jamfID \
		--request POST \ 
	fi
