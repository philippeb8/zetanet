/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.0
import QtMultimedia 5.4

FocusScope {
    property Camera camera
    property bool previewAvailable : false

    signal previewSelected
    signal videoModeSelected
    id : captureControls

    Rectangle {
        id: buttonPaneShadow
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right
        color: "transparent"

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.margins: 8 * fudge

            id: buttonsColumn
            spacing: 8 * fudge

            FocusButton {
                camera: captureControls.camera
                visible: camera.cameraStatus == Camera.ActiveStatus && camera.focus.isFocusModeSupported(Camera.FocusAuto)
            }

            CameraPropertyButton {
                id : wbModesButton
                value: CameraImageProcessing.WhiteBalanceAuto
                model: ListModel {
                    ListElement {
                        icon: "qrc:/qml/images/camera_auto_mode.png"
                        value: CameraImageProcessing.WhiteBalanceAuto
                        text: "Auto"
                    }
                    ListElement {
                        icon: "qrc:/qml/images/camera_white_balance_sunny.png"
                        value: CameraImageProcessing.WhiteBalanceSunlight
                        text: "Sunlight"
                    }
                    ListElement {
                        icon: "qrc:/qml/images/camera_white_balance_cloudy.png"
                        value: CameraImageProcessing.WhiteBalanceCloudy
                        text: "Cloudy"
                    }
                    ListElement {
                        icon: "qrc:/qml/images/camera_white_balance_incandescent.png"
                        value: CameraImageProcessing.WhiteBalanceTungsten
                        text: "Tungsten"
                    }
                    ListElement {
                        icon: "qrc:/qml/images/camera_white_balance_flourescent.png"
                        value: CameraImageProcessing.WhiteBalanceFluorescent
                        text: "Fluorescent"
                    }
                }
                onValueChanged: captureControls.camera.imageProcessing.whiteBalanceMode = wbModesButton.value
            }

            CameraButton {
                text: "View"
                onClicked: captureControls.previewSelected()
                visible: captureControls.previewAvailable
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.margins: 8 * fudge

            id: bottomColumn
            spacing: 8 * fudge

/*
            CameraButton {
                text: "Switch to Video"
                onClicked: captureControls.videoModeSelected()
            }
*/
            CameraButton {
                id: quitButton
                text: "Cancel"
                onClicked: stackView.pop()
            }

            Rectangle
            {
                visible: camera.imageCapture.ready
                width: 50 * fudge
                height: width
                radius: width * 0.5
                color: "white"
                border.color: "#32b2e2"
                border.width: 2 * fudge

                MouseArea {
                    anchors.fill: parent
                    onClicked: camera.imageCapture.capture()
                }
            }

            CameraListButton {
                model: QtMultimedia.availableCameras
                onValueChanged: captureControls.camera.deviceId = value
            }
        }
    }

    ZoomControl {
        x : 0
        y : 0
        width : 100 * fudge
        height: parent.height

        currentZoom: camera.digitalZoom
        maximumZoom: Math.min(4.0, camera.maximumDigitalZoom)
        onZoomTo: camera.setDigitalZoom(value)
    }
}
