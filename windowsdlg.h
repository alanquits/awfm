#ifndef WINDOWSDLG_H
#define WINDOWSDLG_H

#include <QDialog>
#include <QtCharts/QChartView>
#include "model.h"

using namespace QtCharts;

class QComboBox;
class QDialogButtonBox;
class QLabel;
class QPushButton;
class AWFMTableWidget;

class WindowsDlg : public QDialog {
    Q_OBJECT

    awfm::Model *model_;
    QList<awfm::Well> wells_;
    QLabel *wellNameLabel;
    AWFMTableWidget *tableWidget;
    QDialogButtonBox *buttonBox;
    int wellIndex_;

    void initWidgets();
    void initLayout();

public:
    WindowsDlg(awfm::Model *model, size_t start_idx);

public slots:
    void wellChanged(int well_idx);
    void insertWindow(double t0, double tf);
    void deleteWindow(double t);
    QList<awfm::Well> wells() { return wells_; }
    virtual void accept();

signals:
    void wellWindowsChanged(awfm::Well *w);
};

#endif
