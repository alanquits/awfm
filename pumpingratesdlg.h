#ifndef PUMPINGRATESDLG_H
#define PUMPINGRATESDLG_H

#include "awfmtablewidget.h"
#include "model.h"
#include "well.h"
#include <QDialog>
#include <QDialogButtonBox>

class QLabel;
class QLineEdit;
class QComboBox;
class QGroupBox;
class QRadioButton;
class QCheckBox;
class QPushButton;

class PumpingRatesDlg : public QDialog {
    Q_OBJECT
private:
    AWFMTableWidget *rawTable;
    QLabel *recordCountLabel;
    QTableWidget *reducedTable;
    QDialogButtonBox *buttonBox;
    QList<awfm::Well> wells_; // A local copy of wells list to modify

    QLabel *wellsLabel;
    QComboBox *wellsComboBox;
    QCheckBox *applyToAllWellsCheckBox;

    QLabel *errorCodeLabel;
    QLineEdit *errorCodeLineEdit;
    QLabel *onErrorLabel;
    QComboBox *onErrorComboBox;

    QLabel* maxValueLabel;
    QLineEdit* maxValueLineEdit;
    QLabel* minValueLabel;
    QLineEdit* minValueLineEdit;
    QLabel* minMagnitudeLabel;
    QLineEdit* minMagnitudeLineEdit;

    QCheckBox *projectOntoLineCheckBox;
    QLabel* t0ProjectLabel;
    QLineEdit* t0ProjectLineEdit;
    QLabel* tfProjectLabel;
    QLineEdit* tfProjectLineEdit;
    QLabel* dtProjectLabel;
    QLineEdit* dtProjectLineEdit;

    QGroupBox *averagingGroupBox;
    QRadioButton *averageByToleranceRadio;
    QLineEdit *averageToleranceLineEdit;
    QRadioButton *averageBySignRadio;
    QRadioButton *noAveragingRadio;

    QPushButton *calculateButton;
    QPushButton *cancelButton;



public:
    PumpingRatesDlg(awfm::Model *model);
    void initWidgets();
    void initTables();
    void initLayout();
    void fillTableWithPumpingRates();
    void setRecordCount(int records);
    QList<awfm::Well> wells() { return wells_; }

public slots:
    void cellChanged(QTableWidgetItem *item);
    void import();
    void insertAbove(QList<int> selected_rows);
    void insertBelow(QList<int> selected_rows);
    void deleteRows(QList<int> selected_rows);
};




#endif // PUMPINGRATESDLG_H
