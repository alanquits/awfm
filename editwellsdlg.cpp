#include "abstractdataframe.h"
#include "editwellsdlg.h"
#include "importdlg.h"

#include <QMessageBox>
#include <QStringList>
#include <QVBoxLayout>

EditWellsDlg::EditWellsDlg()
{
    setWindowTitle("Edit Wells");
    initWidgets();
    initLayout();
    fillTableWithWells();
}

void EditWellsDlg::initWidgets()
{
    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                     | QDialogButtonBox::Cancel);
    connect(buttonBox, &QDialogButtonBox::accepted, this, &QDialog::accept);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &QDialog::reject);
    initTable();
}

    void EditWellsDlg::initTable()
{
    QStringList headers;
    headers << "name" << "x" << "y" << "rw" << "h0";
    table = new AWFMTableWidget(0, 5, headers);
    connect(table, SIGNAL(importSelected()), this, SLOT(import()));
}

void EditWellsDlg::initLayout()
{
    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addWidget(table);
    setLayout(mainLayout);
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
        row++;
    }
}

void EditWellsDlg::import()
{
    QStringList targets;
    targets << "name" << "x" << "y" << "rw" << "h0";
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
        QString name = df->getString(0);
        double x = df->getDouble(1);
        double y = df->getDouble(2);
        double rw = df->getDouble(3);
        double h0 = df->getDouble(4);
        wells_.append(awfm::Well(name, x, y, rw, h0));
    }
    fillTableWithWells();
    delete df;
}
