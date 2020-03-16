*** Settings ***
Resource    ../Common/WebKeyword.robot
Suite Teardown    Close Browser

*** Test Cases ***
Accounts By Hagtag Plan
    ${LIST_FOLLOWER}    Create List    Followed
    Set Global Variable    ${LIST_FOLLOWER}
    ${LIST_TIME_FOLLOWER}    Create List    LIST_TIME_FOLLOWER
    Set Global Variable    ${LIST_TIME_FOLLOWER}
    ${LIST_COMMENTER}    Create List    Commented
    Set Global Variable    ${LIST_COMMENTER}
    ${LIST_LIKER}    Create List    Liked
    Set Global Variable    ${LIST_LIKER}

    ${FOLOWED_TOTAL_RUN}    Create List    Followed Total Run    ${FOLLOW_LIMIT}
    Set Global Variable    ${FOLOWED_TOTAL_RUN}
    ${COMMENTED_TOTAL_RUN}    Create List    Commented Total Run    ${COMMENT_LIMIT}
    Set Global Variable    ${COMMENTED_TOTAL_RUN}
    ${LIKED_TOTAL_RUN}    Create List    Like Total Run    ${LIKE_LIMIT}
    Set Global Variable    ${LIKED_TOTAL_RUN}

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

    Read Excel File For Hagtag
    Login
    Repeat Like Follow Comment For Hagtag

    Write Data Report To Excel File
