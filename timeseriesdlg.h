#ifndef TIMESERIESDLG_H
#define TIMESERIESDLG_H

#include "awfmtablewidget.h"
#include "model.h"
#include "well.h"

#include <QDialog>
#include <QDialogButtonBox>
#include <QMap>

class QDialogButtonBox;
class QLabel;
class QLineEdit;
class QComboBox;
class QGroupBox;
class QRadioButton;
class QCheckBox;
class QPushButton;
class QWidget;

class TimeseriesDlg : public QDialog {
    Q_OBJECT
private:
    AWFMTableWidget *rawTable;
    QLabel *recordCountLabel;

    QStringList wellNames_;
    QList<awfm::Timeseries> timeseriesList_;
    QString valueTableHeader_;

    QLabel *methodLabel;
    QComboBox *methodComboBox;
    QLabel *wellsLabel;
    QComboBox *wellsComboBox;
    QCheckBox *applyToAllWellsCheckBox;

    QMap<QString, QWidget*> editWidgets;

    QLabel *errorCodeLabel;
    QLineEdit *errorCodeLineEdit;
    QLabel *onErrorLabel;
    QComboBox *onErrorComboBox;
    QPushButton *applyErrorCodeButton;

    QLabel* maxValueLabel;
    QLineEdit* maxValueLineEdit;
    QLabel* minValueLabel;
    QLineEdit* minValueLineEdit;
    QLabel* minMagnitudeLabel;
    QLineEdit* minMagnitudeLineEdit;
    QPushButton *applyRangeButton;

    QLabel* t0ProjectLabel;
    QLineEdit* t0ProjectLineEdit;
    QLabel* tfProjectLabel;
    QLineEdit* tfProjectLineEdit;
    QLabel* dtProjectLabel;
    QLineEdit* dtProjectLineEdit;
    QPushButton *applyProjectionButton;

    QGroupBox *averagingGroupBox;
    QRadioButton *averageByToleranceRadio;
    QLineEdit *averageToleranceLineEdit;
    QRadioButton *averageBySignRadio;
    QPushButton *applyAveragingButton;

    QLabel *scaleTLabel;
    QLineEdit *scaleTLineEdit;
    QLabel *scaleVLabel;
    QLineEdit *scaleVLineEdit;
    QPushButton *scaleApplyButton;

    QLabel *translateTLabel;
    QLineEdit *translateTLineEdit;
    QLabel *translateVLabel;
    QLineEdit *translateVLineEdit;
    QPushButton *translateApplyButton;

    QDialogButtonBox *buttonBox;



public:
    // Map<"WellName", Timeseries>
    TimeseriesDlg(QStringList well_names, QList<awfm::Timeseries> time_series_s,
                  QString window_title, QString value_table_header);
    void initWidgets();
    void initTables();
    void initMethodLayouts();
    void initLayout();
    void setRecordCount(int records);
    QList<awfm::Timeseries> timeseriesList() { return timeseriesList_; }

public slots:
    void methodChanged();
    void applyAveragingButtonClicked();
    void applyErrorCodeButtonClicked();
    void applyRangeButtonClicked();
    void applyProjectionButtonClicked();
    void scaleButtonClicked();
    void translateButtonClicked();
    void cellChanged(QTableWidgetItem *item);
    void import();
    void insertAbove(QList<int> selected_rows);
    void insertBelow(QList<int> selected_rows);
    void deleteRows(QList<int> selected_rows);
    void fillTable();
};




#endif // TIMESERIESDLG_H
