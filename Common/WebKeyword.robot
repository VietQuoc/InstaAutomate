*** Settings ***
Library    Selenium2Library     implicit_wait=5
Library    String
Library    Collections
Resource    ../Interface/WebInterface.robot

*** Keywords ***
Login
    Open Browser    ${LOGIN_URL}    Chrome
    Input Text    ${USERNAME_TEXTBOX}    ${USERNAME}
    Input Text    ${PASSWORD_TEXTBOX}    ${PASSWORD}
    CLick Element    ${LOGIN_SUBMIT_BUTTON}
    Click Element    ${NOTIFICATION_DECINE_BUTTON}

Search By Hagtag
    [Arguments]    ${tag}
    Input Text    ${SEARCH_TEXTBOX}    ${tag}
    ${search_result_locator}    Replace String    ${SEARCH_RESULT}    $$    ${tag}
    Click Element    ${search_result_locator}
    Scroll Element Into View    ${MOST_RECENT_CATEGORY}
    Click Element    ${SELECT_ITEM_MOST_RECENT}
    Wait Until Element Is Visible    ${SELECTED_ITEM_DIALOG_SHOW}    20

Like
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${LIKE_BUTTON}   1
    Run Keyword If    '${LIKE}'=='1' and ${status}    Click Element    ${LIKE_BUTTON}

Follow
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${FOLLOW_BUTTON}   1
    Run Keyword If    '${FOLLOW}'=='1' and ${status}    Click Element    ${FOLLOW_BUTTON}

Comment
    [Arguments]    ${text}
    Run Keyword If    '${COMMENT}'=='1'    Press Keys    ${COMMENT_TEXTBOX}    ${text}\n

Click Next Button
    Click Element    ${NEXT_BUTTON}

Click Cancel Button
    Press Keys    None    ESC

Repeat Like Follow Comment
    ${list_comment}    Split String    ${COMMENT}    ,
    ${count_comment}    Get Length    ${list_comment}
    ${number}=    Evaluate    random.sample(range(1, ${count_comment}), 1)    random
    :FOR    ${i}    IN RANGE    0    ${REPEAT}
    \    Like
    \    Follow
    \    ${comment_text}    Set Variable    @{list_comment}${number}
    \    Comment    @{list_comment}${number}
    \    Click Next

Repeat Like Follow Comment For Hagtag
    ${list_hagtag}    Split String    ${HAGTAG}    ,
    :FOR    ${item}    IN    @{list_hagtag}
    \    Search By Hagtag    ${item}
    \    Repeat Like Follow Comment
    \    Click Cancel Button
