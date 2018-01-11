cmake_minimum_required(VERSION 2.8)

project(awfm C CXX Fortran)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
find_package(Qt5Widgets)
find_package(Qt5Sql REQUIRED)

set(NAME_SOURCES
#    testing.cpp
    aquiferdrawdowndlg.cpp
    awfmtablewidget.cpp
    sqlitedataframe.cpp
    main.cpp
    mainwindow.cpp
    model.cpp
    theis.cpp
#    io.cpp
    well.cpp
    timeseries.cpp
    pumpingratesdlg.cpp
    specialfunctions.cpp
    abstractdataframe.cpp
    abstractaquiferdrawdownmodel.cpp
    dbio.cpp
    editwellsdlg.cpp
    importdlg.cpp
    modelio.cpp
    jacobwellloss.cpp
    jacobsimplifiedwellloss.cpp
    abstractwelllossmodel.cpp
    measure.cpp
    utility.cpp
    slatec.f
    temporaldomain.cpp
    timeseriesplotwidget.cpp
    resources/create_db.cpp
)

set(NAME_HEADERS measure.h
    aquiferdrawdowndlg.h
    specialfunctions.h
#    io.h
    sqlitedataframe.h
    abstractaquiferdrawdownmodel.h
    abstractdataframe.h
    abstractwelllossmodel.h
    awfmtablewidget.h
    dbio.h
    definitions.h
    editwellsdlg.h
    importdlg.h
    jacobwellloss.h
    jacobsimplifiedwellloss.h
    model.h
    pumpingratesdlg.h
    utility.h
    theis.h
    well.h
#    testing.h
    timeseries.h
    mainwindow.h
    modelio.h
    temporaldomain.h
    timeseriesplotwidget.h
    resources/create_db.h
)

add_subdirectory("libs/sqlite3")

INCLUDE_DIRECTORIES ("thirdparty/fast-cpp-csv-parser-master")

add_executable(${PROJECT_NAME} ${NAME_SOURCES} ${NAME_HEADERS})
target_link_libraries(awfm Qt5::Widgets Qt5::Sql pthread sqlite3 )
