/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import QtPositioning 5.2
import QtLocation 5.3
import "content"

ApplicationWindow
{
    id: gv_

    visible: true
    width: 640
    height: 480 * 2

    property var coordinate

    PositionSource
    {
        active: true
        updateInterval: 60000 // 1 minute

        onPositionChanged:
        {
            coordinate = QtPositioning.coordinate(position.coordinate.latitude, position.coordinate.longitude, 0);
        }
    }

    // Load the "FontAwesome" font for the monochrome icons.
    FontLoader
    {
        source: "qrc:/qml/fonts/fontawesome-webfont.ttf"
    }

    // Local database
    property var db: LocalStorage.openDatabaseSync();

    SwipeView
    {
        id: swipeView
        anchors.fill: parent
        interactive: false

        StackView
        {
            id: stackView
            //anchors.fill: parent

            signal stateChanged();

            delegate: StackViewDelegate
            {
                function getTransition(properties)
                {
                    var usedPushTransition = properties.enterItem.pushTransition ? properties.enterItem.pushTransition : stackView.transitionSlideFromRight
                    var usedPopTransition = properties.exitItem.popTransition ? properties.exitItem.popTransition : stackView.transitionSlideToRight

                    if(properties.name === "pushTransition") {
                        return usedPushTransition
                    } else if(properties.name === "popTransition") {
                        return usedPopTransition
                    } else {
                        console.error("Requested unexpected transition type " + properties.name)
                    }
                }
            }

            property Component transitionSlideFromRight: Component
            {
                StackViewTransition
                {
                    PropertyAnimation
                    {
                        target: enterItem
                        property: "x"
                        from: width
                        to: 0
                        easing.type: Easing.InOutQuad
                        duration: 200
                    }

                    onRunningChanged: if (!running) stackView.stateChanged()
                }
            }

            property Component transitionSlideToRight: Component
            {
                StackViewTransition
                {
                    PropertyAnimation
                    {
                        target: exitItem
                        property: "x"
                        from: 0
                        to: width
                        easing.type: Easing.InOutQuad
                        duration: 200
                    }

                    //onRunningChanged: if (!running) stackView.stateChanged()
                }
            }

            property Component transitionSlideFromBottom: Component
            {
                StackViewTransition
                {
                    PropertyAnimation
                    {
                        target: enterItem
                        property: "y"
                        from: height
                        to: 0
                        easing.type: Easing.InOutQuad
                        duration: 200
                    }

                    onRunningChanged: if (!running) stackView.stateChanged()
                }
            }

            property Component transitionSlideToBottom: Component
            {
                StackViewTransition
                {
                    PropertyAnimation
                    {
                        target: exitItem
                        property: "y"
                        from: 0
                        to: height
                        easing.type: Easing.InOutQuad
                        duration: 200
                    }

                    //onRunningChanged: if (!running) stackView.stateChanged()
                }
            }

            initialItem: Item
            {
                width: parent.width
                height: parent.height

                BulletinboardPage
                {
                    id: mainPage;
                }
            }

            onVisibleChanged:
            {
                if (visible)
                     swipeView.interactive = false
            }
        }

        // this rectangle contains the "menu"
        Rectangle
        {
            id: menu
            //anchors.fill: parent

            color: "#303030";
            //opacity: gv_.menu_shown ? 1 : 0
            //enabled: gv_.menu_shown ? true : false
            Behavior on opacity { NumberAnimation { duration: 300 } }

            // this is my sample menu content (TODO: replace with your own)
            ListView
            {
                clip: true
                anchors { fill: parent; margins: 22 * fudge }
                model: menuModel
                delegate: Item
                {
                    height: 42 * fudge
                    width: parent.width

                    Text
                    {
                        anchors { right: parent.right; rightMargin: 12 * fudge; verticalCenter: parent.verticalCenter }
                        color: "white";
                        font.pixelSize: 14 * fudge;
                        text: label
                        scale: labelMouse.pressed ? 1.2 : 1
                    }

                    Rectangle
                    {
                        height: 2 * fudge;
                        width: parent.width * 0.7;
                        color: "gray";
                        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                    }

                    MouseArea
                    {
                        id: labelMouse;
                        anchors.fill: parent
                        onClicked: menuModel.actions[label]();
                    }
                }
            }

            ListModel
            {
                id: menuModel

                property var actions:
                {
                    "Index URL": function()
                    {
                        onMenu();
                        stackView.push(Qt.resolvedUrl("qrc:/qml/content/PostUrlPage.qml"), {pushTransition: stackView.transitionSlideFromBottom, popTransition: stackView.transitionSlideToBottom}).refresh.connect(mainPage.list.load);
                    },
                    "Generate Page & Index URL": function()
                    {
                        onMenu();
                        stackView.push(Qt.resolvedUrl("qrc:/qml/content/PostPage.qml"), {pushTransition: stackView.transitionSlideFromBottom, popTransition: stackView.transitionSlideToBottom}).refresh.connect(mainPage.list.load);
                    },
                    "Quit": function()
                    {
                        Qt.quit();
                    }
                }

                ListElement
                {
                    label: "Index URL"
                }
                ListElement
                {
                    label: "Generate Page & Index URL"
                }
                ListElement
                {
                    label: "Quit"
                }
            }
        }

        onCurrentIndexChanged:
        {
            switch (currentIndex)
            {
            case 0: interactive = false; break;
            case 1: interactive = true; break;
            }
        }
    }

    /* this functions toggles the menu and starts the animation */
    function onMenu()
    {
        swipeView.currentIndex = swipeView.currentIndex == 0 ? 1 : 0
    }
}
