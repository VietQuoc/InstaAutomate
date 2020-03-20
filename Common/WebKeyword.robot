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
    Maximize Browser Window
    Wait Until Page Contains Element    ${USERNAME_TEXTBOX}
    Sleep   5s
    Input Text    ${USERNAME_TEXTBOX}    ${USERNAME}
    Input Text    ${PASSWORD_TEXTBOX}    ${PASSWORD}
    CLick Element    ${LOGIN_SUBMIT_BUTTON}
    Wait Until Page Contains Element    ${SEARCH_TEXTBOX}    10

Search By Hagtag
    [Arguments]    ${tag}
    Input Text    ${SEARCH_TEXTBOX}    ${tag}
    ${search_result_locator}    Replace String    ${SEARCH_RESULT}    $$    ${tag}
    Wait Until Element Is Visible    ${search_result_locator}    20
    Sleep    1s
    Click Element    ${search_result_locator}
    Wait Until Page Contains Element    ${MOST_RECENT_CATEGORY}
    Scroll Element Into View    ${MOST_RECENT_CATEGORY}
    Sleep    1
    Click Element    ${SELECT_ITEM_MOST_RECENT}
    Wait Until Element Is Visible    ${SELECTED_ITEM_DIALOG_SHOW}    10

Like
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${LIKE_BUTTON}   5
    Sleep    0.5
    Run Keyword If    ${status} and ${TOTAL_LIKE}<${LIKE_LIMIT}    Run Keyword And Continue On Failure    CLick Element    ${LIKE_BUTTON}
    ${temp}=    Evaluate    ${TOTAL_LIKE}+1
    Run Keyword If    ${status} and ${TOTAL_LIKE}<${LIKE_LIMIT}    Set Global Variable    ${TOTAL_LIKE}    ${temp}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${UNLIKE_BUTTON}   3
    ${like_fail}=    Set Variable If    ${status}    0    1
    ${TOTAL_NUMBER_LIKE_FAILURE}=    Evaluate    ${TOTAL_NUMBER_LIKE_FAILURE}+${like_fail}
    ${name}    Get Text    ${SHOP_NAME}
    Run Keyword If    ${TOTAL_LIKE}<${LIKE_LIMIT} and ${status}    Append To List    ${LIST_LIKER}    ${name}
    Run Keyword If    ${TOTAL_LIKE}<${LIKE_LIMIT} and ${status}    Set Global Variable    ${LIST_LIKER}
    Run Keyword If    ${TOTAL_LIKE}<${LIKE_LIMIT}    Set Global Variable    ${TOTAL_NUMBER_LIKE_FAILURE}    ${TOTAL_NUMBER_LIKE_FAILURE}
    Sleep    ${LIKE_DELAY}
    Run Keyword If    ${TOTAL_LIKE}<${LIKE_LIMIT}    Wait Until Page Contains Element    ${UNLIKE_BUTTON}   1

Follow
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${FOLLOW_BUTTON}   5
    Sleep    0.5
    Run Keyword If    ${status} and ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Run Keyword And Continue On Failure    Click Element    ${FOLLOW_BUTTON}
    ${temp}=    Evaluate    ${TOTAL_FOLLOW}+1
    Run Keyword If    ${status} and ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Set Global Variable    ${TOTAL_FOLLOW}    ${temp}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    ${FOLLOWING_BUTTON}   3
    ${follow_fail}=    Set Variable If    ${status}    0    1
    ${TOTAL_NUMBER_FOLLOW_FAILURE}=    Run Keyword If    ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Evaluate    ${TOTAL_NUMBER_FOLLOW_FAILURE}+${follow_fail}
    Run Keyword If    ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Set Global Variable    ${TOTAL_NUMBER_FOLLOW_FAILURE}    ${TOTAL_NUMBER_FOLLOW_FAILURE}
    Sleep    ${FOLLOW_DELAY}
    ${name}    Run Keyword If    ${status}    Get Text    ${SHOP_NAME}
    ${time}    Get Time    epoch
    ${status2}    Run Keyword And Return Status    List Should Not Contain Value    ${LIST_FOLLOWER}    ${name}
    Run Keyword If    ${status} and ${status2} and ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Run Keywords    Append To List    ${LIST_FOLLOWER}    ${name}    AND    Set Global Variable    ${LIST_FOLLOWER}
    Run Keyword If    ${status} and ${status2} and ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Run Keywords    Append To List    ${LIST_TIME_FOLLOWER}    ${time}    AND    Set Global Variable    ${LIST_TIME_FOLLOWER}
    Run Keyword If    ${TOTAL_FOLLOW}<${FOLLOW_LIMIT}    Wait Until Page Contains Element    ${FOLLOWING_BUTTON}   1

