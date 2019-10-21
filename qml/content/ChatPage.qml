/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

IOSPage
{
    id: chat
    width: parent.width
    height: parent.height

    property string userId;

    //property Item pictureMenu: PictureMenu {}

    Column
    {
        anchors.fill: parent;

        Rectangle
        {
            width: parent.width
            height: Theme.statusBarHeight
        }

        DoneToolBarItem
        {
            width: parent.width
            height: 42 * fudge
        }

        Component
        {
            id: chatDelegate

            Item
            {
                id: chatItem
                width: parent.width
                height: bubble.height + 20 * fudge

                Rectangle
                {
                    id: bubble
                    x: (inout == "out") ? (chatItem.width - width - 20) : 20
                    y: 14
                    width: label.contentWidth + 12
                    height: label.contentHeight + 12
                    color: (inout == "out") ? "lightblue" : "lightsteelblue"
                    radius: 4

                    property alias text: label.text

                    NumberAnimation { id: anim; duration: 300; easing.type: Easing.InBack }
                    Behavior on x { animation: anim }

                    //Behavior on opacity { NumberAnimation { duration: 200 } }

                    Rectangle {
                        id: arrow
                        rotation: 45
                        width: 10 * fudge
                        height: 10 * fudge
                        x: (inout == "out") ? parent.width - 5  * fudge: -5 * fudge
                        y: 5 * fudge
                        color: parent.color
                    }

                    Label {
                        id: label
                        text: entry
                        wrapMode: Text.Wrap
                        width: chatItem.width - 30
                        x: 6
                        y: 6
                    }

                    MouseArea { anchors.fill: parent; onClicked: bubble.state = "rotated" }
                }
            }
        }

        ListView
        {
            id: chatList
            spacing: 8 * fudge
            //anchors.fill: parent
            width: parent.width
            height: parent.height - 42 * fudge * 3
            clip: true

            property bool completed: false
            Component.onCompleted:
            {
                var http = new XMLHttpRequest();

                http.open("POST", apiUrl + "getMessagesForUsers.php", true);
                http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http.onreadystatechange = function()
                {
                    if (http.readyState == 4 && http.status == 200)
                    {
                        var raw = JSON.parse(http.responseText);

                        for (var i = 0; i < raw.length; ++ i)
                            chatList.model.append({"inout": (raw[i].fromid !== facebook.profile.userId ? "in" : "out"), "entry": raw[i].message})

                        positionViewAtEnd();
                    }
                }
                http.send
                (
                    apiData
                    + "&fromid=" + facebook.profile.userId
                    + "&toid=" + userId
                );
            }

            model: ListModel
            {
                /*
                ListElement
                {
                    entry: "Bill Smith drgsd shnhsrfh srths rth rtshsh drgsd srths rth rtshsh drgsd shnhsrfh srths rth rtshsh drgsd srths rth rtshsh"
                    inout: "in"
                }
                */
            }

            delegate: chatDelegate

            MouseArea
            {
                anchors.fill: parent
                onClicked: Qt.inputMethod.hide();
            }
        }

        Row
        {
            spacing: 8 * fudge

            TextArea
            {
                id: chatEdit
                width: chat.width * 3/4
                height: 42 * fudge

                font.pointSize: 16 * fudge
                font.family: "FontAwesome"
                wrapMode: Text.Wrap

                style: TextFieldStyle
                {
                    textColor: "black"
                    background: Rectangle
                    {
                        radius: 5
                        color: "white"
                        implicitWidth: 100 * fudge
                        implicitHeight: 30 * fudge
                        border.width: 1
                        border.color: "darkgrey"
                    }
                }
            }

            Button
            {
                width: chat.width * 1/4 - 8 * fudge
                height: 42 * fudge

                style: ButtonStyle
                {
                    label: Text
                    {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 14 * fudge
                        text: "Send"
                    }

                    background: Rectangle
                    {
                        border.width: control.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 16 * fudge
                        gradient: Gradient
                        {
                            GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                            GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                        }
                    }
                }

                onClicked:
                {
                    if (chatEdit.text.length > 0)
                    {
                        var http = new XMLHttpRequest();

                        http.open("POST", apiUrl + "insertMessage.php", true);
                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http.onreadystatechange = function()
                        {
                            if (http.readyState == 4 && http.status == 200)
                            {
                                chatList.model.append({"inout":"out", "entry": chatEdit.text})
                                chatList.positionViewAtEnd()
                                chatEdit.text = ""
                                stackView.pop()
                            }
                        }
                        http.send
                        (
                            apiData
                            + "&fromid=" + facebook.profile.userId
                            + "&toid=" + userId
                            + "&message=" + encodeURIComponent(chatEdit.text)
                        );
                    }
                }
            }
        }
    }
}
