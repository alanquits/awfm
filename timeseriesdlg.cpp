#include "timeseriesdlg.h"
#include "importdlg.h"
#include "timeseries.h"
#include "well.h"


#include <QDialogButtonBox>
#include <QLabel>
#include <QLineEdit>
#include <QComboBox>
#include <QHBoxLayout>
#include <QHeaderView>
#include <QGridLayout>
#include <QGroupBox>
#include <QMessageBox>
#include <QRadioButton>
#include <QCheckBox>
#include <QPushButton>
#include <QVBoxLayout>
#include <QTableWidget>
#include <QWidget>

TimeseriesDlg::TimeseriesDlg(QStringList well_names, QList<awfm::Timeseries> time_series_s,
                             QString window_title, QString value_table_header)
{
    wellNames_ = well_names;
    timeseriesList_ = time_series_s;
    valueTableHeader_ = value_table_header;
    setWindowTitle(window_title);
    initTables();
    initWidgets();
    methodChanged();
    initMethodLayouts();
    initLayout();
}

void TimeseriesDlg::initWidgets()
{
    recordCountLabel = new QLabel("");
    setRecordCount(0);

    methodLabel = new QLabel("Method");
    methodComboBox = new QComboBox();

    wellsLabel = new QLabel("Well: ");
    wellsComboBox = new QComboBox();
    wellsComboBox->addItems(wellNames_);
    connect(wellsComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(fillTable()));
    fillTable();

    applyToAllWellsCheckBox = new QCheckBox("Apply to All Wells");
    applyToAllWellsCheckBox->setChecked(true);

    editWidgets["Translate"] = new QWidget();
    translateTLabel = new QLabel("Translate Time By: ");
    translateTLineEdit = new QLineEdit();
    translateVLabel = new QLabel(QString("Translate %1 By: ")
                                 .arg(valueTableHeader_));
    translateVLineEdit = new QLineEdit();
    translateApplyButton = new QPushButton("Apply");

    editWidgets["Scale"] = new QWidget();
    scaleTLabel = new QLabel("Scale Time By: ");
    scaleTLineEdit = new QLineEdit();
    scaleVLabel = new QLabel(QString("Scale %1 By: ")
                                 .arg(valueTableHeader_));
    scaleVLineEdit = new QLineEdit();
    scaleApplyButton = new QPushButton("Apply");

    editWidgets["Erroneous/Missing Data"] = new QWidget();
    errorCodeLabel = new QLabel("Value: ");
    errorCodeLineEdit = new QLineEdit();
    onErrorLabel = new QLabel("Perform on Value: ");
    onErrorComboBox = new QComboBox();
    onErrorComboBox->addItems(QStringList()
                              << "Remove"
                              << "Linear Interpolate");
    applyErrorCodeButton = new QPushButton("Apply");


    editWidgets["Range Constraints"] = new QWidget();
    maxValueLabel = new QLabel("Max Value: ");
    maxValueLineEdit = new QLineEdit();
    minValueLabel = new QLabel("Min Value: ");
    minValueLineEdit = new QLineEdit();
    minMagnitudeLabel = new QLabel("Min Magnitude: ");
    minMagnitudeLineEdit = new QLineEdit();
    applyRangeButton = new QPushButton("Apply");

    editWidgets["Project Onto Line"] = new QWidget();
    t0ProjectLabel = new QLabel("t0: ");
    t0ProjectLineEdit = new QLineEdit();
    tfProjectLabel = new QLabel("tf: ");
    tfProjectLineEdit = new QLineEdit();
    dtProjectLabel = new QLabel("dt: ");
    dtProjectLineEdit = new QLineEdit();
    applyProjectionButton = new QPushButton("Apply");

    editWidgets["Data Reduction"] = new QWidget();
    averagingGroupBox = new QGroupBox("Data Reduction");
    averageByToleranceRadio = new QRadioButton("Average by Tolerance");
    averageToleranceLineEdit = new QLineEdit();
    averageBySignRadio = new QRadioButton("Average by Sign");
    applyAveragingButton = new QPushButton("Apply");


    foreach(QString key, editWidgets.keys()) {
        methodComboBox->addItem(key);
    }


    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                     | QDialogButtonBox::Cancel);

    connect(methodComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(methodChanged()));

    connect(buttonBox, &QDialogButtonBox::accepted,
            this, &QDialog::accept);

    connect(buttonBox, &QDialogButtonBox::rejected,
            this, &QDialog::reject);

    connect(applyRangeButton, &QPushButton::clicked,
            this, &TimeseriesDlg::applyRangeButtonClicked);

    connect(applyAveragingButton, &QPushButton::clicked,
            this, &TimeseriesDlg::applyAveragingButtonClicked);

    connect(applyErrorCodeButton, &QPushButton::clicked,
            this, &TimeseriesDlg::applyErrorCodeButtonClicked);

    connect(scaleApplyButton, &QPushButton::clicked,
            this, &TimeseriesDlg::scaleButtonClicked);

    connect(translateApplyButton, &QPushButton::clicked,
            this, &TimeseriesDlg::translateButtonClicked);

    connect(applyProjectionButton, &QPushButton::clicked,
            this, &TimeseriesDlg::applyProjectionButtonClicked);
}

