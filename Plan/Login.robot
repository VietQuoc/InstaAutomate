*** Settings ***
Library    Selenium2Library     implicit_wait=20

*** Test Cases ***
Login
    Open Browser    https://www.instagram.com/accounts/login/?source=auth_switcher    Chrome
    Input Text    //input[@name='username']    vietquoc3012
    Input Text    //input[@name='password']    q4320086
    CLick Element    //button[@type='submit']
    Click Element    //button[text()='Not Now']
    Input Text    //input[@placeholder='Search']    \#vnxk
    Click Element    //span[text()='#vnxk']
    Scroll Element Into View    //h2[text()='Most recent']/following::img[1]
    Click Element    //h2[text()='Most recent']/following::div[1]/div[1]/div[1]/div[1]
    Wait Until Element Is Visible    //div[@role='dialog']    20
#    Click Element    //*[@aria-label='Like']
#    Press Keys    //textarea[1]    Comment\n
#    Click Element    //div[@role='dialog']//button[text()='Follow']
    Click Element    //a[text()='Next']
    Capture Page Screenshot