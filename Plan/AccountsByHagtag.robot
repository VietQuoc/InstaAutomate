*** Settings ***
Resource    ../Common/WebKeyword.robot
Library    ExcelLibrary
Suite Teardown    Close Browser

*** Test Cases ***
Accounts By Hagtag Plan
    Read Excel File For Hagtag
    Login
    Repeat Like Follow Comment For Hagtag
