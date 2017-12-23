#include <iostream>
#include <QApplication>

#include "mainwindow.h"
#include "testing.h"

using namespace std;

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    MainWindow m;
    m.show();

    app.exec();


//    awfm::Testing tests = awfm::Testing("/home/alan/Dev/awfm/awfm/testing");
//    tests.runTests();
//    return 0;


}
