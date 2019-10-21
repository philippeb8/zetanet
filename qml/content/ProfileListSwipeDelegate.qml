/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4

SwipeDelegate
{
    id: item
    width: (container.objectName === "list" ? parent.width : parent.width / 2) - 4 * fudge
    height: 8 * fudge * 3 + album.height

    property bool flipped: false
    property bool albumMaximised: false

    transform:
    [
        Rotation {
            id: rotation
            origin.x: item.width/2
            origin.y: item.height/2
            axis.x: 0; axis.y: 0; axis.z: 1     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        },
        Scale {
            id: scale
            origin.x: item.width/2
            origin.y: item.height/2
            xScale: 1
            yScale: 1
        }
    ]

    states: State {
        name: "back"
        PropertyChanges { target: rotation; angle: 180 * 6 }
        PropertyChanges { target: scale; xScale: 0.01; yScale: 0.01 }
        when: item.flipped
    }

    transitions: Transition {
        NumberAnimation { target: rotation; property: "angle"; duration: 500 }
        NumberAnimation { target: scale; property: "xScale"; duration: 500 }
        NumberAnimation { target: scale; property: "yScale"; duration: 500 }

        onRunningChanged: {
            if ((state == "back") && (!running))
                container.model.remove(index)
        }
    }

    contentItem: Row
    {
        //padding: 8 * fudge
        spacing: 8 * fudge

        ProfileListAlbum
        {
            id: album
            width: (albumMaximised ? item.width : item.parent.width / 3 - 4 * fudge) - 8 * fudge * 2
            height: width
            //anchors.horizontalCenter: parent.horizontalCenter
        }

        Label
        {
            id: subject
            width: item.width - album.width - 8 * fudge * 3
            text: subjectString
            font.pointSize: 12 * fudge
            font.family: "FontAwesome"
            visible: true
            color: "black"
            wrapMode: Text.Wrap
        }

/*
        Label
        {
            id: text
            width: item.width - 8 * fudge * 2
            text: textString
            font.pointSize: 16 * fudge
            font.family: "FontAwesome"
            visible: textShown
            color: "black"
            wrapMode: Text.Wrap

            MouseArea
            {
                id: textMouse
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent;
                onClicked: textClicked(userId);
            }
        }
*/
    }

    //onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/content/ChatPage.qml"), {userId: userId, pushTransition: stackView.transitionSlideFromBottom, popTransition: stackView.transitionSlideToBottom});

    onClicked: Qt.openUrlExternally(textString);

    swipe.right: Row
    {
        anchors.right: parent.right
        height: parent.height
        spacing: 8 * fudge

        Label
        {
            text: qsTr("Hide User")
            color: "black"
            verticalAlignment: Label.AlignVCenter
            //padding: 12
            height: parent.height
            //anchors.right: parent.right
            visible: blockShown

            SwipeDelegate.onClicked:
            {
                InputDialog.confirm
                (
                    gv_,
                    "Hide user?",
                    function (ok)
                    {
                        if (ok)
                        {
                            var http = new XMLHttpRequest();

                            http.open("POST", apiUrl + "insertHide.php", true);
                            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                            http.onreadystatechange = function()
                            {
                                if (http.readyState == 4 && http.status == 200)
                                {
                                    container.parent.refresh();
                                }
                            }
                            http.send(apiData + "&hideid=" + userId + "&userid=" + facebook.profile.userId);
                        }
                    }
                )
            }

            //background: Rectangle {
            //    color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
            //}
        }

        Label
        {
            text: qsTr("Delete Record")
            color: "black"
            verticalAlignment: Label.AlignVCenter
            //padding: 12
            height: parent.height
            //anchors.right: parent.right
            visible: dropShown

            SwipeDelegate.onClicked:
            {
                InputDialog.confirm
                (
                    gv_,
                    "Delete record?",
                    function (ok)
                    {
                        if (ok)
                        {
                            item.flipped = true;
                            container.parent.dropClicked(id);
                        }
                    }
                )
            }

            //background: Rectangle {
            //    color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
            //}
        }
    }
}