void TimeseriesDlg::initTables()
{
    rawTable = new AWFMTableWidget(0, 2, QStringList() << "t" << valueTableHeader_);
    rawTable->horizontalHeader()->setStretchLastSection(true);

    connect(rawTable, SIGNAL(importSelected()),
            this, SLOT(import()));
}

void TimeseriesDlg::initMethodLayouts()
{
    // Scale
    QGridLayout *scaleLayout = new QGridLayout();
    scaleLayout->addWidget(scaleTLabel, 0, 0);
    scaleLayout->addWidget(scaleTLineEdit, 0, 1);
    scaleLayout->addWidget(scaleVLabel, 1, 0);
    scaleLayout->addWidget(scaleVLineEdit, 1, 1);

    QHBoxLayout *scaleApplyLayout = new QHBoxLayout();
    scaleApplyLayout->addStretch();
    scaleApplyLayout->addWidget(scaleApplyButton);

    QVBoxLayout *scaleLayoutWithApply = new QVBoxLayout();
    scaleLayoutWithApply->addLayout(scaleLayout);
    scaleLayoutWithApply->addLayout(scaleApplyLayout);
    editWidgets["Scale"]->setLayout(scaleLayoutWithApply);

    // Translate
    QGridLayout *translateLayout = new QGridLayout();
    translateLayout->addWidget(translateTLabel, 0, 0);
    translateLayout->addWidget(translateTLineEdit, 0, 1);
    translateLayout->addWidget(translateVLabel, 1, 0);
    translateLayout->addWidget(translateVLineEdit, 1, 1);

    QHBoxLayout *translateApplyLayout = new QHBoxLayout();
    translateApplyLayout->addStretch();
    translateApplyLayout->addWidget(translateApplyButton);

    QVBoxLayout *translateLayoutWithApply = new QVBoxLayout();
    translateLayoutWithApply->addLayout(translateLayout);
    translateLayoutWithApply->addLayout(translateApplyLayout);
    editWidgets["Translate"]->setLayout(translateLayoutWithApply);

    // Range Constraints
    QHBoxLayout *rangeLayout = new QHBoxLayout();
    rangeLayout->addWidget(minValueLabel);
    rangeLayout->addWidget(minValueLineEdit);
    rangeLayout->addWidget(maxValueLabel);
    rangeLayout->addWidget(maxValueLineEdit);
    rangeLayout->addWidget(minMagnitudeLabel);
    rangeLayout->addWidget(minMagnitudeLineEdit);

    QHBoxLayout *rangeApplyLayout = new QHBoxLayout();
    rangeApplyLayout->addStretch();
    rangeApplyLayout->addWidget(applyRangeButton);

    QVBoxLayout *rangeLayoutWithApply = new QVBoxLayout();
    rangeLayoutWithApply->addLayout(rangeLayout);
    rangeLayoutWithApply->addLayout(rangeApplyLayout);
    editWidgets["Range Constraints"]->setLayout(rangeLayoutWithApply);

    // Erroneous/Missing Data
    QHBoxLayout *errorCodeLayout = new QHBoxLayout();
    errorCodeLayout->addWidget(errorCodeLabel);
    errorCodeLayout->addWidget(errorCodeLineEdit);
    errorCodeLayout->addWidget(onErrorLabel);
    errorCodeLayout->addWidget(onErrorComboBox);

    QHBoxLayout *errorCodeApplyLayout = new QHBoxLayout();
    errorCodeApplyLayout->addStretch();
    errorCodeApplyLayout->addWidget(applyErrorCodeButton);

    QVBoxLayout *errorCodeLayoutWithApply = new QVBoxLayout();
    errorCodeLayoutWithApply->addLayout(errorCodeLayout);
    errorCodeLayoutWithApply->addLayout(errorCodeApplyLayout);
    editWidgets["Erroneous/Missing Data"]->setLayout(errorCodeLayoutWithApply);

    // Project Onto Line
    QHBoxLayout *projectOntoLineLayout = new QHBoxLayout();
    projectOntoLineLayout->addWidget(t0ProjectLabel);
    projectOntoLineLayout->addWidget(t0ProjectLineEdit);
    projectOntoLineLayout->addWidget(tfProjectLabel);
    projectOntoLineLayout->addWidget(tfProjectLineEdit);
    projectOntoLineLayout->addWidget(dtProjectLabel);
    projectOntoLineLayout->addWidget(dtProjectLineEdit);

    QHBoxLayout *projectOntoLineApplyLayout = new QHBoxLayout();
    projectOntoLineApplyLayout->addStretch();
    projectOntoLineApplyLayout->addWidget(applyProjectionButton);

    QVBoxLayout *projectOntoLineLayoutWithApply = new QVBoxLayout();
    projectOntoLineLayoutWithApply->addLayout(projectOntoLineLayout);
    projectOntoLineLayoutWithApply->addLayout(projectOntoLineApplyLayout);
    editWidgets["Project Onto Line"]->setLayout(projectOntoLineLayoutWithApply);

    // Data Reduction
    QHBoxLayout *averageByToleranceLayout = new QHBoxLayout();
    averageByToleranceLayout->addWidget(averageByToleranceRadio);
    averageByToleranceLayout->addWidget(averageToleranceLineEdit);
    QVBoxLayout *averagingLayout = new QVBoxLayout();
    averagingLayout->addWidget(averageBySignRadio);
    averagingLayout->addLayout(averageByToleranceLayout);

    QHBoxLayout *averagingApplyLayout = new QHBoxLayout();
    averagingApplyLayout->addStretch();
    averagingApplyLayout->addWidget(applyAveragingButton);

    QVBoxLayout *averagingLayoutWithApply = new QVBoxLayout();
    averagingLayoutWithApply->addLayout(averagingLayout);
    averagingLayoutWithApply->addLayout(averagingApplyLayout);
    editWidgets["Data Reduction"]->setLayout(averagingLayoutWithApply);
}

