/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQml 2.2
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0

IOSPage
{
    id: root
    width: parent.width
    height: parent.height

    signal refresh();

    Column
    {
        anchors.fill: parent;

        DoneToolBarItem
        {
            width: parent.width
            height: 42 * fudge

            function nl2br(str)
            {
                var breakTag = '<br>';
                return (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + breakTag + '$2');
            }

            onRefresh:
            {
                var imageid = [];

                // post images
                for (var i = 0; i < list.container.model.count; ++ i)
                {
                    var http1 = new XMLHttpRequest();

                    http1.open("POST", hostUrl + "insertimage", false);
                    http1.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http1.onreadystatechange = function()
                    {
                        if (http1.readyState === XMLHttpRequest.DONE && http1.status === 200)
                        {
                            var raw = JSON.parse(http1.responseText);

                            imageid[i] = raw.imageid;
                        }
                    }
                    http1.send
                    (
                        "image=" + encodeURIComponent(imagefactory.toBase64(list.container.model.get(i).albumModel.get(0).imageUrl))
                    );
                }

                // post html
                var siteid = -1;
                var http2 = new XMLHttpRequest();

                http2.open("POST", hostUrl + "insertsite", false);
                http2.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http2.onreadystatechange = function()
                {
                    if (http2.readyState === XMLHttpRequest.DONE && http2.status === 200)
                    {
                        var raw = JSON.parse(http2.responseText);

                        siteid = raw.siteid;
                    }
                }
                http2.send
                (
                );

                if (siteid !== -1)
                {
                    var html = "";
                    var http5 = new XMLHttpRequest();

                    http5.open("POST", hostUrl + "generatesite", false);
                    http5.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http5.onreadystatechange = function()
                    {
                        if (http5.readyState === XMLHttpRequest.DONE && http5.status === 200)
                        {
                            html = http5.responseText;
                        }
                    }
                    http5.send
                    (
                        "siteid=" + siteid
                        + "&imageid=" + encodeURIComponent(imageid.join(" "))
                        + "&title=" + encodeURIComponent(title.text)
                        + "&address=" + encodeURIComponent(address.text)
                        + "&latitude=" + coordinate.latitude
                        + "&longitude=" + coordinate.longitude
                        + "&email=" + encodeURIComponent(email.text)
                        + "&body=" + encodeURIComponent(body.text)
                    );

                    var http3 = new XMLHttpRequest();

                    http3.open("POST", hostUrl + "updatesite", false);
                    http3.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http3.onreadystatechange = function()
                    {
                        if (http3.readyState === XMLHttpRequest.DONE && http3.status === 200)
                        {
                        }
                    }
                    http3.send
                    (
                        "siteid=" + siteid
                        + "&email=" + encodeURIComponent(email.text)
                        + "&html=" + encodeURIComponent(html)
                    );

                    // index
                    var http4 = new XMLHttpRequest();

                    http4.open
                    (
                        "GET",
                        apiUrl
                        + "insert"
                        + "?address=" + encodeURIComponent(address.text)
                        + "&lat=" + coordinate.latitude
                        + "&lng=" + coordinate.longitude
                        + "&expiration=" + (doe.text !== "" || toe.text !== "" ? encodeURIComponent(doe.text + " " + toe.text) : "")
                        + "&url=" + encodeURIComponent(hostUrl + "getsite?siteid=" + siteid),
                        false
                    );
                    http4.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http4.onreadystatechange = function()
                    {
                        if (http4.readyState === XMLHttpRequest.DONE && http4.status === 200)
                        {
                        }
                    }
                    http4.send();
                }

                root.refresh();
            }
        }

        Flickable
        {
            width: parent.width
            height: parent.height - 42 * fudge
            //horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            contentWidth: parent.width
            contentHeight: email.height + address.height + doe.height + toe.height + title.height + body.height + button.height + list.height + 8 * fudge * 10
            clip: true

            MouseArea
            {
                anchors.fill: parent
                onClicked: Qt.inputMethod.hide();
            }

            Column
            {
                anchors.fill: parent;
                spacing: 8 * fudge

                MessageItem
                {
                    id: email
                    height: 42 * fudge

                    placeholderText: "Email address"
                }

                MessageItem
                {
                    id: address
                    height: 42 * fudge

                    placeholderText: "Current location, address or place"
                }

                Row
                {
                    width: parent.width
                    height: 42 * fudge

                    MessageItem
                    {
                        id: doe
                        width: parent.width - 42 * fudge
                        height: parent.height

                        placeholderText: "Date of expiration (YYYY-MM-DD)"
                    }

                    Button
                    {
                        width: 42 * fudge
                        height: parent.height

                        style: ButtonStyle
                        {
                            label: Text
                            {
                                renderType: Text.NativeRendering
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 14 * fudge
                                text: "..."
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

                        onClicked: calendar.open();
                    }
                }

                MessageItem
                {
                    id: toe
                    height: 42 * fudge

                    placeholderText: "Time of expiration (00:00:00)"
                }

                MessageItem
                {
                    id: title
                    height: 42 * fudge

                    placeholderText: "Title"
                }

                TextArea
                {
                    id: body
                    width: parent.width
                    height: 200 * fudge

                    font.pointSize: 16 * fudge
                    font.family: "FontAwesome"
                    font.italic: true
                    wrapMode: Text.Wrap
                    backgroundVisible: false

                    style: TextAreaStyle
                    {
                        textColor: "black"
                        frame: Rectangle
                        {
                            radius: 16 * fudge
                            color: "white"
                            implicitWidth: 100 * fudge
                            implicitHeight: 30 * fudge
                            border.width: 1
                            border.color: "darkgrey"
                        }
                    }
                }

                Row
                {
                    width: parent.width
                    height: 42 * fudge

                    Button
                    {
                        id: button
                        width: parent.width
                        height: parent.height

                        style: ButtonStyle
                        {
                            label: Text
                            {
                                renderType: Text.NativeRendering
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 14 * fudge
                                text: "Add Picture"
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

                        onClicked: nativeUtils.displayAlertSheet("Select Picture", ["Camera", "Camera Roll"], true)
                    }
                }

                ProfileList
                {
                    id: list
                    width: parent.width
                    height: (40 * fudge + 42 * fudge + parent.width - 4 * fudge) * list.container.model.count
                }

                Connections
                {
                    target: nativeUtils

                    onAlertSheetFinished:
                    {
                        if (index == 0)
                            nativeUtils.displayCameraPicker("Take Picture")
                        else if (index == 1)
                            nativeUtils.displayImagePicker("Select Picture")
                    }
                    onCameraPickerFinished:
                    {
                        if (accepted)
                        {
                            list.model.append({moreShown: false, dropShown: true, userId: "", albumModel: [{imageId: 0, imageUrl: path, imageBlur: 0}]});
                            list.container.positionViewAtEnd();
                        }
                    }
                    onImagePickerFinished:
                    {
                        if (accepted)
                        {
                            list.model.append({moreShown: false, dropShown: true, userId: "", albumModel: [{imageId: 0, imageUrl: path, imageBlur: 0}]});
                            list.container.positionViewAtEnd();
                        }
                    }
                }
            }
        }
    }

    CalendarDialog
    {
        id: calendar
        width: parent.width
        minimumDate: new Date();

        onClicked:
        {
            doe.text = Qt.formatDate(date, Qt.ISODate);
        }
    }
}
