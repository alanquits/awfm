#ifndef VIEWTIMESERIESWIDGET_H
#define VIEWTIMESERIESWIDGET_H

#include "awfmchartview.h"
#include "model.h"

#include <QWidget>
#include <QtCharts/QChartView>
#include <QtCharts/QLineSeries>
#include <QtCharts/QValueAxis>

class QCheckBox;
class QListWidget;
class QMouseEvent;

using namespace QtCharts;

class ViewTimeseriesWidget : public QWidget {
    Q_OBJECT
private:

    awfm::Model *model;
    QListWidget *wellList;
    QCheckBox *observedPumpingRatesCheckBox;
    QCheckBox *observedWaterLevelsCheckBox;
    QCheckBox *ModeledWaterLevelsCheckBox;
    AWFMChartView *chartView;

public:
    ViewTimeseriesWidget();

    AWFMChartView* chartViewRef() { return chartView; }
    void axisExtent(double min_v, double max_v, double &axis_min, double &axis_max, int &axis_ticks);
    double roundToNearest(double n, double exp);
    void initWidgets();
    void initLayout();
    void setModel(awfm::Model *m);
    void wellTimeRange(awfm::Well *w, double &min_t, double &max_t);
    void pumpingSeries(QLineSeries* series, QLineSeries *zero_series, awfm::Timeseries q);
    int wellIndex();
    void setWindowEditingModeOn(bool mode_on);

    virtual void mousePressEvent(QMouseEvent *evt);


public slots:
    void drawChart();
    void wellSelectionChanged(int);

signals:
    void wellSelectChangedSignal(int);
};

#endif
