#ifndef AWFMCHARTVIEW_H
#define AWFMCHARTVIEW_H

#include <QList>
#include <QMouseEvent>
#include <QtCharts/QChartView>
#include <QtCharts/QAreaSeries>
#include <QRubberBand>

#include "well.h"

using namespace QtCharts;

class AWFMChartView : public QChartView {
    Q_OBJECT

    bool windowEditingModeOn_;
    bool windowStartSelected_;
    bool windowEndSelected_;

    double windowStart_;
    double windowEnd_;
    QLineSeries *windowStartLine_;
    QLineSeries *windowEndLine_;
    QList<QAreaSeries*> wellWindows_;

public:
    AWFMChartView();

    double mouseEventToChartTime(QMouseEvent *evt);
    bool altKeyPressed();
    bool ctrlKeyPressed();
    void drawVerticalLine(double t, int count);
    void drawNewWindow();

    void setWindowStart(double t);
    void setWindowEnd(double t);
    void setWindowEditingModeOn(bool mode_on) { windowEditingModeOn_ = mode_on; }
    bool windowEditingModeOn() { return windowEditingModeOn_; }

    virtual void mouseDoubleClickEvent(QMouseEvent *evt);
    virtual void mousePressEvent(QMouseEvent* evt);

signals:
    void windowInserted(double t0, double tf);
    void windowDeleted(double t);

public slots:
    void drawWellWindows(awfm::Well *w);
};

#endif
