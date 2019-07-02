function showErrors() {
    if(notify == true){
    numberOfError = 0;
    if(requestError!==0){
        numberOfError++;
    }

   if(jsonError!==0){
         numberOfError++;
    }
    if(sslerror !== 0){
        numberOfError += sslerror.length
    }


    if(requestError!==0){
        errorTXT.text = requestError
        errorIcon.source = "qrc:/assetsMenu/exampleAlertIcon2.png"
        errorTXT.color = "#DB3D40"
        stopConnectionButton.visible = true;
        ignoreButton.visible = true;
    }

    else if(jsonError!==0){
        errorTXT.text = requestError
        errorIcon.source = "qrc:/assetsMenu/exampleAlertIcon2.png"
        errorTXT.color = "#DB3D40"
        ignoreButton.visible = true;
    }
    else if(sslerror !== 0){
        var errorString;
        var i;
        for(i = 0; i<sslerror.length; i++){
            errorString += " " + sslerror[i];
        }

        errorTXT.text = "Detected sslError nr." + errorString
        stopConnectionButton.visible = true;
        ignoreButton.visible = true;
    }

    else {
        errorIcon.source="qrc:/assetsMenu/okIcon.png"
        errorTXT.text = "Everything works correctly"
        errorTXT.color = "#38865B"
        ignoreButton.visible = false;
        stopConnectionButton.visible = false;
    }
    }
    else {
        errorIcon.source="qrc:/assetsMenu/okIcon.png"
        errorTXT.text = "Everything works correctly"
        errorTXT.color = "#38865B"
        ignoreButton.visible = false;
        stopConnectionButton.visible = false;
        numberOfError = 0;
    }

}
function showInformation(){
    informationTXT.text = "Information no. " + informationIterator;
}
