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
}
