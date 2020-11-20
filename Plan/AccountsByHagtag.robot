*** Settings ***
Resource    ../Common/WebKeyword.robot
Suite Teardown    Run Keywords    Close Browser    AND    Save Excel Document    filename=listDataCompany.xlsx    AND     Close All Excel Documents
*** Test Cases ***
Accounts By Hagtag Plan
    Login    https://thongtindoanhnghiep.co/tinh-thanh-pho/gia-lai
    ${doc1}    Create Excel Document    doc_id=listDataCompany
    ${list_name}    Create List
    ${list_address}    Create List
    ${list_mst}    Create List
    ${list_nghe}    Create List
    Set Global Variable    ${list_name}
    Set Global Variable    ${list_address}
    Set Global Variable    ${list_mst}
    Set Global Variable    ${list_nghe}
    :FOR    ${i}    IN RANGE    1    201
    \    Run Keyword And Ignore Error    Go To    https://thongtindoanhnghiep.co/tinh-thanh-pho/gia-lai?p=${i}
    \    Run Keyword And Ignore Error    Find Company
    Write Data Report To Excel File    ${list_name}    ${list_address}    ${list_mst}    ${list_nghe}