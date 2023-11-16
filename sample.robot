*** Settings ***
Library    Browser
Library    config.py    AS    LTConfig
Library    String
Library    OperatingSystem

Suite Setup    Suite setup keyword

*** Variables ***

${search locator}    xpath=//textarea
${search result locator}    xpath=//div[@class="b_title"]//a[text()="Print and Packaging Solutions | HEIDELBERG"]
${continue without cookies locator}    css=div[id=uc-cnil-deny-all]

${upload file}    .${/}test_file.txt
${file upload locator}    //input[@type="file" and @name="files[]"]

${download file button}    //a[@role="button" and @class="mw-mmv-download-button"]
${size selection dropdown}    span.mw-ui-button.mw-ui-progressive.mw-mmv-download-select-menu
${small size option}    //span[text()="Small "]
${download file}    ${OUTPUT DIR}${/}myw3schoolsimage.jpg
${file download locator}    //a[@download and @href]

*** Test Cases ***

File up- and download
    Open file upload mock
    Test uploading file
    Browser.Close Page
    Open file download mock
    Test downloading file
    Browser.Close Browser

*** Keywords ***
Suite setup keyword
    [Documentation]    suite setup
    ${remote capabilities}=    LTConfig.Capability
    Browser.Connect To Browser    wss://cdp.lambdatest.com/playwright?capabilities=${remote capabilities}
    Browser.New Context    viewport={'width': 1920, 'height': 1080}

Open file upload mock
    Browser.New Page    url=https://blueimp.github.io/jQuery-File-Upload/

Test uploading file
    ${promise}=    Browser.Promise To Upload File    ${upload file}
    Browser.Click    ${file upload locator}
    Browser.Wait For    ${promise}

Open file download mock
    Browser.New Page    url=https://en.wikipedia.org/wiki/Bun#/media/File:Sesame_seed_hamburger_buns.jpg
    

Test downloading file
    ${promise}=    Browser.Promise To Wait For Download
    Browser.Click    xpath=${download file button}
    Browser.Click    css=${size selection dropdown}
    Browser.Click    xpath=${small size option}
    Browser.Click    xpath=${file download locator}
    ${file_obj}=    Wait For    ${promise}
    OperatingSystem.File Should Exist    ${file_obj}[saveAs]
    Should Be True       ${file_obj.suggestedFilename}
