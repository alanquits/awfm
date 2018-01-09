#ifndef AQUIFERDRAWDOWNDLG_H
#define AQUIFERDRAWDOWNDLG_H

#include <QDialog>
#include "abstractaquiferdrawdownmodel.h"
#include "model.h"

class QLabel;
class QLineEdit;
class QComboBox;
class QDialogButtonBox;

class AquiferDrawdownDlg : public QDialog {
    Q_OBJECT
private:
    QLabel *methodLabel;
    QComboBox *methodComboBox;

    QLabel *storativityLabel;
    QLineEdit *storativityLineEdit;
    QLabel *transmissivityLabel;
    QLineEdit *transmissivityLineEdit;
    QLabel *hjMpOverKpLabel;
    QLineEdit *hjMpOverKpLineEdit;

    QDialogButtonBox *buttonBox;

    void initWidgets();
    void initLayout();
    void fillWidgetsFromModel(awfm::Model *model);

    void showTheisWidgets(bool b);
    void showHantushJacobWidgets(bool b);
    bool formCompleted();
    virtual void accept();

public:
    AquiferDrawdownDlg(awfm::Model *model);
    awfm::AquiferDrawdownModel aquiferDrawdownModel();

    double storativity();
    double transmissivity();
    double mpOverKp();

public slots:
    void methodToggled();
};
#endif // AQUIFERDRAWDOWNDLG_H
