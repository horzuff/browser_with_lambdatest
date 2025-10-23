*** Settings ***
Library        Browser
Library        String
Library        OperatingSystem
Library        config.py    AS    LTConfig
Variables      creds/creds.py

Suite Setup    Suite setup keyword


*** Test Cases ***

File downloading test
    Browser.New Page    https://the-internet.herokuapp.com/download 
    ${status}=    BuiltIn.Run Keyword and Return Status    Download by href
    BuiltIn.Should Not Be True    ${status}
    ${status}=    BuiltIn.Run Keyword and Return Status    Download with saveAs
    BuiltIn.Should Be True    ${status}
    ${status}=    BuiltIn.Run Keyword and Return Status    Download with promise
    BuiltIn.Should Not Be True    ${status}
    ${status}=    BuiltIn.Run Keyword and Return Status    Download with promise and saveas
    BuiltIn.Should Be True    ${status}

File uploading test
    Browser.New Page    https://the-internet.herokuapp.com/upload
    Upload to input
    Upload with promise
    
*** Keywords ***

Suite setup keyword
    [Documentation]    suite setup
    ${loglevel}=    BuiltIn.Set Log Level    NONE
    ${remote capabilities}=    LTConfig.Capability    ${LTuser}    ${LTkey}
    Browser.Connect To Browser    wss://cdp.lambdatest.com/playwright?capabilities=${remote capabilities}
    BuiltIn.Set Log Level    ${loglevel}
    Browser.New Context    viewport={'width': 1920, 'height': 1080}

Download by href
    @{downloads}=    Browser.Get Elements    xpath=//div[@class="example"]//a[text()]
    ${href}=    Browser.Get Property    ${downloads}[0]    href
    ${file}=    Browser.Download    href=${href}
    ${actual_size}=    Get File Size    ${file.saveAs}

Download with saveAs
    @{downloads}=    Browser.Get Elements    xpath=//div[@class="example"]//a[text()]
    ${href}=    Browser.Get Property    ${downloads}[1]    href
    ${filename}=    Browser.Get Text    ${downloads}[1]
    ${file}=    Browser.Download    ${href}    saveAs=${OUTPUT_DIR}${/}${filename}
    OperatingSystem.File Should Exist    ${OUTPUT_DIR}${/}${filename}
    OperatingSystem.File Should Not Be Empty    ${OUTPUT_DIR}${/}${filename}
    VAR    ${test file}    ${OUTPUT_DIR}${/}${filename}    scope=SUITE

Download with promise
    @{downloads}=    Browser.Get Elements    xpath=//div[@class="example"]//a[text()]
    ${href}=    Browser.Get Property    ${downloads}[2]    href
    ${filename}=    Browser.Get Text    ${downloads}[2]
    ${download promise}=    Browser.Promise To Wait For Download
    Browser.Click    ${downloads}[2]
    ${file}=    Browser.Wait For    ${download promise}
    OperatingSystem.File Should Exist      ${file.saveAs}
    Should Be True    '${file.suggestedFilename}' != ${None}

Download with promise and saveas
    @{downloads}=    Browser.Get Elements    xpath=//div[@class="example"]//a[text()]
    ${href}=    Browser.Get Property    ${downloads}[3]    href
    ${filename}=    Browser.Get Text    ${downloads}[3]
    ${download promise}=    Browser.Promise To Wait For Download    ${OUTPUT_DIR}${/}${filename}
    Browser.Click    ${downloads}[3]
    ${file}=    Browser.Wait For    ${download promise}
    OperatingSystem.File Should Exist    ${OUTPUT_DIR}${/}${filename}
    OperatingSystem.File Should Not Be Empty    ${OUTPUT_DIR}${/}${filename}

Upload to input
    Browser.Upload File By Selector    id=file-upload    ${test file}
    Browser.Click    id=file-submit
    Browser.Wait For Elements State    id=uploaded-files    visible
    Browser.Go Back

Upload with promise
    ${upload promise}=    Browser.Promise To Upload File    ${test file}
    Browser.Click    id=file-upload
    ${upload result}=    Browser.Wait For    ${upload promise}
    Browser.Click    id=file-submit
    Browser.Wait For Elements State    id=uploaded-files    visible
    Browser.Go Back