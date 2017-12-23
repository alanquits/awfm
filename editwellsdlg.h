#ifndef EDITWELLSDLG_H
#define EDITWELLSDLG_H

#include <QTableWidget>
#include <QDialog>

class EditWellsDlg : public QDialog {
    Q_OBJECT
private:
    QTableWidget *table;

public:
    EditWellsDlg();
    void initTable();
    void initLayout();
};



#endif
