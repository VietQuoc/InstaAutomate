*** Settings ***
Resource    ../Common/WebKeyword.robot
Suite Teardown    Close Browser

*** Test Cases ***
Accounts By Hagtag Plan
    Set Global Variable    ${LAST_RANDOM_NUM}                 ${0}
    Set Global Variable    ${TOTAL_NUMBER_LIKE_FAILURE}       ${0}
    Set Global Variable    ${TOTAL_NUMBER_COMMENT_FAILURE}    ${0}
    Set Global Variable    ${TOTAL_NUMBER_FOLLOW_FAILURE}     ${0}
    Set Global Variable    ${TOTAL_LIKE}    ${0}
    Set Global Variable    ${TOTAL_FOLLOW}    ${0}
    Set Global Variable    ${TOTAL_COMMENT}    ${0}
    
    ${LIKE_LIMIT}=    Evaluate    ${LIKE_LIMIT}*1
    ${FOLLOW_LIMIT}=    Evaluate    ${FOLLOW_LIMIT}*1
    ${COMMENT_LIMIT}=    Evaluate    ${COMMENT_LIMIT}*1
    Set Global Variable    ${LIKE_LIMIT}    ${LIKE_LIMIT}
    Set Global Variable    ${FOLLOW_LIMIT}    ${FOLLOW_LIMIT}
    Set Global Variable    ${COMMENT_LIMIT}    ${COMMENT_LIMIT}

    ${LIST_FOLLOW}    Create List
    Set Global Variable    ${LIST_FOLLOW}     ${LIST_FOLLOW}
    Read Excel File For Hagtag
    Login
    Repeat Like Follow Comment For Hagtag
    Log    ${TOTAL_NUMBER_LIKE_FAILURE}
    Log    ${TOTAL_NUMBER_COMMENT_FAILURE}
    Log    ${TOTAL_NUMBER_FOLLOW_FAILURE}
    Log    ${LIST_FOLLOW}
