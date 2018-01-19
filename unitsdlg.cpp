#include "unitsdlg.h"


#include <QComboBox>
#include <QDialogButtonBox>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QStringList>
#include <QVBoxLayout>

void UnitsDlg::initLayout()
{
    QGridLayout *topLayout = new QGridLayout();
    topLayout->addWidget(lengthLabel, 0, 0);
    topLayout->addWidget(lengthComboBox, 0, 1);
    topLayout->addWidget(timeLabel, 1, 0);
    topLayout->addWidget(timeComboBox, 1, 1);
    topLayout->addWidget(dischargeLabel, 2, 0);
    topLayout->addWidget(dischargeComboBox, 2, 1);

    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addLayout(topLayout);
    mainLayout->addWidget(buttonBox);

    setLayout(mainLayout);
}

void UnitsDlg::initWidgets()
{
    dischargeLabel = new QLabel("Discharge: ");
    lengthLabel = new QLabel("Length: ");
    timeLabel = new QLabel("Time: ");

    dischargeComboBox = new QComboBox();
    dischargeComboBox->addItems(
        QStringList() << "m3/d" << "cfs" << "gpm");

    lengthComboBox = new QComboBox();
    lengthComboBox->addItems(
        QStringList() << "meters" << "yards" << "feet");

    timeComboBox = new QComboBox();
    timeComboBox->addItems(
        QStringList() << "days" << "hours" << "minutes" << "seconds");

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                   | QDialogButtonBox::Cancel);

    connect(buttonBox, &QDialogButtonBox::accepted,
            this, &QDialog::accept);

    connect(buttonBox, &QDialogButtonBox::rejected,
            this, &QDialog::reject);
}

UnitsDlg::UnitsDlg(awfm::Model *m)
{
    initWidgets();
    initLayout();
}
