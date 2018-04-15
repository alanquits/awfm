#include "abstractdataframe.h"
#include "editwellsdlg.h"
#include "importdlg.h"

#include <QDebug>
#include <QMessageBox>
#include <QModelIndexList>
#include <QStringList>
#include <QTableWidgetItem>
#include <QVBoxLayout>

EditWellsDlg::EditWellsDlg(awfm::Model *model)
{
    setWindowTitle("Edit Wells");
    wells_ = model->wells();
    initWidgets();
    initLayout();
    fillTableWithWells();

    transientCheckBox->setChecked(model->isOptionOn("h0_transient_on"));
    connect(transientCheckBox, SIGNAL(stateChanged(int)),
            this, SLOT(transientStateChanged()));
    transientStateChanged();
    resize(900, 400);
}

void EditWellsDlg::initWidgets()
{
    transientCheckBox = new QCheckBox("Transient h0");
    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                     | QDialogButtonBox::Cancel);
    connect(buttonBox, &QDialogButtonBox::accepted, this, &QDialog::accept);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &QDialog::reject);

    initTable();
}

    void EditWellsDlg::initTable()
{
    QStringList headers;
    headers << "name" << "x" << "y" << "rw" << "h0" << "dh0";
    table = new AWFMTableWidget(0, 6, headers);

    connect(table, SIGNAL(importSelected()),
            this, SLOT(import()));

    connect(table, SIGNAL(insertAboveSelected(QList<int>)),
            this, SLOT(insertAbove(QList<int>)));

    connect(table, SIGNAL(insertBelowSelected(QList<int>)),
            this, SLOT(insertBelow(QList<int>)));

    connect(table,SIGNAL(itemChanged(QTableWidgetItem *)),
            this, SLOT(cellChanged(QTableWidgetItem *)));

    connect(table, SIGNAL(deleteRowsSelected(QList<int>)),
            this, SLOT(deleteRows(QList<int>)));
}

void EditWellsDlg::initLayout()
{
    QHBoxLayout *topLayout = new QHBoxLayout();
    topLayout->addStretch();
    topLayout->addWidget(transientCheckBox);

    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addLayout(topLayout);
    mainLayout->addWidget(table);
    mainLayout->addWidget(buttonBox);
    setLayout(mainLayout);
}

void EditWellsDlg::insertAbove(QList<int> selected_rows)
{
    for (int i = selected_rows.size()-1; i >= 0; i--) {
        wells_.insert(selected_rows[i], awfm::Well("name", 0, 0, 1.0, 0));
    }
    fillTableWithWells();
}

void EditWellsDlg::insertBelow(QList<int> selected_rows)
{
    for (int i = selected_rows.size()-1; i >= 0; i--) {
        wells_.insert(selected_rows[i]+1, awfm::Well("name", 0, 0, 1.0, 0));
    }
    fillTableWithWells();
}

void EditWellsDlg::deleteRows(QList<int> selected_rows)
{
    for (int i = selected_rows.size()-1; i >= 0; i--) {
        if (wells_.size() > 1) {
            wells_.removeAt(selected_rows[i]);
        }
    }
    fillTableWithWells();
}

void EditWellsDlg::transientStateChanged()
{
    table->setColumnEditable(5, transientCheckBox->isChecked());
}

void EditWellsDlg::fillTableWithWells()
{
    table->setRowCount(wells_.size());
    int row = 0;
    foreach (awfm::Well w, wells_) {
        table->setItem(row, 0, new QTableWidgetItem(w.name()));
        table->setItem(row, 1, new QTableWidgetItem(QString::number(w.x())));
        table->setItem(row, 2, new QTableWidgetItem(QString::number(w.y())));
        table->setItem(row, 3, new QTableWidgetItem(QString::number(w.rw())));
        table->setItem(row, 4, new QTableWidgetItem(QString::number(w.h0())));
        table->setItem(row, 5, new QTableWidgetItem(QString::number(w.dh0())));
        row++;
    }
}

void EditWellsDlg::cellChanged(QTableWidgetItem *item)
{
    int row = item->row();
    int col = item->column();
    switch (col) {
    case 0:
        wells_[row].setName(item->text());
        break;
    case 1:
        wells_[row].setX(item->text().toDouble());
        break;
    case 2:
        wells_[row].setY(item->text().toDouble());
        break;
    case 3:
        wells_[row].setRw(item->text().toDouble());
        break;
    case 4:
        wells_[row].setH0(item->text().toDouble());
        break;
    case 5:
        wells_[row].setDeltaH0(item->text().toDouble());
        break;
    }

}

void EditWellsDlg::import()
{
    QStringList targets;
    targets << "name" << "x" << "y" << "rw" << "h0";
    if (transientCheckBox->isChecked()) {
        targets << "dh0";
    }

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

    wells_.clear();
    while (df->nextRow()) {
        QString name = df->getString(df->columnIndex(target_map["name"]));
        double x = df->getDouble(df->columnIndex(target_map["x"]));
        double y = df->getDouble(df->columnIndex(target_map["y"]));
        double rw = df->getDouble(df->columnIndex(target_map["rw"]));
        double h0 = df->getDouble(df->columnIndex(target_map["h0"]));

        awfm::Well w = awfm::Well(name, x, y, rw, h0);

        if (transientCheckBox->isChecked()) {
            double dh0 = df->getDouble(df->columnIndex(target_map["dh0"]));
            w.setDeltaH0(dh0);
        }

        wells_.append(w);

    }
    table->setColumnEditable(5, true);
    fillTableWithWells();
    transientStateChanged();

    delete df;
}
