/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0


import VPlayPlugins 1.0

IOSPage
{
    id: checkout

    property alias model: checkoutList.model

    width: parent.width
    height: parent.height

    property string userId;

    signal selected(string name, var latitude, var longitude);

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

        TextField
        {
            id: checkoutEdit
            width: checkout.width
            height: 42 * fudge

            font.pointSize: 16 * fudge
            font.family: "FontAwesome"
            //wrapMode: Text.Wrap

            style: TextFieldStyle
            {
                textColor: "black"
                background: Rectangle
                {
                    radius: 16 * fudge
                    color: "white"
                    implicitWidth: 100 * fudge
                    implicitHeight: 30 * fudge
                    border.width: 1
                    border.color: "darkgrey"
                }
            }

            onTextChanged:
            {
                model.clear();
                model.append({name: "Current Location", latitude: coordinate.latitude, longitude: coordinate.longitude});

                facebook.getGraphRequest("search", {q: text, type: "place", center: coordinate.latitude + "," + coordinate.longitude, limit: "10", fields: "id"})
            }

            Component.onCompleted: facebook.getGraphRequestFinished.connect(requestFinished)
            Component.onDestruction: facebook.getGraphRequestFinished.disconnect(requestFinished)

            function requestFinished(graphPath, resultState, result)
            {
                if (resultState === Facebook.ResultOk)
                {
                    if (graphPath === "search")
                    {
                        var raw = JSON.parse(result);

                        for (var i = 0; i < raw.data.length; ++ i)
                            facebook.getGraphRequest(raw.data[i].id, {fields: 'name, location'})
                    }
                    else
                    {
                        var raw = JSON.parse(result);

                        if (raw.name && raw.location && raw.location.latitude && raw.location.longitude)
                            model.append({name: raw.name, latitude: raw.location.latitude, longitude: raw.location.longitude});
                    }
                }
                else if (resultState === Facebook.ResultInvalidSession)
                {
                    console.error("Facebook: No active session, call openSession beforehand.");
                }
                else
                {
                    console.error("Facebook: There was an error retrieving the friend list.");
                }
            }
        }

/*
        Button
        {
            width: checkout.width * 1/4 - 8 * fudge
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
        }
*/

        ListView
        {
            id: checkoutList
            spacing: 8 * fudge
            //anchors.fill: parent
            width: parent.width
            height: parent.height - 42 * fudge * 2 - Theme.statusBarHeight
            clip: true

            //onCurrentItemChanged: checkoutEdit.text = currentItem.text

            model: ListModel
            {
                id: listmodel

                property string text: name;
                property var latitude: latitude;
                property var longitude: longitude;
            }

            delegate: Item
            {
                width: parent.width - 4 * fudge
                height: 42 * fudge

                Rectangle
                {
                    id: rectangle

                    anchors.fill: parent

                    Label
                    {
                        anchors.fill: parent
                        text: name
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            checkout.selected(name, latitude, longitude)
                        }
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

/*
            MouseArea
            {
                anchors.fill: parent
                onClicked: Qt.inputMethod.hide();
            }
*/
        }
    }
}
