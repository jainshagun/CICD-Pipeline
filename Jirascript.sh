#!/bin/bash

ARGUMENT_LIST=(
        "key"
        "summary"
        "description"
        "outageRequired"
        "outageDetails"
        "startPlan"
        "startWindow"
        "endWindow"
        "contactDelatils"
        "impact"
        "changeType"
        "attachment"
        "jiraLink"
        "outageStart"
        "outageEnd"
        "cred"
        "rcvnumber"
)


# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --$opts

while [[ $# -gt 0 ]]; do
    case "$1" in
        --key)
            key=$2
            shift 2
            ;;

        --summary)
            summary=$2
            shift 2
            ;;

        --description)
            description=$2
            shift 2
            ;;

        --outageRequired)
            outageRequired=$2
            shift 2
            ;;

        --outageDetails)
            outageDetails=$2
            shift 2
            ;;

        --startPlan)
            startPlan=$2
            shift 2
            ;;

        --startWindow)
            startWindow=$2
            shift 2
            ;;

        --endWindow)
            endWindow=$2
            shift 2
            ;;

        --contactDelatils)
            contactDelatils=$2
            shift 2
            ;;

        --impact)
            impact=$2
            shift 2
            ;;

        --changeType)
            changeType=$2
            shift 2
            ;;

        --attachment)
            attachment=$2
            shift 2
            ;;

        --jiraLink)
            jiraLink=$2
            shift 2
            ;;

        --outageStart)
            outageStart=$2
            shift 2
            ;;

        --outageEnd)
            outageEnd=$2
            shift 2
            ;;

        --cred)
            cred=$2
            shift 2
            ;;
            
        --rcvnumber)
            rcvnumber=$2
            shift 2
            ;;

        *)
            break
            ;;
    esac
done

empty="\"\""
contentType='"Content-Type:application/json"'
if [ -z $rcvnumber ] || [ $$rcvnumber = $empty ]
  then
    echo "No link."    
else
                        echo "Adding comment to $rcvnumber"
                        commentData="'"{"\"update\"":{"\"comment\"":[{"\"add\"":{"\"body\"":"\"PROD deployment done.\""}}]}, "\"transition\"":{"\"id\"": "\"91\""}}"'"
                        url="http://localhost:8081/rest/api/2/issue/$rcvnumber/transitions"
                        var=`echo curl -D- -u $cred -X PUT --data "$commentData" -H "$contentType" "$url"`
                        eval $var
fi
