#ifndef VIEWTIMESERIESWIDGET_H
#define VIEWTIMESERIESWIDGET_H

#include "model.h"
#include <QWidget>
#include <QtCharts/QChartView>

class QCheckBox;
class QListWidget;

using namespace QtCharts;

class ViewTimeseriesWidget : public QWidget {
    Q_OBJECT
private:

    awfm::Model *model;
    QListWidget *wellList;
    QCheckBox *observedPumpingRatesCheckBox;
    QCheckBox *observedWaterLevelsCheckBox;
    QCheckBox *ModeledWaterLevelsCheckBox;
    QChartView *chartView;

public:
    ViewTimeseriesWidget();
    void initWidgets();
    void initLayout();
    void setModel(awfm::Model *m);
    int wellIndex();

public slots:
    void drawChart();
    void wellSelectionChanged(int);
};

#endif
