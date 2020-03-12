*** Variables ***
${LOGIN_URL}    https://www.instagram.com/accounts/login/?source=auth_switcher
${USERNAME_TEXTBOX}    //input[@name='username']
${PASSWORD_TEXTBOX}    //input[@name='password']
${LOGIN_SUBMIT_BUTTON}    //button[@type='submit']
${NOTIFICATION_DECINE_BUTTON}    //button[text()='Not Now']
${SEARCH_TEXTBOX}    //input[@placeholder='Search']
${SEARCH_RESULT}    //span[text()='$$']
${MOST_RECENT_CATEGORY}    //h2[text()='Most recent']/following::img[1]
${SELECT_ITEM_MOST_RECENT}    //h2[text()='Most recent']/following::div[1]/div[1]/div[1]/div[1]
${SELECTED_ITEM_DIALOG_SHOW}    //div[@role='dialog']
${LIKE_BUTTON}      //*[@aria-label="Like"]
${UNLIKE_BUTTON}    //*[@aria-label='Unlike']
${COMMENT_TEXTBOX}    //form/textarea
${FOLLOW_BUTTON}    //div[@role='dialog']//button[text()='Follow']
${FOLLOWING_BUTTON}    //div[@role='dialog']//button[text()='Following']
${POST_BUTTON}    //button[@type='submit']
${NEXT_BUTTON}    //a[text()='Next']
${SHOP_NAME}      //div[@role='dialog']//div[@role='dialog']//a[not(@style)]

${LIST_FOLLOWING_BUTTON}