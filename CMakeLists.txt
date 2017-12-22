cmake_minimum_required(VERSION 2.8)

project(awfm C CXX Fortran)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
find_package(Qt5Widgets)

set(NAME_SOURCES testing.cpp
    main.cpp
    mainwindow.cpp
    model.cpp
    theis.cpp
    io.cpp
    well.cpp
    timeseries.cpp
    specialfunctions.cpp
    abstractaquiferdrawdownmodel.cpp
    jacobwellloss.cpp
    jacobsimplifiedwellloss.cpp
    abstractwelllossmodel.cpp
    measure.cpp
    utility.cpp
    slatec.f
    temporaldomain.cpp
)

set(NAME_HEADERS measure.h
    specialfunctions.h
    io.h
    abstractaquiferdrawdownmodel.h
    abstractwelllossmodel.h
    jacobwellloss.h
    jacobsimplifiedwellloss.h
    model.h
    utility.h
    theis.h
    well.h
    testing.h
    timeseries.h
    mainwindow.h
    temporaldomain.h
)

add_executable(${PROJECT_NAME} ${NAME_SOURCES} ${NAME_HEADERS})
target_link_libraries(awfm Qt5::Widgets)
