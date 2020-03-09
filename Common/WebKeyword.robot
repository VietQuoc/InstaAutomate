*** Settings ***
Library    Selenium2Library
Library    String
Library    Collections
Library    ExcelLibrary
Library    ../Common/common.py
Resource    ../Interface/WebInterface.robot

*** Keywords ***
Login
    Open Browser    ${LOGIN_URL}    headlesschrome
    Wait Until Page Contains Element    ${USERNAME_TEXTBOX}
    Input Text    ${USERNAME_TEXTBOX}    ${USERNAME}
    Input Text    ${PASSWORD_TEXTBOX}    ${PASSWORD}
    CLick Element    ${LOGIN_SUBMIT_BUTTON}
    Wait Until Page Contains Element    ${SEARCH_TEXTBOX}    10

Search By Hagtag
    [Arguments]    ${tag}
    Input Text    ${SEARCH_TEXTBOX}    ${tag}
    ${search_result_locator}    Replace String    ${SEARCH_RESULT}    $$    ${tag}
    Wait Until Page Contains Element    ${search_result_locator}    20
    Click Element    ${search_result_locator}
    Wait Until Page Contains Element    ${MOST_RECENT_CATEGORY}
    Scroll Element Into View    ${MOST_RECENT_CATEGORY}
    Sleep    1
    Click Element    ${SELECT_ITEM_MOST_RECENT}
    Wait Until Element Is Visible    ${SELECTED_ITEM_DIALOG_SHOW}    10

Like
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${LIKE_BUTTON}   5
    Sleep    0.5
    Run Keyword If    ${status} and ${TOTAL_LIKE}<=${LIKE_LIMIT}    CLick Element    ${LIKE_BUTTON}
    ${temp}=    Evaluate    ${TOTAL_LIKE}+1
    Run Keyword If    ${status} and ${TOTAL_LIKE}<=${LIKE_LIMIT}    Set Global Variable    ${TOTAL_LIKE}    ${temp}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${UNLIKE_BUTTON}   3
    Capture Page Screenshot
    ${like_fail}=    Set Variable If    ${status}    0    1
    ${TOTAL_NUMBER_LIKE_FAILURE}=    Evaluate    ${TOTAL_NUMBER_LIKE_FAILURE}+${like_fail}
    Set Global Variable    ${TOTAL_NUMBER_LIKE_FAILURE}    ${TOTAL_NUMBER_LIKE_FAILURE}
    Sleep    ${LIKE_DELAY}
    Wait Until Page Contains Element    ${UNLIKE_BUTTON}   1

Follow
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${FOLLOW_BUTTON}   5
    Sleep    0.5
    Run Keyword If    ${status} and ${TOTAL_FOLLOW}<=${FOLLOW_LIMIT}    Click Element    ${FOLLOW_BUTTON}
    ${temp}=    Evaluate    ${TOTAL_FOLLOW}+1
    Run Keyword If    ${status} and ${TOTAL_FOLLOW}<=${FOLLOW_LIMIT}    Set Global Variable    ${TOTAL_FOLLOW}    ${temp}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${FOLLOWING_BUTTON}   3
    ${follow_fail}=    Set Variable If    ${status}    0    1
    ${TOTAL_NUMBER_FOLLOW_FAILURE}=    Evaluate    ${TOTAL_NUMBER_FOLLOW_FAILURE}+${follow_fail}
    Set Global Variable    ${TOTAL_NUMBER_FOLLOW_FAILURE}    ${TOTAL_NUMBER_FOLLOW_FAILURE}
    Sleep    ${FOLLOW_DELAY}
    ${name}    Run Keyword If    ${status}    Get Text    ${SHOP_NAME}
    ${status2}    Run Keyword And Return Status    List Should Not Contain Value    ${LIST_FOLLOW}    ${name}
    Run Keyword If    ${status} and ${status2}    Run Keywords    Append To List    ${LIST_FOLLOW}    ${name}    AND    Set Global Variable    ${LIST_FOLLOW}
    Wait Until Page Contains Element    ${FOLLOWING_BUTTON}   1

