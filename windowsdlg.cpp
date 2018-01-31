#include "windowsdlg.h"
#include "awfmtablewidget.h"

#include <QComboBox>
#include <QDialogButtonBox>
#include <QHBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QtCharts/QChartView>
#include <QTableWidgetItem>
#include <QVBoxLayout>

WindowsDlg::WindowsDlg(awfm::Model *model, size_t start_idx)
{
    model_ = model;
    wells_ = model->wells(); // copy of wells to modify
    initWidgets();
    wellChanged(start_idx);
    initLayout();


}

void WindowsDlg::wellChanged(int well_idx)
{
    wellIndex_ = well_idx;
    wellNameLabel->setText(
                QString("Well: <b>%1</b>").arg(wells_[well_idx].name()));

    QList<QPair<double,double> > windows = wells_[well_idx].windows();
    tableWidget->setRowCount(windows.size());

    for (int i = 0; i < windows.size(); i++) {
        QPair<double, double> window = windows[i];


        tableWidget->setItem(i, 0,
            new QTableWidgetItem(QString("%1").arg(window.first)));

        tableWidget->setItem(i, 1,
            new QTableWidgetItem(QString("%1").arg(window.second)));
    }
}

void WindowsDlg::insertWindow(double t0, double tf)
{
    wells_[wellIndex_].insertWindow(t0, tf);
    wellChanged(wellIndex_);
    emit wellWindowsChanged(&wells_[wellIndex_]);
}

void WindowsDlg::deleteWindow(double t)
{
    wells_[wellIndex_].deleteWindowAt(t);
    wellChanged(wellIndex_);
    emit wellWindowsChanged(&wells_[wellIndex_]);
}

void WindowsDlg::accept()
{
    model_->setWells(wells_); // Update wells
    QDialog::accept();
}

void WindowsDlg::initWidgets()
{
    wellNameLabel = new QLabel("Well: ");

    tableWidget = new AWFMTableWidget(1, 2,
        QStringList() << "t0" << "tf");

    tableWidget->setMinimumWidth(300);

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok |
                                     QDialogButtonBox::Cancel);

    connect(buttonBox, SIGNAL(accepted()),
            this, SLOT(accept()));

    connect(buttonBox, SIGNAL(rejected()),
            this, SLOT(reject()));
}

void WindowsDlg::initLayout()
{
    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addWidget(wellNameLabel);
    mainLayout->addWidget(tableWidget);
    mainLayout->addWidget(buttonBox);

    setLayout(mainLayout);
}
