#include "viewtimeserieswidget.h"

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

int ViewTimeseriesWidget::wellIndex()
{
    return wellList->currentRow();
}

void ViewTimeseriesWidget::drawChart()
{
    int idx = wellIndex();
    if (idx == -1) {
        return;
    }
    awfm::Well *w = model->wellRef(idx);
    QChart *chart = new QChart();
    if (observedPumpingRatesCheckBox->isEnabled() && observedPumpingRatesCheckBox->isChecked()) {
        QLineSeries *series = new QLineSeries();
        QLineSeries *zeroSeries = new QLineSeries();
        awfm::Timeseries q = w->q();
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
            zeroSeries->append(t, 0);
        }




        QAreaSeries *areaSeries = new QAreaSeries(series, zeroSeries);
        areaSeries->setName("Pumping Rates");
        areaSeries->setColor(QColor(160, 160, 160));
        chart->addSeries(areaSeries);
        chart->createDefaultAxes();
        chartView->setChart(chart);
    }

    chart->setTitle(w->name());
    chart->legend()->setAlignment(Qt::AlignBottom);


}

void ViewTimeseriesWidget::wellSelectionChanged(int idx)
{
    if (idx == -1) {
        return;
    }
    awfm::Well *w = model->wellRef(idx);
    observedPumpingRatesCheckBox->setEnabled(w->q().size() > 0);
    observedWaterLevelsCheckBox->setEnabled(w->wl().size() > 0);
    ModeledWaterLevelsCheckBox->setEnabled(w->sAq().size() > 0);
    drawChart();
}