void TimeseriesDlg::initLayout()
{
    QVBoxLayout *leftLayout = new QVBoxLayout();
    QVBoxLayout *rightLayout = new QVBoxLayout();

    leftLayout->addWidget(rawTable);
    rawTable->setMinimumWidth(350);
    leftLayout->addWidget(recordCountLabel);

    QHBoxLayout *applyToAllWellsLayout = new QHBoxLayout();
    applyToAllWellsLayout->addWidget(methodLabel);
    applyToAllWellsLayout->addWidget(methodComboBox);
    applyToAllWellsLayout->addStretch();
    applyToAllWellsLayout->addWidget(wellsLabel);
    applyToAllWellsLayout->addWidget(wellsComboBox);
    applyToAllWellsLayout->addWidget(applyToAllWellsCheckBox);
    rightLayout->addLayout(applyToAllWellsLayout);

    rightLayout->addWidget(editWidgets["Range Constraints"]);
    rightLayout->addWidget(editWidgets["Erroneous/Missing Data"]);
    rightLayout->addWidget(editWidgets["Project Onto Line"]);
    rightLayout->addWidget(editWidgets["Data Reduction"]);
    rightLayout->addWidget(editWidgets["Scale"]);
    rightLayout->addWidget(editWidgets["Translate"]);


    QHBoxLayout *bottomLayout = new QHBoxLayout();
    bottomLayout->addStretch();
    bottomLayout->addWidget(buttonBox);
    rightLayout->addLayout(bottomLayout);

    QHBoxLayout *topLayout = new QHBoxLayout();
    topLayout->addLayout(leftLayout);
    topLayout->addLayout(rightLayout);

    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addLayout(topLayout);

    setLayout(mainLayout);
}

