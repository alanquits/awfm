#include "testing.h"

#include <cassert>
#include <iostream>

#include "specialfunctions.h"
#include "theis.h"
#include "timeseries.h"
#include "well.h"

namespace awfm {

    Testing::Testing(std::string testDir)
    {
        testDir_ = testDir;
    }

    void Testing::runTests()
    {
        if (!testWellFunction()) { return ; }
        if (!timeseriesTest01()) { return ; }
        if (!timeseriesTest02()) { return ; }
        if (!testTheis01()) { return ; }
    }

    bool Testing::stdTest(bool comparison, std::string message)
    {
        if (comparison) {
            std::cout << "PASSED: " << message << "\n";
            return true;
        } else {
            std::cout << "FAILED: " << message << "\n";
            return false;
        }
    }

    bool Testing::testWellFunction()
    {
        return stdTest(Utility::floatCompare(W(1.0), 0.219, 1e-2),
                "W(1.0) == 0.219");
    }

    bool Testing::timeseriesTest01()
    {
        Timeseries ts1 = Timeseries();
        ts1.readFromFile(testDir_ + "/timeseriestest01_in.dat");
        ts1.zeroBelow(100);
        ts1.consolidateZeros();
        ts1.averageBySign();

        Timeseries ts2 = Timeseries();
        ts2.readFromFile(testDir_ + "/timeseriestest01_out.dat");

        return stdTest(ts1.isEqual(ts2),
            "timeseriestest01_in.dat > timeseries01_out.dat");

    }

    bool Testing::timeseriesTest02()
    {
        Timeseries ts1 = Timeseries();
        ts1.readFromFile(testDir_ + "/timeseriestest02_in.dat");
        ts1.zeroBelow(50);
        ts1.consolidateZeros();
        ts1.averageBySign();

        Timeseries ts2 = Timeseries();
        ts2.readFromFile(testDir_ + "/timeseriestest02_out.dat");

        return stdTest(ts1.isEqual(ts2),
            "timeseriestest02_in.dat > timeseries02_out.dat");

        return true;
    }

    bool Testing::testTheis01()
    {
        Well w = Well("Well-A", 824, 0, 1.0, 1000);
        Theis model = Theis(2.4e-5, 1400.0);
        Timeseries ts_Q = Timeseries();
        ts_Q.append(0.0, 42350.0);
        w.setQ(ts_Q);

        Timeseries ts_obs_drawdown = Timeseries();
        ts_obs_drawdown.readFromFile(testDir_ + "/theistest01_in.dat");

        Timeseries ts_out;

        for (size_t i = 0; i < ts_obs_drawdown.size(); i++) {
            double t = ts_obs_drawdown.t(i);
            double s = model.drawdownAtWell(w, 0, 0, t);
            ts_out.append(t, s);
        }

        return stdTest(ts_obs_drawdown.isEqual(ts_out, 1.0),
            "Fetter pg. 172");
    }
}
