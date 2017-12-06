TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.cpp \
    abstractaquiferdrawdownmodel.cpp \
    measure.cpp \
    well.cpp \
    timeseries.cpp \
    theis.cpp

HEADERS += \
    abstractaquiferdrawdownmodel.h \
    measure.h \
    well.h \
    timeseries.h \
    theis.h
