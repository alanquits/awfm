#ifndef TESTING_H
#define TESTING_H

#include "dbio.h"
#include <QString>

namespace awfm {
    class Testing
    {
    private:
        QString testDir_;

    public:
        Testing(QString testDir);

        void runTests();


        bool stdTest(bool comparison, QString message);

        bool createDatabase();
        bool testWellFunction();
        bool timeseriesTest01();
        bool timeseriesTest02();
        bool testTheis01();
    };
}

#endif // TESTING_H
