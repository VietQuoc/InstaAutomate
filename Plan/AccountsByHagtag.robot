*** Settings ***
Resource    ../Common/WebKeyword.robot
Library    ExcelLibrary
*** Test Cases ***
Accounts By Hagtag Plan
    # Read Excel File For Hagtag
    # Login
    # Repeat Like Follow Comment For Hagtag
    Log    ${USERNAME}
    Log    ${PASSWORD}
    Log    ${LIKE}
    Run Keyword If    ${LIKE}    Log    ok
    Log    ${FOLLOW}
    Log    ${COMMENT}
    Log    ${REPEAT}
    Log    ${COLUMN}
