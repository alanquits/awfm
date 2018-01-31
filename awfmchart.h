#ifndef AWFMCHART_H
#define AWFMCHART_H

#include <QtCharts/QChart>

using namespace QtCharts;

class AWFMChart : public QChart {
    virtual void zoomIn(const QRectF &rect);
    virtual void zoomOut();
};

#endif
