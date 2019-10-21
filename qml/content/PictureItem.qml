/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1


Item
{
    id: root
    width: parent.width
    height: parent.height

    property alias list: list

    //property Item pictureMenu: PictureMenu {}

    Column
    {
        anchors.fill: parent

        Row
        {
            width: parent.width
            height: 42 * fudge

            Button
            {
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
            height: parent.height - 42 * fudge

            onDropClicked:
            {
                var http = new XMLHttpRequest();

                http.open("POST", apiUrl + "deleteUserImage.php", true);
                http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http.onreadystatechange = function()
                {
                    if (http.readyState == 4 && http.status == 200)
                    {
                    }
                }
                http.send(apiData + "&imageid=" + id);
            }
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
                    var http = new XMLHttpRequest();

                    http.open("POST", apiUrl + "insertUserImage.php", true);
                    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http.onreadystatechange = function()
                    {
                        if (http.readyState == 4 && http.status == 200)
                        {
                            var raw = JSON.parse(http.responseText);

                            list.model.append({dropShown: true, id: raw.imageid, imageId: raw.imageid, albumModel: [{imageId: raw.imageid, imageUrl: "image://votes/" + raw.imageid, imageBlur: 0}], ratioText: ""});
                            list.container.positionViewAtEnd();
                        }
                    }
                    http.send
                    (
                        apiData
                        + "&userid=" + facebook.profile.userId
                        + "&image=" + encodeURIComponent(imagefactory.toBase64(path))
                    );
                }
            }
            onImagePickerFinished:
            {
                if (accepted)
                {
                    var http = new XMLHttpRequest();

                    http.open("POST", apiUrl + "insertUserImage.php", true);
                    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    http.onreadystatechange = function()
                    {
                        if (http.readyState == 4 && http.status == 200)
                        {
                            var raw = JSON.parse(http.responseText);

                            list.model.append({dropShown: true, id: raw.imageid, imageId: raw.imageid, albumModel: [{imageId: raw.imageid, imageUrl: "image://votes/" + raw.imageid, imageBlur: 0}], ratioText: ""});
                            list.container.positionViewAtEnd();
                        }
                    }
                    http.send
                    (
                        apiData
                        + "&userid=" + facebook.profile.userId
                        + "&image=" + encodeURIComponent(imagefactory.toBase64(path))
                    );
                }
            }
        }
    }
}
