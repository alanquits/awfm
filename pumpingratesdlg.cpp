#include "pumpingratesdlg.h"

#include <QDialogButtonBox>
#include <QLabel>
#include <QLineEdit>
#include <QComboBox>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QGroupBox>
#include <QRadioButton>
#include <QCheckBox>
#include <QPushButton>
#include <QVBoxLayout>
#include <QTableWidget>

PumpingRatesDlg::PumpingRatesDlg(awfm::Model *model)
{
    wells_ = model->wells();
    setWindowTitle("Edit Pumping Rates");
    initWidgets();
    initTables();
    initLayout();
}

void PumpingRatesDlg::initWidgets()
{
    recordCountLabel = new QLabel("");
    setRecordCount(0);
    wellsLabel = new QLabel("Well: ");
    wellsComboBox = new QComboBox();
    for (int i = 0; i < wells_.size(); i++) {
        wellsComboBox->addItem(wells_[i].name());
    }
    applyToAllWellsCheckBox = new QCheckBox("Apply to All Wells");
    applyToAllWellsCheckBox->setChecked(true);

    errorCodeLabel = new QLabel("Error Code: ");
    errorCodeLineEdit = new QLineEdit();
    onErrorLabel = new QLabel("On Error: ");
    onErrorComboBox = new QComboBox();
    onErrorComboBox->addItems(QStringList()
                              << "Remove"
                              << "Linear Interpolate");
    applyErrorCodeButton = new QPushButton("Apply");

    maxValueLabel = new QLabel("Max Value: ");
    maxValueLineEdit = new QLineEdit();

    minValueLabel = new QLabel("Min Value: ");
    minValueLineEdit = new QLineEdit();

    minMagnitudeLabel = new QLabel("Min Magnitude: ");
    minMagnitudeLineEdit = new QLineEdit();

    applyRangeButton = new QPushButton("Apply");

    t0ProjectLabel = new QLabel("t0: ");
    t0ProjectLineEdit = new QLineEdit();
    tfProjectLabel = new QLabel("tf: ");
    tfProjectLineEdit = new QLineEdit();
    dtProjectLabel = new QLabel("dt: ");
    dtProjectLineEdit = new QLineEdit();

    applyProjectionButton = new QPushButton("Apply");

    averagingGroupBox = new QGroupBox("Data Reduction");
    averageByToleranceRadio = new QRadioButton("Average by Tolerance");
    averageToleranceLineEdit = new QLineEdit();
    averageBySignRadio = new QRadioButton("Average by Sign");
    noAveragingRadio = new QRadioButton("No Averaging");
    applyAveragingButton = new QPushButton("Apply");

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                     | QDialogButtonBox::Cancel);

    connect(buttonBox, &QDialogButtonBox::accepted,
            this, &QDialog::accept);

    connect(buttonBox, &QDialogButtonBox::rejected,
            this, &QDialog::reject);
}

void PumpingRatesDlg::initTables()
{
    rawTable = new AWFMTableWidget(0, 2, QStringList() << "t" << "Q");
    reducedTable = new QTableWidget();
    reducedTable->setRowCount(0);
    reducedTable->setColumnCount(2);
    reducedTable->setHorizontalHeaderLabels(QStringList() << "t" << "Q");
}

void PumpingRatesDlg::initLayout()
{
    QVBoxLayout *leftLayout = new QVBoxLayout();
    QVBoxLayout *rightLayout = new QVBoxLayout();

    leftLayout->addWidget(rawTable);
    rawTable->setMinimumWidth(250);
    leftLayout->addWidget(recordCountLabel);

    QHBoxLayout *applyToAllWellsLayout = new QHBoxLayout();
    applyToAllWellsLayout->addWidget(wellsLabel);
    applyToAllWellsLayout->addWidget(wellsComboBox);
    applyToAllWellsLayout->addStretch();
    applyToAllWellsLayout->addWidget(applyToAllWellsCheckBox);
    rightLayout->addLayout(applyToAllWellsLayout);

    QGroupBox *rangesGroupBox = new QGroupBox("Range Constraints");
    QHBoxLayout *minMaxLayout = new QHBoxLayout();
    minMaxLayout->addWidget(minValueLabel);
    minMaxLayout->addWidget(minValueLineEdit);
    minMaxLayout->addWidget(maxValueLabel);
    minMaxLayout->addWidget(maxValueLineEdit);
    minMaxLayout->addWidget(minMagnitudeLabel);
    minMaxLayout->addWidget(minMagnitudeLineEdit);

    QHBoxLayout *minMaxApplyLayout = new QHBoxLayout();
    minMaxApplyLayout->addStretch();
    minMaxApplyLayout->addWidget(applyRangeButton);

    QVBoxLayout *minMaxLayoutWithApply = new QVBoxLayout();
    minMaxLayoutWithApply->addLayout(minMaxLayout);
    minMaxLayoutWithApply->addLayout(minMaxApplyLayout);

    rangesGroupBox->setLayout(minMaxLayoutWithApply);
    rightLayout->addWidget(rangesGroupBox);

    QGroupBox *errorGroupBox = new QGroupBox("Erroneous Data");
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
    errorGroupBox->setLayout(errorCodeLayoutWithApply);
    rightLayout->addWidget(errorGroupBox);

    QGroupBox *projectionGroupBox = new QGroupBox("Projection");

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

    projectionGroupBox->setLayout(projectOntoLineLayoutWithApply);
    rightLayout->addWidget(projectionGroupBox);


    QHBoxLayout *averageByToleranceLayout = new QHBoxLayout();
    averageByToleranceLayout->addWidget(averageByToleranceRadio);
    averageByToleranceLayout->addWidget(averageToleranceLineEdit);
    QVBoxLayout *averagingLayout = new QVBoxLayout();
    averagingLayout->addWidget(noAveragingRadio);
    averagingLayout->addWidget(averageBySignRadio);
    averagingLayout->addLayout(averageByToleranceLayout);

    QHBoxLayout *averagingApplyLayout = new QHBoxLayout();
    averagingApplyLayout->addStretch();
    averagingApplyLayout->addWidget(applyAveragingButton);

    QVBoxLayout *averagingLayoutWithApply = new QVBoxLayout();
    averagingLayoutWithApply->addLayout(averagingLayout);
    averagingLayoutWithApply->addLayout(averagingApplyLayout);

    averagingGroupBox->setLayout(averagingLayoutWithApply);
    rightLayout->addWidget(averagingGroupBox);

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

void PumpingRatesDlg::setRecordCount(int records)
{
    recordCountLabel->setText(QString("%1 records").arg(records));
}

void PumpingRatesDlg::cellChanged(QTableWidgetItem *item)
{

}

void PumpingRatesDlg::import()
{

}

void PumpingRatesDlg::insertAbove(QList<int> selected_rows)
{

}

void PumpingRatesDlg::insertBelow(QList<int> selected_rows)
{

}

void PumpingRatesDlg::deleteRows(QList<int> selected_rows)
{

}
