enable_language(Fortran)
include_directories(${PROJECT_SOURCE_DIR}/libs/awfm/include)

# Next two lines are only here to show headers in Qt project view
FILE(GLOB_RECURSE LibFiles ${PROJECT_SOURCE_DIR}/libs/awfm/include/*.h)
add_custom_target(headers SOURCES ${LibFiles})


add_library(awfm
    abstractaquiferdrawdownmodel.cpp
    io.cpp
    measure.cpp
    slatec.f
    specialfunctions.cpp
    testing.cpp
    theis.cpp
    timeseries.cpp
    utility.cpp
    well.cpp)
