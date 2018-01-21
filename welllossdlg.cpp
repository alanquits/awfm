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
    wellLossLaminarCheckBox->setChecked(
                model->isOptionOn("well_loss_laminar_on"));
    wellLossTurbulantCheckBox->setChecked(
                model->isOptionOn("well_loss_turbulant_on"));
    transientCheckBox->setChecked(
                model->isOptionOn("well_loss_transient_on"));
    optionsToggled();
    setMinimumSize(800, 400);
}

QList<QMap<QString, double> > WellLossDlg::tableData()
{
    QList<QMap<QString, double> > data;
    for (int row = 0; row < table->rowCount(); row++) {
        QMap<QString, double> m;
        m["b"] = table->item(row, 1)->text().toDouble();
        m["db"] = table->item(row, 2)->text().toDouble();
        m["c"] = table->item(row, 3)->text().toDouble();
        m["dc"] = table->item(row, 4)->text().toDouble();
        data.push_back(m);
    }
    return data;
}

QMap<QString, bool> WellLossDlg::getOptions()
{
    QMap<QString, bool> m;
    m["well_loss_turbulant_on"] = wellLossTurbulantCheckBox->isChecked();
    m["well_loss_laminar_on"] = wellLossLaminarCheckBox->isChecked();
    m["well_loss_transient_on"] = transientCheckBox->isChecked();
    return m;
}

void WellLossDlg::fillTable()
{
    QFont font;
    font.setItalic(true);
    for (int i = 0; i < wells_.size(); i++) {
        table->setItem(i, 0, new QTableWidgetItem(wells_[i].name()));
        QTableWidgetItem *item = table->item(i, 0);
        item->setFont(font);
        item->setFlags(item->flags() &  ~Qt::ItemIsEditable);

        table->setItem(i, 1,
            new QTableWidgetItem(QString("%1").arg(wells_[i].b())));

        table->setItem(i, 2,
            new QTableWidgetItem(QString("%1").arg(wells_[i].db())));

        table->setItem(i, 3,
            new QTableWidgetItem(QString("%1").arg(wells_[i].c())));

        table->setItem(i, 4,
            new QTableWidgetItem(QString("%1").arg(wells_[i].dc())));
    }

}

void WellLossDlg::optionsToggled()
{
    setColumnEditable(1, wellLossLaminarCheckBox->isChecked());
    setColumnEditable(2, wellLossLaminarCheckBox->isChecked()
                      && transientCheckBox->isChecked());
    setColumnEditable(3, wellLossTurbulantCheckBox->isChecked());
    setColumnEditable(4, wellLossTurbulantCheckBox->isChecked()
                      && transientCheckBox->isChecked());
}

void WellLossDlg::initLayout()
{
    QHBoxLayout *topLayout = new QHBoxLayout();
    topLayout->addWidget(wellLossLaminarCheckBox);
    topLayout->addWidget(wellLossTurbulantCheckBox);
    topLayout->addStretch();
    topLayout->addWidget(transientCheckBox);

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
    transientCheckBox = new QCheckBox("Transient");
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
            this, &WellLossDlg::optionsToggled);

    connect(wellLossTurbulantCheckBox, &QCheckBox::stateChanged,
            this, &WellLossDlg::optionsToggled);

    connect(transientCheckBox, &QCheckBox::stateChanged,
            this, &WellLossDlg::optionsToggled);

}

void WellLossDlg::setColumnEditable(int column_idx, bool editable)
{
    QFont font;
    bool is_italic = editable ? false : true;
    font.setItalic(is_italic);

    QColor color = editable ? QColor(0, 0, 0)         // black
                            : QColor(230, 230, 230);  // light gray

    for (int row = 0; row < table->rowCount(); row++) {
        QTableWidgetItem *item = table->item(row, column_idx);
        item->setTextColor(color);
        item->setFont(font);
        if (editable) {
            item->setFlags(Qt::ItemIsSelectable|Qt::ItemIsEditable|Qt::ItemIsEnabled);
        } else {
            item->setFlags(item->flags() &  ~Qt::ItemIsEditable);
        }

    }
}

