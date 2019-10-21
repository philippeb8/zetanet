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
    height: 40 * fudge + (topButton.visible ? topButton.height : 0) + album.height + (text.visible ? text.height : 0) + (vote.visible ? vote.height : 0)  + (more.visible ? more.height : 0) + (chat.visible ? chat.height : 0) + (ratio.visible ? ratio.height : 0)

    property bool flipped: false
    property bool albumMaximised: true

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

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        //border.width: 1
        //border.color: "darkgrey"

        Column
        {
            padding: 8 * fudge
            spacing: 8 * fudge

            Row
            {
                height: 50 * fudge

                Label
                {
                    id: subject
                    width: item.width - 42 * fudge - 8 * fudge * 2
                    text: subjectString
                    font.pointSize: 16 * fudge
                    font.family: "FontAwesome"
                    visible: hideItem.visible || dropItem.visible
                    color: "black"
                    wrapMode: Text.Wrap

                    MouseArea
                    {
                        id: subjectMouse
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        anchors.fill: parent;
                        onClicked: subjectClicked(userId);
                    }
                }

                Button
                {
                    id: topButton
                    width: 42 * fudge
                    height: 42 * fudge
                    //anchors.right: parent.right
                    visible: hideItem.visible || dropItem.visible

                    style: ButtonStyle
                    {
                        label: Text
                        {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 14 * fudge
                            font.family: "FontAwesome"
                            text: "\uf05e"
                            color: "darkred"
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

                    menu: Menu
                    {
                        style: MenuStyle
                        {
                            itemDelegate.label: Text
                            {
                                renderType: Text.NativeRendering
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 14 * fudge
                                font.family: "FontAwesome"
                                text: styleData.text
                            }
                        }

                        MenuItem
                        {
                            id: hideItem
                            text: "Hide user"
                            visible: blockShown

                            onTriggered:
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
                        }

                        MenuItem
                        {
                            id: dropItem
                            text: "Delete record"
                            visible: dropShown

                            onTriggered:
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
                        }
                    }
                }
            }

            ProfileListAlbum
            {
                id: album
                width: (albumMaximised ? item.width : item.parent.width / 2 - 4 * fudge) - 8 * fudge * 2
                height: albumModel.count === 0 ? 0 : width
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Flipable
            {
                id: vote
                width: item.width - 8 * fudge * 2
                height: 42 * fudge
                visible: voteShown

                property bool flipped: false

                front: Button
                {
                    id: bottomButton
                    anchors.fill: parent

                    style: ButtonStyle
                    {
                        label: Text
                        {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 14 * fudge
                            font.family: "FontAwesome"
                            text: "Categorize / Report"
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

                    menu: Menu
                    {
                        style: MenuStyle
                        {
                            itemDelegate.label: Text
                            {
                                renderType: Text.NativeRendering
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 14 * fudge
                                font.family: "FontAwesome"
                                text: styleData.text
                            }
                        }

                        MenuItem
                        {
                            text: "Complete"
                            onTriggered: vote.flipped = !vote.flipped
                        }

                        MenuItem
                        {
                            text: "Sexy"
                            onTriggered: vote.flipped = !vote.flipped
                        }

                        MenuItem
                        {
                            text: "Face"
                            onTriggered: vote.flipped = !vote.flipped
                        }

                        MenuItem
                        {
                            text: "Sunglasses"
                            onTriggered: vote.flipped = !vote.flipped
                        }

                        MenuSeparator { }

                        MenuItem
                        {
                            text: "Meme"
                            onTriggered: vote.flipped = !vote.flipped
                        }

                        MenuItem
                        {
                            text: "Multiple people"
                            onTriggered: vote.flipped = !vote.flipped
                        }
                    }
                }

                back: LinearGradient
                {
                    start: Qt.point(0, 0)
                    end: Qt.point(parent.width, 0)
                    anchors.fill: parent

                    gradient: Gradient
                    {
                        GradientStop { position: 0.0; color: "#FF0000" }
                        GradientStop { position: 0.5; color: "transparent" }
                        GradientStop { position: 1.0; color: "#00FF00" }
                    }

                    Row
                    {
                        Repeater
                        {
                            model: 2

                            Rectangle
                            {
                                width: (item.width - 8 * fudge * 2) / 2
                                height: 42 * fudge
                                anchors.verticalCenter: parent.verticalCenter
                                color: "transparent"

                                Text
                                {
                                    text: index === 0 ? "Dislike" : "Like"
                                    font.pointSize: 16 * fudge
                                    font.family: "FontAwesome"
                                    //color: Qt.rgba(1 - index / 10, index / 10, 0, 1)
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                MouseArea
                                {
                                    hoverEnabled: true
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    anchors.fill: parent;
                                    onClicked:
                                    {
                                        item.flipped = true;
                                        container.parent.voteClicked(album.model.get(0).imageId, index);
                                    }
                                }
                            }
                        }
                    }
                }

                transform: Rotation {
                    id: rotationVote
                    origin.x: vote.width/2
                    origin.y: vote.height/2
                    axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                    angle: 0    // the default angle
                }

                states: State {
                    name: "back"
                    PropertyChanges { target: rotationVote; angle: 180 }
                    when: vote.flipped
                }

                transitions: Transition {
                    NumberAnimation { target: rotationVote; property: "angle"; duration: 500 }
                }
            }

            Rectangle
            {
                id: ratio
                visible: ratioShown

                width: item.width - 8 * fudge * 2
                height: 14 * fudge
                color: "transparent"

                Text
                {
                    text: ratioText
                    font.pointSize: 16 * fudge
                    font.family: "FontAwesome"
                    color: "darkred"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Label
            {
                id: text
                width: item.width - 8 * fudge * 2
                text: textString
                font.pointSize: 12 * fudge
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

            Button
            {
                id: more
                width: item.width - 8 * fudge * 2
                height: 42 * fudge
                visible: moreShown

                style: ButtonStyle
                {
                    label: Text
                    {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 14 * fudge
                        font.family: "FontAwesome"
                        text: ">>"
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

                onClicked: stackView.push(Qt.resolvedUrl("qrc:/qml/content/PurchasePostPage.qml"), {pushTransition: stackView.transitionSlideFromRight, popTransition: stackView.transitionSlideToRight, id: id, userId: userId, subjectString: subjectString, textString: textString, albumModel: albumModel})

                //onClicked: Qt.openUrlExternally(textString);
            }

            Button
            {
                id: chat
                visible: chatShown
                width: item.width - 8 * fudge * 2
                height: 42 * fudge

                style: ButtonStyle
                {
                    label: Text
                    {
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 14 * fudge
                        font.family: "FontAwesome"
                        text: "Chat"
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
                    stackView.push(Qt.resolvedUrl("qrc:/qml/content/ChatPage.qml"), {userId: userId, pushTransition: stackView.transitionSlideFromBottom, popTransition: stackView.transitionSlideToBottom});
                }
            }

/*
                Rectangle
                {
                    width: (item.width-68)/4
                    height: 14 * fudge
                    color: "transparent"

                    Text
                    {
                        text: "\uf041 Directions"
                        font.pointSize: 14
                        font.family: "FontAwesome"
                        color: "darkgray"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MouseArea
                    {
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        anchors.fill: parent;
                        onClicked:
                        {
                            Qt.openUrlExternally("geo:%1,%2".arg(latitude).arg(longitude))
                        }
                    }
                }
*/
        }
    }

    DropShadow
    {
        anchors.fill: rectangle
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "darkgrey"
        source: rectangle
    }
}
