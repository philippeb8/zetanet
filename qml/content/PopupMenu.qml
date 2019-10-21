/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Item
{
    anchors.fill: parent

    Rectangle
    {
        id: menu
        x: comboBox.x - 40 * fudge;
        width: 40 * fudge;
        height: 40 * fudge;
        color: "#E0202020"
        smooth:true;

        Text
        {
            text: "\uf0c9"
            color: "white"
            font.pointSize: 28
            font.family: "FontAwesome"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea
        {
            hoverEnabled: true
            //onEntered: parent.color = "blue"
            //onExited: parent.color = "#E0202020"
            anchors.fill: parent;
            onClicked:
            {
                comboBox.state = comboBox.state===""?"CATEGORIES":""
            }
        }
    }

    Rectangle
    {
        id: comboBox
        //property alias selectedIndex: listView.currentIndex
        //property alias model: listView.model
        signal comboClicked;
        x: parent.width;
        width: 40 * fudge * 2
        height: 40 * fudge;
        //anchors.right: parent.right
        smooth:true;
        color: "#E0202020"
/*
        MouseArea
        {
            hoverEnabled: true
            //onEntered: parent.color = "blue"
            //onExited: parent.color = "transparent"
            anchors.fill: parent
            onClicked:
            {
                stackView.push(Qt.resolvedUrl("qrc:/qml/content/ButtonPage.qml"))
                comboBox.state = comboBox.state===""?"CATEGORIES":""
            }
        }
*/
        Rectangle
        {
            id:chosenItem
            x:0
            width: parent.width/2
            height: comboBox.height;
            color: "transparent"
            smooth:true;

            Text
            {
                text: "\uf022"
                color: "white"
                font.pointSize: 28
                font.family: "FontAwesome"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea
            {
                hoverEnabled: true
                //onEntered: parent.color = "blue"
                //onExited: parent.color = "transparent"
                anchors.fill: parent;
                onClicked:
                {
                    stackView.push(Qt.resolvedUrl("qrc:/qml/content/ButtonPage.qml"))
                    comboBox.state = comboBox.state===""?"CATEGORIES":""
                }
            }
        }

        Rectangle
        {
            id:chosenItem4
            x:parent.width*1/2
            width:parent.width/2
            height:comboBox.height;
            color: "transparent"
            smooth:true;

            Text
            {
                text: "\uf085"
                color: "white"
                font.pointSize: 28
                font.family: "FontAwesome"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea
            {
                hoverEnabled: true
                //onEntered: parent.color = "blue"
                //onExited: parent.color = "transparent"
                anchors.fill: parent;
                onClicked: {
                    stackView.push(Qt.resolvedUrl("qrc:/qml/content/ButtonPage.qml"))
                    comboBox.state = comboBox.state===""?"CATEGORIES":""
                }
            }
        }

/*
        Rectangle
        {
            id: dropDown
            width: parent.width;
            height: parent.parent.height - comboBox.height;
            clip: true;
            //radius: 4;
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: chosenItem.bottom;
            //anchors.margins: 2;
            color: "#E0202020"

            Component
            {
                id: highlight
                Rectangle
                {
                    width: page.width*2/3
                    height: comboBox.height
                    color: "lightsteelblue"
                    y: listView.currentItem.y
                    Behavior on y
                    {
                        SpringAnimation
                        {
                            spring: 3
                            damping: 0.2
                        }
                    }
                }
            }

            Component
            {
                id: header
                Rectangle
                {
                    width:  parent.width
                    height: comboBox.height;
                    color: "transparent"
                    Text
                    {
                        anchors.top: parent.top;
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.margins: 5;
                        color: "white"
                        text: comboBox.state;
                    }
                }
            }

            ListView {
                id: listView
                objectName: "listView"
                anchors.fill: parent
                model: undefined
                currentIndex: 0
                //highlight: highlight
                //highlightFollowsCurrentItem: false
                header: header
                signal selected(string state, string text);

                MouseArea
                {
                        id: myFlipMouseArea
                        anchors.fill: parent
                        propagateComposedEvents: true
                        property int startX;
                        property int startY;

                        onPressed:
                        {
                            startX = mouse.x;
                            startY = mouse.y;
                        }

                        onReleased:
                        {
                            var deltax = mouse.x - startX;
                            var deltay = mouse.y - startY;

                            if (deltax > 10)
                                comboBox.state = ""
                        }
                    }

                delegate: Item
                {
                    width: comboBox.width;
                    height: comboBox.height;

                    Rectangle
                    {
                        id: text
                        color: "transparent"
                        Text
                        {
                            id: text1
                            text: modelData.name1
                            anchors.top: parent.top;
                            anchors.left: parent.left;
                            anchors.margins: 5;
                            color: "white"
                        }
                        width: page.width*2/3
                        height: parent.height
                    }
                    MouseArea
                    {
                        hoverEnabled: true
                        anchors.fill: parent;
                        onClicked:
                        {
                            text.color = "transparent"
                            listView.currentIndex = index;
                            listView.selected(comboBox.state, modelData.name1);
                            comboBox.state = "";
                        }
                    }
                }
            }
        }
*/

        states: [
           State {
            name: "";
            PropertyChanges { target: comboBox; x: parent.width; }
        }, State {
            name: "CATEGORIES";
            PropertyChanges { target: comboBox; x: parent.width - 40 * fudge * 2; }
        }, State {
            name: "SETTINGS";
            PropertyChanges { target: comboBox; x: parent.width - 40 * fudge * 2; }
        }]

        transitions: Transition
        {
            NumberAnimation { target: comboBox; properties: "x"; easing.type: Easing.OutExpo; duration: 200 }
        }
    }
}
