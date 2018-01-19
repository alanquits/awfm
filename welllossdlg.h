#ifndef WELLLOSSDLG_H
#define WELLLOSSDLG_H

#include "model.h"
#include "well.h"

#include <QDialog>
#include <QList>

class AWFMTableWidget;
class QDialogButtonBox;
class QCheckBox;

class WellLossDlg : public QDialog {
    Q_OBJECT

private:
    QList<awfm::Well> wells_;
    QDialogButtonBox *buttonBox;
    AWFMTableWidget *table;
    QCheckBox *wellLossLaminarCheckBox;   // B
    QCheckBox *wellLossTurbulantCheckBox; // C
    QCheckBox *transientCheckBox;


    void initLayout();
    void initWidgets();

public:
    WellLossDlg(awfm::Model *model);

public slots:
    void fillTable();

};

#endif
