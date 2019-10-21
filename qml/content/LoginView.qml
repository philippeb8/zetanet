/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0

Item {
  anchors.fill: parent

/*
  Image {
      id: image
      anchors.fill: parent
      source: "http://www.finitetheory.cqrc:/qml/images/author-Phil-bouchard.jpg"
      fillMode: Image.PreserveAspectCrop
      visible: false
  }

  Rectangle {
      id: mask
      anchors { fill: parent; margins: 18 * fudge }
      color: "black"
      radius: 0.5 * width
      clip: true
      visible: false
  }

  OpacityMask {
      anchors.fill: mask
      source: image
      maskSource: mask
  }
*/

  // Login button
  Button {
    anchors.centerIn: parent

    text: "Login with Facebook"

    onClicked: {
      facebook.openSession()
    }
  }
}
