*** Settings ***
Resource    ../Common/WebKeyword.robot

*** Test Cases ***
Accounts By Hagtag Plan
    Login
    Repeat Like Follow Comment For Hagtag
