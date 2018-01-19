#include "welllossdlg.h"

#include "awfmtablewidget.h"
#include "abstractwelllossmodel.h"
#include "jacobsimplifiedwellloss.h"
#include "jacobwellloss.h"
#include <QDialogButtonBox>
#include <QCheckBox>
#include <QHBoxLayout>
#include <QStringList>
#include <QTableWidgetItem>
#include <QVBoxLayout>



WellLossDlg::WellLossDlg(awfm::Model *model)
{
    wells_ = model->wells();
    initWidgets();
    initLayout();
    fillTable();
}

void WellLossDlg::fillTable()
{
    QFont font;
    font.setItalic(true);
    QColor background_color = QColor(230, 230, 230);
    for (int i = 0; i < wells_.size(); i++) {
        table->setItem(i, 0, new QTableWidgetItem(wells_[i].name()));
        QTableWidgetItem *item = table->item(i, 0);
        item->setFont(font);
        item->setFlags(item->flags() &  ~Qt::ItemIsEditable);

        QTableWidgetItem *b_twi =
                new QTableWidgetItem(QString("%1").arg(wells_[i].b()));
        table->setItem(i, 1, b_twi);

        QTableWidgetItem *db_twi =
                new QTableWidgetItem(QString("%1").arg(wells_[i].db()));
        table->setItem(i, 2, db_twi);

        QTableWidgetItem *c_twi =
                new QTableWidgetItem(QString("%1").arg(wells_[i].c()));
        table->setItem(i, 3, c_twi);

        QTableWidgetItem *dc_twi =
                new QTableWidgetItem(QString("%1").arg(wells_[i].dc()));
        table->setItem(i, 4, dc_twi);

        if (!wellLossLaminarCheckBox->isChecked()) {
            b_twi->setText("0");
            b_twi->setTextColor(background_color);
            b_twi->setFlags(b_twi->flags() &  ~Qt::ItemIsEditable);
            db_twi->setText("0");
            db_twi->setTextColor(background_color);
            db_twi->setFlags(b_twi->flags() &  ~Qt::ItemIsEditable);
        }

        if (!wellLossTurbulantCheckBox->isChecked()) {
            c_twi->setText("0");
            c_twi->setTextColor(background_color);
            c_twi->setFlags(c_twi->flags() &  ~Qt::ItemIsEditable);
            dc_twi->setText("0");
            dc_twi->setTextColor(background_color);
            dc_twi->setFlags(dc_twi->flags() &  ~Qt::ItemIsEditable);
        }
    }
}

void WellLossDlg::initLayout()
{
    QHBoxLayout *topLayout = new QHBoxLayout();
    topLayout->addWidget(wellLossLaminarCheckBox);
    topLayout->addWidget(wellLossTurbulantCheckBox);

    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addLayout(topLayout);
    mainLayout->addWidget(table);
    mainLayout->addWidget(buttonBox);

    setLayout(mainLayout);
}

void WellLossDlg::initWidgets()
{
    wellLossLaminarCheckBox = new QCheckBox("Laminar Well Loss (B)");
    wellLossTurbulantCheckBox = new QCheckBox("Turbulant Well Loss (C)");
    table = new AWFMTableWidget(wells_.length(), 5,
        QStringList() << "Well"
                      << "B" << "dB/year"
                      << "C" << "dC/year");

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok |
                                     QDialogButtonBox::Cancel);

    connect(buttonBox, &QDialogButtonBox::accepted,
            this, &QDialog::accept);

    connect(buttonBox, &QDialogButtonBox::rejected,
            this, &QDialog::reject);

    connect(wellLossLaminarCheckBox, &QCheckBox::stateChanged,
            this, &WellLossDlg::fillTable);

    connect(wellLossTurbulantCheckBox, &QCheckBox::stateChanged,
            this, &WellLossDlg::fillTable);

}
