#ifndef EDITWELLSDLG_H
#define EDITWELLSDLG_H

#include "awfmtablewidget.h"
#include "model.h"
#include "well.h"
#include <QDialog>
#include <QDialogButtonBox>

class EditWellsDlg : public QDialog {
    Q_OBJECT
private:
    AWFMTableWidget *table;
    QDialogButtonBox *buttonBox;
    QList<awfm::Well> wells_; // A local copy of wells list to modify

public:
    EditWellsDlg(awfm::Model *model);
    void initWidgets();
    void initTable();
    void initLayout();
    void fillTableWithWells();
    QList<awfm::Well> wells() { return wells_; }

public slots:
    void cellChanged(QTableWidgetItem *item);
    void import();
    void insertAbove(QList<int> selected_rows);
    void insertBelow(QList<int> selected_rows);
    void deleteRows(QList<int> selected_rows);
};



#endif
