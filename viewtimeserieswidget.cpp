#include "viewtimeserieswidget.h"

#include <cmath>

#include <QtCharts/QChart>
#include <QtCharts/QChartView>
#include <QtCharts/QLineSeries>
#include <QtCharts/QScatterSeries>
#include <QtCharts/QAreaSeries>
#include <QtCharts/QValueAxis>

#include <QCheckBox>
#include <QGroupBox>
#include <QHBoxLayout>
#include <QListWidget>
#include <QVBoxLayout>

using namespace QtCharts;

ViewTimeseriesWidget::ViewTimeseriesWidget()
{
    initWidgets();
    initLayout();
}

void ViewTimeseriesWidget::axisExtent(double min_v, double max_v, double &axis_min, double &axis_max, int &axis_ticks)
{
    double dv = max_v - min_v;
    if (dv == 0) {
        axis_min = min_v - min_v*0.1;
        axis_max = max_v + max_v*0.1;
        axis_ticks = 3;
        return;
    }

    double exp = floor(log10(dv));
    double multiplier = pow(10, exp);
    axis_min = roundToNearest(min_v, multiplier);
    axis_max = roundToNearest(max_v, multiplier);
    if (axis_max < max_v) {
        axis_max += multiplier;
    }

    double new_dv = axis_max - axis_min;
    int ticks = new_dv/multiplier;

    if (ticks < 4) {
        ticks *= 2;
    }

    axis_ticks = ticks+1;
}

double ViewTimeseriesWidget::roundToNearest(double n, double exp)
{
    return round(n/exp) * exp;
}

void ViewTimeseriesWidget::initWidgets()
{
    wellList = new QListWidget();
    observedPumpingRatesCheckBox = new QCheckBox("Observed Pumping Rates");
    observedWaterLevelsCheckBox = new QCheckBox("Observed Water Levels");
    ModeledWaterLevelsCheckBox = new QCheckBox("Modeled Water Levels");

    observedPumpingRatesCheckBox->setChecked(true);
    observedWaterLevelsCheckBox->setChecked(true);
    ModeledWaterLevelsCheckBox->setChecked(true);
    chartView = new QChartView();

    connect(wellList, SIGNAL(currentRowChanged(int)),
            this, SLOT(wellSelectionChanged(int)));

    connect(observedPumpingRatesCheckBox, SIGNAL(stateChanged(int)),
            this, SLOT(drawChart()));

    connect(observedWaterLevelsCheckBox, SIGNAL(stateChanged(int)),
            this, SLOT(drawChart()));

    connect(ModeledWaterLevelsCheckBox, SIGNAL(stateChanged(int)),
            this, SLOT(drawChart()));
}

void ViewTimeseriesWidget::initLayout()
{
    QVBoxLayout *leftPanel = new QVBoxLayout();

    QGroupBox *wellsGroupBox = new QGroupBox("Wells");
    wellsGroupBox->setMaximumWidth(300);
    QVBoxLayout *wellsGroupBoxLayout = new QVBoxLayout();
    wellsGroupBoxLayout->addWidget(wellList);
    wellsGroupBox->setLayout(wellsGroupBoxLayout);
    leftPanel->addWidget(wellsGroupBox);


    QGroupBox *seriesGroupBox = new QGroupBox("Series");
    seriesGroupBox->setMaximumWidth(300);
    QVBoxLayout *seriesGroupBoxLayout = new QVBoxLayout();
    seriesGroupBoxLayout->addWidget(observedPumpingRatesCheckBox);
    seriesGroupBoxLayout->addWidget(observedWaterLevelsCheckBox);
    seriesGroupBoxLayout->addWidget(ModeledWaterLevelsCheckBox);
    seriesGroupBox->setLayout(seriesGroupBoxLayout);
    leftPanel->addWidget(seriesGroupBox);

    QHBoxLayout *mainLayout = new QHBoxLayout();
    mainLayout->addLayout(leftPanel);
    mainLayout->addWidget(chartView);
    setLayout(mainLayout);
}

void ViewTimeseriesWidget::setModel(awfm::Model *m)
{
    model = m;

    wellList->clear();
    QList<awfm::Well>* ws = m->wellsRef();
    for (size_t i = 0; i < ws->size(); i++) {
        awfm::Well *w = m->wellRef(i);
        wellList->addItem(w->name());
    }


}

void ViewTimeseriesWidget::wellTimeRange(awfm::Well *w, double &min_t, double &max_t)
{
    QList<awfm::Timeseries> timeseries_list;
    timeseries_list.append(w->q());
    timeseries_list.append(w->wl());
    bool no_timeseries_length = true;
    bool first = true;
    foreach (awfm::Timeseries ts, timeseries_list) {
        if (ts.size() > 0) {
            no_timeseries_length = false;
            if (first) {
                min_t = ts.minT();
                max_t = ts.maxT();
                first = false;
            } else {
                min_t = fmin(min_t, ts.minT());
                max_t = fmax(max_t, ts.maxT());
            }
        }
    }

    if (no_timeseries_length) {
        min_t = 0;
        max_t = 0;
    }
}

