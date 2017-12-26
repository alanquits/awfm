#ifndef EDITWELLSDLG_H
#define EDITWELLSDLG_H

#include "awfmtablewidget.h"
#include "well.h"
#include <QDialog>
#include <QDialogButtonBox>

class EditWellsDlg : public QDialog {
    Q_OBJECT
private:
    AWFMTableWidget *table;
    QDialogButtonBox *buttonBox;
    QList<awfm::Well> wells_;


public:
    EditWellsDlg();
    void initWidgets();
    void initTable();
    void initLayout();
    void fillTableWithWells();

public slots:
    void import();
};



#endif
