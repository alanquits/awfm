#include <QFileDialog>
#include <QFileInfo>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QComboBox>
#include <QPushButton>
#include <QSizePolicy>
#include <QVBoxLayout>

#include "dbio.h"
#include "definitions.h"
#include "importdlg.h"
#include "abstractdataframe.h"
#include "sqlitedataframe.h"
#include "xlsxdataframe.h"

ImportDlg::ImportDlg(QStringList targets)
{
    targets_ = targets;
    initWidgets();
    initLayout();
    dfOnStack_ = false;
}

void ImportDlg::initWidgets()
{
    filePathLineEdit = new QLineEdit();
    browseButton = new QPushButton("&Browse");
    connect(browseButton, SIGNAL(clicked(bool)), this, SLOT(browseButtonClicked()));

    tableLabel = new QLabel("Table: ");
    tableComboBox = new QComboBox();
    connect(tableComboBox, SIGNAL(currentIndexChanged(QString)), this, SLOT(fillFieldComboBoxes(QString)));

    foreach(QString target_field, targets_) {
        fieldLabels[target_field] = new QLabel(target_field);
        fieldComboBoxes[target_field] = new QComboBox();
    }

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                     | QDialogButtonBox::Cancel);
    buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    connect(buttonBox, &QDialogButtonBox::accepted, this, &QDialog::accept);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &QDialog::reject);
}

void ImportDlg::initLayout()
{
    QVBoxLayout *mainLayout = new QVBoxLayout();

    QHBoxLayout *topLayout = new QHBoxLayout();
    topLayout->addWidget(filePathLineEdit);
    topLayout->addWidget(browseButton);
    mainLayout->addLayout(topLayout);

    QGridLayout *centerLayout = new QGridLayout();
    centerLayout->addWidget(tableLabel, 0, 0, 1, 1);
    centerLayout->addWidget(tableComboBox, 0, 1, 1, 2);
    int row = 0;
    foreach (QString target_field, targets_) {
        centerLayout->addWidget(fieldLabels[target_field], row, 3, 1, 1);
        centerLayout->addWidget(fieldComboBoxes[target_field], row, 4, 1, 2);
        row++;
    }
    mainLayout->addLayout(centerLayout);
    mainLayout->addWidget(buttonBox);

    setLayout(mainLayout);
}

void ImportDlg::fillTableComboBox()
{
    QStringList tables = df_->tables();
    tableComboBox->addItems(tables);
}

void ImportDlg::fillFieldComboBoxes(QString table)
{
    df_->setTable(table);
    QStringList fields = df_->fieldNames();
    foreach (QString key, fieldComboBoxes.keys()) {
        fieldComboBoxes[key]->clear();
        fieldComboBoxes[key]->addItems(fields);
    }
    if (!df_->hasError()) {
        buttonBox->button(QDialogButtonBox::Ok)->setEnabled(true);
    }
}

void ImportDlg::setDataFrame()
{
    QFileInfo fi(file_);

    if (dfOnStack_) {
        delete df_;
        buttonBox->button(QDialogButtonBox::Ok)->setEnabled(false);
    }
    if (fi.suffix() == "db") {
        awfm::SQLiteDataframe *sqliteDf = new awfm::SQLiteDataframe(fi.absoluteFilePath());
        df_ = sqliteDf;
        dfOnStack_ = true;
    } else if (fi.suffix() == "xlsx") {
        awfm::XlsxDataFrame *xlsxDf = new awfm::XlsxDataFrame(fi.absoluteFilePath());
        df_ = xlsxDf;
        dfOnStack_ = true;
    } else {
        dfOnStack_ = false;
    }
}

QMap<QString, QString> ImportDlg::getTargetMap()
{
    QMap<QString, QString> m;
    foreach(QString target_field, fieldComboBoxes.keys()) {
        QString source_field = fieldComboBoxes[target_field]->currentText();
        m[target_field] = source_field;
    }
    return m;
}

void ImportDlg::accept()
{
    QDialog::accept();
}

void ImportDlg::reject()
{
    if (dfOnStack_) {
        delete df_;
    }
    QDialog::reject();
}

void ImportDlg::browseButtonClicked()
{
    QString file_name = QFileDialog::getOpenFileName(this,
        tr("Import"), "", tr("Dataframes (*.xlsx *.db *.csv)"));
    filePathLineEdit->setText(file_name);

    file_.setFileName(file_name);
    if (file_.exists()) {
        setDataFrame();
    } else {
        fileSelected_ = false;
    }

    fillTableComboBox();
}
