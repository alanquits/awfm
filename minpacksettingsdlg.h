#ifndef MINPACKSETTINGSDLG_H
#define MINPACKSETTINGSDLG_H

#include <QDialogButtonBox>
#include <QDialog>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include "minpack.h"

class MinPackSettingsDlg : public QDialog {
    Q_OBJECT
private:
    MinPackParameters *mp_;

    QLabel *ftolLabel;
    QLabel *gtolLabel;
    QLabel *xtolLabel;
    QLabel *maxfevLabel;
    QLabel *epsfcnLabel;

    QLineEdit *ftolLineEdit;
    QLineEdit *gtolLineEdit;
    QLineEdit *xtolLineEdit;
    QLineEdit *maxfevLineEdit;
    QLineEdit *epsfcnLineEdit;

    QDialogButtonBox *buttonBox;

    void initWidgets();
    void initLayout();
public:
    MinPackSettingsDlg(MinPackParameters *mp);
    MinPackParameters* mp() { return mp_; }

    virtual void accept();
};

#endif