void TimeseriesDlg::fillTable()
{
    awfm::Timeseries ts = timeseriesList_[wellsComboBox->currentIndex()];
    rawTable->setRowCount(ts.size());
    for (int i = 0; i < ts.size(); i++) {
        double t = ts.t(i);
        double v = ts.v(i);
        rawTable->setItem(i, 0, new QTableWidgetItem(QString("%1").arg(t, 0, 'f', 6)));
        rawTable->setItem(i, 1, new QTableWidgetItem(QString("%1").arg(v, 0, 'f', 6)));
    }
    recordCountLabel->setText(QString("%1 records").arg(ts.size()));
}

void TimeseriesDlg::setRecordCount(int records)
{
    recordCountLabel->setText(QString("%1 records").arg(records));
}

void TimeseriesDlg::methodChanged()
{
    foreach (QString key, editWidgets.keys()) {
        editWidgets[key]->setVisible(false);
    }
    editWidgets[methodComboBox->currentText()]->setVisible(true);
}

void TimeseriesDlg::applyAveragingButtonClicked()
{
    QString selected_well_name = wellsComboBox->currentText();
    for (size_t i = 0; i < wellNames_.size(); i++) {
        QString well_name = wellNames_[i];
        if (averageBySignRadio->isChecked()) {
            if (applyToAllWellsCheckBox->isChecked()
                    || well_name == selected_well_name) {
                timeseriesList_[i].averageBySign();
            }
        }
    }

    fillTable();
}

void TimeseriesDlg::applyErrorCodeButtonClicked()
{
    if (errorCodeLineEdit->text().isEmpty()) {
        return;
    }
    double error_code = errorCodeLineEdit->text().toDouble();
    QString on_error_text = onErrorComboBox->currentText();

    QString selected_well_name = wellsComboBox->currentText();
    for (size_t i = 0; i < wellNames_.size(); i++) {
        QString well_name = wellNames_[i];
        if (applyToAllWellsCheckBox->isChecked()
                || well_name==selected_well_name) {
            if (on_error_text == "Linear Interpolate") {
                timeseriesList_[i].interpolateOverValue(error_code);
            } else if (on_error_text == "Remove") {
                timeseriesList_[i].removeByValue(error_code);
            } else {
                // This line should not be reached.
            }
        }
    }
    fillTable();
}

void TimeseriesDlg::applyRangeButtonClicked()
{
    QString selected_well_name = wellsComboBox->currentText();
    for (size_t i = 0; i < wellNames_.size(); i++) {
        QString well_name = wellNames_[i];
        if (!minValueLineEdit->text().isEmpty()) {
            double min_value = minValueLineEdit->text().toDouble();
            if (applyToAllWellsCheckBox->isChecked()
                || well_name == selected_well_name) {
                timeseriesList_[i].setMinValue(min_value);
            }
        }
        if (!maxValueLineEdit->text().isEmpty()) {
            double max_value = maxValueLineEdit->text().toDouble();
            if (applyToAllWellsCheckBox->isChecked()
                || well_name == selected_well_name) {
                timeseriesList_[i].setMaxValue(max_value);
            }
        }
        if (!minMagnitudeLineEdit->text().isEmpty()) {
            double min_magnitude = minMagnitudeLineEdit->text().toDouble();
            if (applyToAllWellsCheckBox->isChecked()
                || well_name == selected_well_name) {
                timeseriesList_[i].setMinMagnitude(min_magnitude);
            }
        }
    }
    fillTable();

}