Comment
    ${count_comment}    Get Length    ${LIST_COMMENT}
    ${number}     Random Number For Comment    ${0}    ${count_comment}    ${LAST_RANDOM_NUM}
    Set Global Variable    ${LAST_RANDOM_NUM}    ${number}

    ${comment_text}    Get From List    ${LIST_COMMENT}    ${number}
    Wait Until Page Contains Element    ${COMMENT_TEXTBOX}    10s
    Run Keyword If    ${TOTAL_COMMENT}<=${COMMENT_LIMIT}    Click Element    ${COMMENT_TEXTBOX}
    Run Keyword If    ${TOTAL_COMMENT}<=${COMMENT_LIMIT}    Press Keys    ${COMMENT_TEXTBOX}    ${comment_text}
    Run Keyword If    ${TOTAL_COMMENT}<=${COMMENT_LIMIT}    Click Element    ${POST_BUTTON}
    ${temp}=    Evaluate    ${TOTAL_COMMENT}+1
    Run Keyword If    ${TOTAL_COMMENT}<=${COMMENT_LIMIT}    Set Global Variable    ${TOTAL_COMMENT}    ${temp}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    //a[text()='${USERNAME}']    5s
    ${comment_fail}=    Set Variable If    ${status}    0    1
    ${TOTAL_NUMBER_COMMENT_FAILURE}=    Evaluate    ${TOTAL_NUMBER_COMMENT_FAILURE}+${comment_fail}
    Set Global Variable    ${TOTAL_NUMBER_COMMENT_FAILURE}    ${TOTAL_NUMBER_COMMENT_FAILURE}
    Sleep    ${COMMENT_DELAY}
    Wait Until Page Contains Element    //a[text()='${USERNAME}']    1

Click Next Button
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    //button[text()="Report a Problem"]    1
    Run Keyword If    ${status}    CLick Element    //button[text()="OK"]
    Click Element    ${NEXT_BUTTON}

Click Cancel Button
    Press Keys    None    ESC
    Go To    https://www.instagram.com/

Repeat Like Follow Comment
    [Arguments]    ${index}
    :FOR    ${i}    IN RANGE    0    ${REPEAT}
    \    ${number}    Evaluate    ${i}%${SKIP_NUM}
    \    Run Keyword If    "${number}"=="0" and "${COMMENT}"=="true"       Run Keyword And Continue On Failure    Comment
    \    Run Keyword If    "${LIKE}"=="true"      Run Keyword And Continue On Failure    Like
    \    Run Keyword If    "${FOLLOW}"=="true"    Run Keyword And Continue On Failure    Follow
    \    Run Keyword And Continue On Failure    Click Next Button

Repeat Like Follow Comment For Hagtag
    ${index}    Set Variable    0
    :FOR    ${item}    IN    @{LIST_HAG_TAG}
    \    Run Keyword And Continue On Failure    Search By Hagtag    ${item}
    \    Repeat Like Follow Comment     ${index}
    \    Run Keyword And Continue On Failure    Click Cancel Button
    \    ${index}    Evaluate    ${index} + 1

Read Excel File For Hagtag
    Open Excel Document    HagtagPlan.xlsx    doc_id=doc1
    ${list_hag_tag}    Read Excel Column    col_num=${COLUMN}    sheet_name=Hashtags
    Remove Values From List    ${list_hag_tag}    ${None}
    ${list_comment}    Read Excel Column    col_num=${COLUMN}    sheet_name=Comments
    Remove Values From List    ${list_comment}    ${None}
    Set Global Variable    ${LIST_HAG_TAG}    ${list_hag_tag}
    Set Global Variable    ${LIST_COMMENT}    ${list_comment}