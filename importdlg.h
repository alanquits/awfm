#ifndef IMPORTDLG_H
#define IMPORTDLG_H

#include <QDialog>

#include <QDialogButtonBox>
#include <QFile>
#include <QMap>
#include <QString>
#include <QStringList>

#include "abstractdataframe.h"
#include "definitions.h"

class QLabel;
class QLineEdit;
class QComboBox;
class QPushButton;

class ImportDlg : public QDialog {
  Q_OBJECT
  private:
    awfm::AbstractDataFrame *df_;
    bool fileSelected_;
    QFile file_;
    awfm::SourceFileType fileType_;
    bool dfOnStack_;

    QStringList targets_;

    QLineEdit *filePathLineEdit;
    QPushButton *browseButton;

    QLabel *tableLabel;
    QComboBox *tableComboBox;

    QMap<QString, QComboBox*> fieldComboBoxes;
    QMap<QString, QLabel*> fieldLabels;

    QDialogButtonBox *buttonBox;

public:
    ImportDlg(QStringList targets);

    awfm::AbstractDataFrame* df() { return df_; }
    void initWidgets();
    void initLayout();
    void fillTableComboBox();
    void setDataFrame();
    QMap<QString, QString> getTargetMap();

public slots:
    void accept();
    void reject();
    void browseButtonClicked();
    void fillFieldComboBoxes(QString table);
};

#endif
