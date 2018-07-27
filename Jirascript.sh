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

        *)
            break
            ;;
    esac
done

echo "Checking RCV Dashboard for existing tickets"
STR=$sum
STR=`echo ${STR// /%20}`
empty="\"\""
contentType='"Content-Type:application/json"'
curl -u $cred -X GET -H "Content-Type:application/json" "http://localhost:8081/rest/agile/1.0/board/1/issue?fields=summary&jql=project+%3D+$key+AND+status+!%3D+Closed+AND+status+!%3D+REJECTED+AND+summary~%22$STR%22+ORDER+BY+key+DESC" > "/tmp/inputCICD.json"
findSummary=`jq .issues[0].fields.summary '/tmp/inputCICD.json'`
if [ "$findSummary" != "null"  ]
        then
                        findTicket=`jq .issues[0].key '/tmp/inputCICD.json'`
                        jiranumber=`echo $findTicket | cut -d "\"" -f2`
                        echo "Adding comment to $jiranumber"
                        commentData="'"{"\"update\"":{"\"comment\"":[{"\"add\"":{"\"body\"":"\"$sum\""}}]}}"'"
                        url="http://localhost:8081/rest/api/2/issue/$jiranumber"
                        var=`echo curl -D- -u $cred -X PUT --data "$commentData" -H "$contentType" "$url"`
                        eval $var
else
                echo "Creating ticket under RCV Board"
                url="http://localhost:8081/rest/api/2/issue/"
                summaryData="'"{"\"fields\"":{"\"project\"":{"\"key\"":"\"$key\""},"\"summary\"":"\"$summary\"","\"description\"":"\"$description\"","\"customfield_10112\"":{"\"value\"":"\"$outageRequired\""},"\"customfield_10113\"":"\"$outageDetails\"","\"customfield_10114\"":"\"$startPlan\"","\"customfield_10107\"":"\"$startWindow\"","\"customfield_10108\"":"\"$endWindow\"","\"customfield_10109\"":"\"$outageStart\"","\"customfield_10110\"":"\"$outageEnd\"","\"customfield_10116\"":"\"$contactDetails\"","\"customfield_10111\"":"\"$impact\"","\"customfield_10115\"":{"\"value\"":"\"$changeType\""},"\"issuetype\"":{"\"name\"":"\"Change\""}}}"'"
                result=`eval curl -D- -u $cred -X POST --data "$summaryData" -H "$contentType" "$url"`
                echo $result
                jiranumber=`echo $result | awk -F '"' '{print $8}'`
                echo $jiranumber
fi
if [ -z $attachment ] || [ $attachment = $empty ]
        then
                echo "No Attachments."
else
        curl -D- -u $cred -X POST -H "X-Atlassian-Token: no-check" -F "file=@$attachment" --url http://localhost:8081/rest/api/2/issue/$jiranumber/attachments
fi

if [ -z $jiraLink ] || [ $jiraLink = $empty ]
        then
                echo "No JIRA to Attachments."
else
        linkSTR=$jira
        linkSTR=`echo ${linkSTR// /%20}`
        curl -u $cred -X GET -H "Content-Type:application/json" "http://localhost:8081/rest/api/2/search?jql=cf[10009]=$linkSTR" > "/tmp/input_cicd2.json"
        totaljira=`jq .total '/tmp/input_cicd2.json'`
        if [ $totaljira!='0' ]
                then
                        i=0
                        while [ $i -lt $totaljira ]
                                do
                                        linkfindTicket=`jq .issues[$i].key '/tmp/input_cicd2.json'`
                                        linkjiranumber=`echo $linkfindTicket | cut -d "\"" -f2`
                                        linkurl="http://localhost:8081/rest/api/2/issueLink"
                                        linksummaryData="'"{"\"inwardIssue\"":{"\"key\"":"\"$jiranumber\""},"\"outwardIssue\"":{"\"key\"":"\"$linkjiranumber\""},"\"type\"":{"\"id\"":"\"10003\"","\"name\"":"\"Relates\"","\"inward\"":"\"relates to\"","\"outward\"":"\"relates to\""}}"'"
                                        eval curl -D- -u $cred -X POST --data "$linksummaryData" -H "$contentType" "$linkurl"
                                        i=$((i+1))
                        done
        fi
fi
