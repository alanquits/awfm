#ifndef UNITSDLG_H
#define UNITSDLG_H

#include "definitions.h"
#include "model.h"

#include <QDialog>

class QLabel;
class QComboBox;
class QDialogButtonBox;

class UnitsDlg : public QDialog {
    Q_OBJECT

private:


    QLabel *dischargeLabel;
    QLabel *lengthLabel;
    QLabel *timeLabel;

    QComboBox *dischargeComboBox;
    QComboBox *lengthComboBox;
    QComboBox *timeComboBox;

    QDialogButtonBox *buttonBox;

    void initLayout();
    void initWidgets();



public:
    UnitsDlg(awfm::Model *m);

    awfm::DischargeUnit dischargeUnit();
    awfm::LengthUnit lengthUnit();
    awfm::TimeUnit timeUnit();
};

#endif
