cmake_minimum_required(VERSION 2.8)

project(awfm_root C CXX Fortran)

subdirs(libs/awfm)
include_directories(${PROJECT_SOURCE_DIR}/libs/awfm/include)
link_directories(${PROJECT_SOURCE_DIR}/LibProject/src)

add_executable(${PROJECT_NAME} "main.cpp")
target_link_libraries(awfm_root awfm)