Comment
    ${count_comment}    Get Length    ${LIST_COMMENT}
    ${number}     Random Number For Comment    ${0}    ${count_comment}    ${LAST_RANDOM_NUM}
    Set Global Variable    ${LAST_RANDOM_NUM}    ${number}

    ${comment_text}    Get From List    ${LIST_COMMENT}    ${number}
    Wait Until Page Contains Element    ${COMMENT_TEXTBOX}    10s
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Click Element    ${COMMENT_TEXTBOX}
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Press Keys    ${COMMENT_TEXTBOX}    ${comment_text}
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Click Element    ${POST_BUTTON}
    ${temp}=    Evaluate    ${TOTAL_COMMENT}+1
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Set Global Variable    ${TOTAL_COMMENT}    ${temp}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains Element    //a[text()='${USERNAME}']    5s

    ${name}    Get Text    ${SHOP_NAME}
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT} and ${status}    Append To List    ${LIST_COMMENTER}    ${name}
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT} and ${status}    Set Global Variable    ${LIST_COMMENTER}

    ${comment_fail}=    Set Variable If    ${status}    0    1
    ${TOTAL_NUMBER_COMMENT_FAILURE}=    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Evaluate    ${TOTAL_NUMBER_COMMENT_FAILURE}+${comment_fail}
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Set Global Variable    ${TOTAL_NUMBER_COMMENT_FAILURE}    ${TOTAL_NUMBER_COMMENT_FAILURE}
    Sleep    ${COMMENT_DELAY}
    Run Keyword If    ${TOTAL_COMMENT}<${COMMENT_LIMIT}    Wait Until Page Contains Element    //a[text()='${USERNAME}']    1

Click Next Button
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    //button[text()="Report a Problem"]    1
    Run Keyword If    ${status}    CLick Element    //button[text()="OK"]
    Click Element    ${NEXT_BUTTON}

Click Cancel Button
    Press Keys    None    ESC
    Go To    https://www.instagram.com/

Repeat Like Follow Comment
    [Arguments]    ${index}=0
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
    Close All Excel Documents

Write Data Report To Excel File
    ${doc1}    Create Excel Document    doc_id=docname1
    Write Excel Column    col_num=1    col_data=${LIST_FOLLOWER}
    Write Excel Column    col_num=2    col_data=${LIST_LIKER}
    Write Excel Column    col_num=3    col_data=${LIST_COMMENTER}

    Write Excel Column    col_num=4    col_data=${FOLOWED_TOTAL_RUN}
    ${followed_failure}    Create List    Follow Fail    ${TOTAL_NUMBER_FOLLOW_FAILURE}
    Write Excel Column    col_num=5    col_data=${followed_failure}

    Write Excel Column    col_num=6    col_data=${COMMENTED_TOTAL_RUN}
    ${comment_failure}    Create List    Comment Fail    ${TOTAL_NUMBER_COMMENT_FAILURE}
    Write Excel Column    col_num=7    col_data=${comment_failure}

    Write Excel Column    col_num=8    col_data=${LIKED_TOTAL_RUN}
    ${like_failure}    Create List    Like Fail    ${TOTAL_NUMBER_LIKE_FAILURE}
    Write Excel Column    col_num=9    col_data=${like_failure}
    
    Write Excel Column    col_num=10    col_data=${LIST_TIME_FOLLOWER}

    Save Excel Document    filename=report.xlsx
    Close All Excel Documents

Goto And Select User
    :FOR    ${item}    IN    @{LIST_HAG_TAG}
    \    Go To    https://www.instagram.com/${item}
    \    Wait Until Element Is Visible    ${PROFILE_FOLLOWER_BUTTON}    20s
    \    Click Element    ${PROFILE_FOLLOWER_BUTTON}
    \    Run Keyword And Continue On Failure    Select Followers And Repeat Job

Select Followers And Repeat Job
    Wait Until Element Is Visible    ${PROFILE_FOLLOWER_MODAL_TITLE}    10s
    Wait Until Page Contains Element    ${PROFILE_FOLLOWER_MODAL_DESCRIPTION}    10s
    Click Element    ${PROFILE_FOLLOWER_MODAL_DESCRIPTION}    
    ${number}    Convert To Integer    ${NUMBER_FOLLOWER}
    FOR    ${i}    IN RANGE   0    100
    \    Wait Until Page Contains Element    ${PROFILE_FOLLOWE_NAME}    20
    \    ${number_name}    Get WebElements    ${PROFILE_FOLLOWE_NAME}
    \    ${number_name}    Get Length    ${number_name}
    \    Exit For Loop If    ${number_name}>=${number}
    \    Run Keyword And Ignore Error    Click Element    ${PROFILE_FOLLOWER_MODAL_DESCRIPTION}
    \    Press Keys    None    END
    \    Capture Page Screenshot    
    
    ${list_user_run}    Create List    
    ${list_element}    Get WebElements    ${PROFILE_FOLLOWE_NAME}
    ${i}    Set Variable    ${0}
    FOR    ${item}    IN    @{list_element}
    \    ${h}    Get Element Attribute    ${item}    href
    \    Append To List    ${list_user_run}    ${h}
    \    ${i}    Evaluate    ${i}+1
    \    Exit For Loop If    ${i}==${number}
    
    Log    ${list_user_run}
    FOR    ${item}    IN    @{list_user_run}
        Go To    ${item}
        Wait Until Element Is Visible    //a[@href]//img    20s
        Execute JavaScript    window.scrollTo(0, 200)
        Click Element    //a[@href]//img/../..
        Run Keyword And Ignore Error    Wait Until Element Is Visible    ${SELECTED_ITEM_DIALOG_SHOW}    20
        Run Keyword And Ignore Error    Repeat Like Follow Comment
    END

