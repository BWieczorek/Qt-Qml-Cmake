var component
    function createMenu() {
        component = Qt.createComponent("AlertMenu.qml");
        if (component.status === Component.Ready)
            finishCreation();
        else
            component.statusChanged.connect(finishCreation);

    }

    function finishCreation() {
        if (component.status === Component.Ready) {
            notifyBell.menuObj = component.createObject(notifyBell);
            notifyBell.menuObj.currentState = notifyBell.notify;

            //sprite = component.createObject(appWindow);
            if (notifyBell.menuObj === null) {
                console.log("Error creating Object");
            }
        }
        else if (component.status === Component.Error) {
            console.log("Error loading component:", component.errorString());
        }
    }
    function deleteMenu () {
        notifyBell.menuObj.destroy(0);
    }



