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
    void setColumnEditable(int column_idx, bool editable);

public:
    WellLossDlg(awfm::Model *model);

public slots:
    QList< QMap<QString, double> > tableData();
    QMap<QString, bool> getOptions();
    void fillTable();
    void optionsToggled();

};

#endif
