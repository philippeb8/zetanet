TEMPLATE = app

QT += qml quick positioning multimedia

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

DEFINES  += HAVE_CONFIG_H

SOURCES += main.cpp \
    imagefactory.cpp

RESOURCES += qml.qrc

ios
{
    QMAKE_TARGET_BUNDLE_PREFIX = "org.zetanet"
    TARGET = zetanet
}

android
{
}

# Default rules for deployment.
include(deployment.pri)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml

HEADERS += \
    imagefactory.h \
    imageprovider.h

DISTFILES += \
    qml/config.json
