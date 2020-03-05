*** Settings ***
Library    Selenium2Library
Library    String
Library    Collections
Library    ExcelLibrary
Resource    ../Interface/WebInterface.robot

*** Keywords ***
Login
    Open Browser    ${LOGIN_URL}    Chrome
    Wait Until Page Contains Element    ${USERNAME_TEXTBOX}
    Input Text    ${USERNAME_TEXTBOX}    ${USERNAME}
    Input Text    ${PASSWORD_TEXTBOX}    ${PASSWORD}
    CLick Element    ${LOGIN_SUBMIT_BUTTON}
    Wait Until Page Contains Element    ${NOTIFICATION_DECINE_BUTTON}
    Click Element    ${NOTIFICATION_DECINE_BUTTON}

Search By Hagtag
    [Arguments]    ${tag}
    Input Text    ${SEARCH_TEXTBOX}    ${tag}
    ${search_result_locator}    Replace String    ${SEARCH_RESULT}    $$    ${tag}
    Wait Until Page Contains Element    ${search_result_locator}
    Click Element    ${search_result_locator}
    Wait Until Page Contains Element    ${MOST_RECENT_CATEGORY}
    Scroll Element Into View    ${MOST_RECENT_CATEGORY}
    Sleep    1
    Click Element    ${SELECT_ITEM_MOST_RECENT}
    Wait Until Element Is Visible    ${SELECTED_ITEM_DIALOG_SHOW}    10

Like
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${LIKE_BUTTON}   1
    Run Keyword If    ${LIKE}==${TRUE} and ${status}    Click Element    ${LIKE_BUTTON}

Follow
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${FOLLOW_BUTTON}   1
    Run Keyword If    ${FOLLOW}==${TRUE} and ${status}    Click Element    ${FOLLOW_BUTTON}

Comment
    ${count_comment}    Get Length    ${LIST_COMMENT}
    ${number}    Evaluate    random.sample(range(1, ${count_comment}), 1)    random
    ${number}    Get From List    ${number}    0
    ${comment_text}    Get From List    ${LIST_COMMENT}    ${number}
    Wait Until Page Contains Element    ${COMMENT_TEXTBOX}    10s
    Run Keyword If    ${COMMENT}==${TRUE}    Run Keywords    Click Element    ${COMMENT_TEXTBOX}    AND
    ...   Press Keys    ${COMMENT_TEXTBOX}    ${comment_text}    AND
    ...   Click Element    ${POST_BUTTON}
    Run Keyword And Ignore Error    Wait Until Page Contains Element    //span[text()='${comment_text}']    5s

Click Next Button
    Click Element    ${NEXT_BUTTON}

Click Cancel Button
    Press Keys    None    ESC
    Go To    https://www.instagram.com/

Repeat Like Follow Comment
    [Arguments]    ${index}
    :FOR    ${i}    IN RANGE    0    ${REPEAT}
    \    Run Keyword And Continue On Failure    Comment
    \    Run Keyword And Continue On Failure    Like
    \    Run Keyword And Continue On Failure    Follow
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
    ${list_hag_tag}    Read Excel Column    col_num=${COLUMN}    sheet_name=Sheet1
    Remove Values From List    ${list_hag_tag}    ${None}
    ${list_comment}    Read Excel Column    col_num=${COLUMN}    sheet_name=Sheet2
    Remove Values From List    ${list_comment}    ${None}
    Set Global Variable    ${LIST_HAG_TAG}    ${list_hag_tag}
    Set Global Variable    ${LIST_COMMENT}    ${list_comment}