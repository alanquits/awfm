#ifndef TESTING_H
#define TESTING_H

#include <string>

class Testing
{
private:
    std::string testDir_;

public:
    Testing(std::string testDir);

    void runTests();


    bool stdTest(bool comparison, std::string message);

    bool testWellFunction();
    bool timeseriesTest01();
    bool timeseriesTest02();
    bool testTheis01();
};

#endif // TESTING_H