void TimeseriesDlg::applyProjectionButtonClicked()
{

    if (t0ProjectLineEdit->text().isEmpty()
        || tfProjectLineEdit->text().isEmpty()
        || dtProjectLineEdit->text().isEmpty()) {
        return;
    }

    double t0 = t0ProjectLineEdit->text().toDouble();
    double tf = tfProjectLineEdit->text().toDouble();
    double dt = dtProjectLineEdit->text().toDouble();

    QString selected_well_name = wellsComboBox->currentText();
    for (size_t i = 0; i < wellNames_.size(); i++) {
        QString well_name = wellNames_[i];
        if (applyToAllWellsCheckBox->isChecked()
                || well_name==selected_well_name) {
            awfm::Timeseries ts_proj = timeseriesList_[i].projectOntoLine(t0, tf, dt);
            timeseriesList_[i] = ts_proj;
        }
    }
    fillTable();
}

void TimeseriesDlg::scaleButtonClicked()
{
    if (scaleTLineEdit->text().isEmpty() && scaleVLineEdit->text().isEmpty()) {
        return;
    }

    QString selected_well_name = wellsComboBox->currentText();
    for (size_t i = 0; i < wellNames_.size(); i++) {
        QString well_name = wellNames_[i];
        if (applyToAllWellsCheckBox->isChecked()
                || well_name==selected_well_name) {
            if (!scaleTLineEdit->text().isEmpty()) {
                double s = scaleTLineEdit->text().toDouble();
                timeseriesList_[i].scaleT(s);
            }
            if (!scaleVLineEdit->text().isEmpty()) {
                double s = scaleVLineEdit->text().toDouble();
                timeseriesList_[i].scaleV(s);
            }
        }
    }
    fillTable();
}

void TimeseriesDlg::translateButtonClicked()
{
    if (translateTLineEdit->text().isEmpty() && translateVLineEdit->text().isEmpty()) {
        return;
    }

    QString selected_well_name = wellsComboBox->currentText();
    for (size_t i = 0; i < wellNames_.size(); i++) {
        QString well_name = wellNames_[i];
        if (applyToAllWellsCheckBox->isChecked()
                || well_name==selected_well_name) {
            if (!translateTLineEdit->text().isEmpty()) {
                double dt = translateTLineEdit->text().toDouble();
                timeseriesList_[i].translateT(dt);
            }
            if (!translateVLineEdit->text().isEmpty()) {
                double dv = translateVLineEdit->text().toDouble();
                timeseriesList_[i].translateV(dv);
            }
        }
    }
    fillTable();
}

void TimeseriesDlg::cellChanged(QTableWidgetItem *item)
{

}

void TimeseriesDlg::import()
{
    int well_idx = wellsComboBox->currentIndex();

    QStringList targets;
    targets << "t" << valueTableHeader_;
    ImportDlg *dlg = new ImportDlg(targets);

    if (!dlg->exec()) {
        return;
    }

    awfm::AbstractDataFrame *df = dlg->df();
    QMap<QString,QString> target_map = dlg->getTargetMap();
    df->windUp();

    if (df->hasError()) {
        QMessageBox::warning(this, tr("awfm"),
            df->error(), QMessageBox::Ok);
        return;
    }

    awfm::Timeseries ts;

    bool reading_values = false;
    bool values_out_of_order = false;
    while (df->nextRow()) {

        double t, v;

        if (df->isNull(df->columnIndex(target_map["t"]))) {
            continue;
        } else {
            t = df->getDouble(df->columnIndex(target_map["t"]));
        }

        if (!df->isNull(df->columnIndex(target_map[valueTableHeader_]))) {
            reading_values = true;
            v = df->getDouble(df->columnIndex(target_map[valueTableHeader_]));
        } else {
            v = -9999;
        }

        if (reading_values) {
            if (!ts.append(t, v))
            {
                values_out_of_order = true;
            }
        }
    }

    if (values_out_of_order) {
        QMessageBox::warning(this, "Source File Error",
            "Not all values were imported. Time column is not"
            " in chronological order or contains duplicates.");
    }

    timeseriesList_[well_idx] = ts;

    fillTable();
    delete df;
}

void TimeseriesDlg::insertAbove(QList<int> selected_rows)
{

}

void TimeseriesDlg::insertBelow(QList<int> selected_rows)
{

}

void TimeseriesDlg::deleteRows(QList<int> selected_rows)
{

}
