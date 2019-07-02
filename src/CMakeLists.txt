cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
#list(APPEND CMAKE_PREFIX_PATH "/opt/qt5/5.13.0/gcc_64/lib/cmake")


find_package(Qt5 COMPONENTS Core Quick QuickControls2 Network Positioning Charts REQUIRED)
set(this EventAPP)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(MSVC)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++17")
endif(MSVC)


include_directories(${Qt5Widgets_INCLUDE_DIRS} ${QtQml_INCLUDE_DIRS})
qt5_add_resources(QT_RESOURCES ../qml/qml.qrc)
if(NOT DEFINED HEADERS)
    file(GLOB HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/*.hpp)
endif()
if(NOT DEFINED SOURCES)
    file(GLOB SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
endif()
source_group("Header Files" FILES ${HEADERS})
source_group("Source Files" FILES ${SOURCES})

add_executable(${this} ${SOURCES} ${QT_RESOURCES})



target_link_libraries(${this} PRIVATE 
	Qt5::Core 
	Qt5::Quick 
	Qt5::QuickControls2
	Qt5::Network
	Qt5::Positioning
	Qt5::Charts
)
