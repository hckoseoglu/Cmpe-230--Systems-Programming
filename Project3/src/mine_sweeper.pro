TEMPLATE = app
TARGET = name_of_the_app

QT = core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

SOURCES += \
    cell.cpp \
    cellbutton.cpp \
    main.cpp \
    main_layout.cpp

HEADERS += \
    cell.h \
    cellbutton.h \
    main_layout.h

DISTFILES += \
    assets/0.png \
    assets/1.png \
    assets/10.png \
    assets/11.png \
    assets/12.png \
    assets/2.png \
    assets/3.png \
    assets/4.png \
    assets/5.png \
    assets/6.png \
    assets/7.png \
    assets/8.png \
    assets/9.png \
    assets/wrong-flag.png
