TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.cpp \
    abstractaquiferdrawdownmodel.cpp \
    measure.cpp \
    well.cpp \
    timeseries.cpp \
    theis.cpp \
    io.cpp \
    specialfunctions.cpp \
    slatec.f \
    testing.cpp \
    utility.cpp

HEADERS += \
    abstractaquiferdrawdownmodel.h \
    measure.h \
    well.h \
    timeseries.h \
    theis.h \
    io.h \
    specialfunctions.h \
    testing.h \
    utility.h

LIBS += -lgfortran

DISTFILES += \
    slatec.f
