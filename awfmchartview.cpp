#include "awfmchartview.h"

#include <QApplication>
#include <QtCharts/QLineSeries>
#include <QtCharts/QAreaSeries>
#include <QFlags>
#include <QMessageBox>
#include <QPoint>
#include <QValueAxis>
#include <QRubberBand>

using namespace QtCharts;

AWFMChartView::AWFMChartView()
    : QChartView()
{
    windowEditingModeOn_ = false;
    windowStartLine_ = new QLineSeries();
    windowEndLine_ = new QLineSeries();
}

double AWFMChartView::mouseEventToChartTime(QMouseEvent *evt)
{
    chart()->mapToValue(
        chart()->mapFromScene(
                    mapToScene(evt->pos()))).x();
}

bool AWFMChartView::altKeyPressed()
{
    Qt::KeyboardModifiers mods = QApplication::queryKeyboardModifiers();
    return mods.testFlag(Qt::AltModifier);
}

bool AWFMChartView::ctrlKeyPressed()
{
    Qt::KeyboardModifiers mods = QApplication::queryKeyboardModifiers();
    return mods.testFlag(Qt::ControlModifier);
}

void AWFMChartView::drawVerticalLine(double t, int count)
{
    QValueAxis *yaxis = (QValueAxis*) chart()->axisY();

    QLineSeries *series_selected =
            count == 0 ? windowStartLine_
                       : windowEndLine_;
    series_selected->clear();
    series_selected->append(t, yaxis->min());
    series_selected->append(t, yaxis->max());
    series_selected->setColor(QColor(50, 150, 50, 220));

    chart()->addSeries(series_selected);
    series_selected->attachAxis(chart()->axisX());
    series_selected->attachAxis(chart()->axisY());
}

//void AWFMChartView::drawNewWindow()
//{
//    QValueAxis *yaxis = (QValueAxis*) chart()->axisY();

//    QLineSeries *upper_series = new QLineSeries();
//    QLineSeries *lower_series = new QLineSeries();

//    lower_series->append(windowStart_, yaxis->min());
//    lower_series->append(windowEnd_, yaxis->min());

//    upper_series->append(windowStart_, yaxis->max());
//    upper_series->append(windowEnd_, yaxis->max());

//    QAreaSeries* area_series = new QAreaSeries();
//    area_series->setLowerSeries(lower_series);
//    area_series->setUpperSeries(upper_series);
//    area_series->setColor(QColor(50, 150, 50, 220));

//    chart()->addSeries(area_series);
//    area_series->attachAxis(chart()->axisX());
//    area_series->attachAxis(chart()->axisY());
//}

void AWFMChartView::drawWellWindows(awfm::Well *w)
{
    foreach(QAreaSeries *area_series, wellWindows_) {
        chart()->removeSeries(area_series);
    }
    wellWindows_.clear();

    QValueAxis *yaxis = (QValueAxis*) chart()->axisY();
    QPair<double, double> window;
    foreach(window, w->windows()) {
        double w0 = window.first;
        double wf = window.second;

        QLineSeries *upper_series = new QLineSeries();
        QLineSeries *lower_series = new QLineSeries();

        lower_series->append(w0, yaxis->min());
        lower_series->append(wf, yaxis->min());

        upper_series->append(w0, yaxis->max());
        upper_series->append(wf, yaxis->max());

        QAreaSeries *area_series = new QAreaSeries();
        area_series->setLowerSeries(lower_series);
        area_series->setUpperSeries(upper_series);
        area_series->setColor(QColor(50, 150, 50, 100));

        chart()->addSeries(area_series);
        area_series->attachAxis(chart()->axisX());
        area_series->attachAxis(chart()->axisY());

        wellWindows_.push_back(area_series);
    }
}

void AWFMChartView::setWindowStart(double t)
{
    windowStartSelected_ = true;
    windowStart_ = t;
    drawVerticalLine(t, 0);
}

void AWFMChartView::setWindowEnd(double t)
{
    windowEnd_ = t;
    drawVerticalLine(t, 1);


    windowStartSelected_ = false;

    chart()->removeSeries(windowStartLine_);
    chart()->removeSeries(windowEndLine_);

    emit windowInserted(windowStart_, windowEnd_);


}

void AWFMChartView::mouseDoubleClickEvent(QMouseEvent *evt)
{
    if (ctrlKeyPressed() && windowEditingModeOn()) {
        double t = mouseEventToChartTime(evt);
        if (!windowStartSelected_) {
            setWindowStart(t);
        } else {
            setWindowEnd(t);
        }
    } else if (altKeyPressed() && windowEditingModeOn()) {
        double t = mouseEventToChartTime(evt);
        emit windowDeleted(t);
    } else {
        QChartView::mouseDoubleClickEvent(evt);
    }
}

void AWFMChartView::mousePressEvent(QMouseEvent *evt)
{
    if (evt->button() == Qt::RightButton && windowEditingModeOn()) {
        if (windowStartSelected_) {
            chart()->removeSeries(windowStartLine_);
            windowStartSelected_ = false;
        }
    } else {
        QChartView::mousePressEvent(evt);
    }
}