void ViewTimeseriesWidget::pumpingSeries(QLineSeries *series,
    QLineSeries *zero_series, awfm::Timeseries q)
{
    bool first = true;
    for (size_t i = 0; i < q.size(); i++) {
        double t = q.t(i);
        double v = q.v(i);
        if (first) {
            series->append(t, 0);
            series->append(t, v);
            first = false;
        } else {
            double prev_v = q.v(i-1);
            series->append(t, prev_v);
            series->append(t, v);
        }
        zero_series->append(t, 0);
    }
}

int ViewTimeseriesWidget::wellIndex()
{
    return wellList->currentRow();
}

void ViewTimeseriesWidget::drawChart()
{
    bool chart_is_available = false;
    int idx = wellIndex();
    if (idx == -1) {
        return;
    }

    QValueAxis *xAxis = new QValueAxis();
    QValueAxis *yAxis1 = new QValueAxis();
    QValueAxis *yAxis2 = new QValueAxis();

    awfm::Well *w = model->wellRef(idx);
    QChart *chart = new QChart();

    //xAxis->applyNiceNumbers();
    chart->addAxis(xAxis, Qt::AlignBottom);


    if (observedPumpingRatesCheckBox->isEnabled() && observedPumpingRatesCheckBox->isChecked()) {
        chart_is_available = true;

        awfm::Timeseries q_abs = w->q();
        q_abs.absolute();
        if (q_abs.size() > 0) {
            //yAxis1->applyNiceNumbers();
            chart->addAxis(yAxis1, Qt::AlignLeft);
        }

        QLineSeries *pos_series = new QLineSeries();
        QLineSeries *pos_zero_series = new QLineSeries();
        QLineSeries *neg_series = new QLineSeries();
        QLineSeries *neg_zero_series = new QLineSeries();

        awfm::Timeseries q_neg = w->q();
        q_neg.setMaxValue(0);
        q_neg.scale(-1.0);

        awfm::Timeseries q_pos = w->q();
        q_pos.setMinValue(0);

        pumpingSeries(pos_series, pos_zero_series, q_pos);
        pumpingSeries(neg_series, neg_zero_series, q_neg);

        QAreaSeries *pos_area_series = new QAreaSeries(pos_series, pos_zero_series);
        pos_area_series->setName("Pumping Rates");
        pos_area_series->setColor(QColor(160, 160, 160));
        chart->addSeries(pos_area_series);
        pos_area_series->attachAxis(xAxis);
        pos_area_series->attachAxis(yAxis1);

        QAreaSeries *neg_area_series = new QAreaSeries(neg_series, neg_zero_series);
        neg_area_series->setName("Injection Rates");
        neg_area_series->setColor(QColor(255, 0, 0));
        chart->addSeries(neg_area_series);
        neg_area_series->attachAxis(xAxis);
        neg_area_series->attachAxis(yAxis1);


    }

    if (observedWaterLevelsCheckBox->isEnabled()
        && observedWaterLevelsCheckBox->isChecked()) {
        chart_is_available = true;
        awfm::Timeseries wl = w->wl();
        QLineSeries *wl_series = new QLineSeries();

        if (wl.size() > 0) {
            //yAxis2->applyNiceNumbers();
            chart->addAxis(yAxis2, Qt::AlignRight);
        }

        for (int i = 0; i < wl.size(); i++) {
            wl_series->append(wl.t(i), wl.v(i));
        }
        chart->addSeries(wl_series);
        wl_series->setName("Observed Water Level");
        wl_series->attachAxis(xAxis);
        wl_series->attachAxis(yAxis2);
    }

    if (ModeledWaterLevelsCheckBox->isEnabled()
        && ModeledWaterLevelsCheckBox->isChecked()) {
        chart_is_available = true;

        QList<double> ts = w->result("t");
        QList<double> wls = w->result("wl");
        // Build timeseries to use timeseries functionality
        awfm::Timeseries wl;
        for (int i = 0; i < ts.size(); i++) {
            wl.append(ts[i], wls[i]);
        }

        QLineSeries *wl_series = new QLineSeries();

        if (wl.size() > 0) {
            //yAxis2->applyNiceNumbers();
            chart->addAxis(yAxis2, Qt::AlignRight);
        }

        for (int i = 0; i < wl.size(); i++) {
            wl_series->append(wl.t(i), wl.v(i));
        }
        chart->addSeries(wl_series);
        wl_series->setName("Modeled Water Level");
        wl_series->attachAxis(xAxis);
        wl_series->attachAxis(yAxis2);
    }


    if (chart_is_available) {
        chart->setTitle(w->name());
        chart->legend()->setAlignment(Qt::AlignBottom);

        xAxis->setTitleText("Time (unit)");
        yAxis1->setTitleText("Flow (unit)");
        yAxis2->setTitleText("Water Level (unit)");


    }

    xAxis->applyNiceNumbers();
    yAxis1->applyNiceNumbers();
    yAxis2->applyNiceNumbers();
    chartView->setChart(chart);
}

void ViewTimeseriesWidget::wellSelectionChanged(int idx)
{
    if (idx == -1) {
        return;
    }
    awfm::Well *w = model->wellRef(idx);
    observedPumpingRatesCheckBox->setEnabled(w->q().size() > 0);
    observedWaterLevelsCheckBox->setEnabled(w->wl().size() > 0);
    ModeledWaterLevelsCheckBox->setEnabled(w->hasResults());
    drawChart();
}
