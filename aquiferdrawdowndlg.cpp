#include "aquiferdrawdowndlg.h"
#include "theis.h"

#include <QLabel>
#include <QLineEdit>
#include <QComboBox>
#include <QGridLayout>
#include <QDialogButtonBox>
#include <QVBoxLayout>
#include <QMessageBox>

AquiferDrawdownDlg::AquiferDrawdownDlg(awfm::Model *model)
{
    initWidgets();
    initLayout();

    awfm::AquiferDrawdownModel model_type = model->aquiferDrawdownModel()->modelType();
    if (model_type == awfm::THEIS) {
        methodComboBox->setCurrentText("Theis");
    } else if (model_type = awfm::HANTUSHJACOB) {
        methodComboBox->setCurrentText("Hantush-Jacob");
    } else {
        // Should not be reached;
    }
    methodToggled();
    fillWidgetsFromModel(model);
}

awfm::AquiferDrawdownModel AquiferDrawdownDlg::aquiferDrawdownModel()
{
    QString method_text = methodComboBox->currentText();
    if (method_text == "Theis") {
        return awfm::THEIS;
    } else if (method_text == "Hantush-Jacob") {
        return awfm::HANTUSHJACOB;
    } else {
        // This else statement will never be reached.
        // Return something to avoid warning.
        return awfm::THEIS;
    }
}

double AquiferDrawdownDlg::storativity()
{
    return storativityLineEdit->text().toDouble();
}

double AquiferDrawdownDlg::transmissivity()
{
    return transmissivityLineEdit->text().toDouble();
}

double AquiferDrawdownDlg::mpOverKp()
{
    return hjMpOverKpLineEdit->text().toDouble();
}

void AquiferDrawdownDlg::methodToggled()
{
    showTheisWidgets(false);
    showHantushJacobWidgets(false);

    switch (aquiferDrawdownModel()) {
    case awfm::THEIS:
        showTheisWidgets(true);
        return;
    case awfm::HANTUSHJACOB:
        showHantushJacobWidgets(true);
        return;
    }
}


void AquiferDrawdownDlg::initWidgets()
{
    methodLabel = new QLabel("Aquifer Drawdown Method: ");
    methodComboBox = new QComboBox();
    methodComboBox->addItems(QStringList()
                             << "Theis"
                             << "Hantush-Jacob");

    storativityLabel = new QLabel("Storativity: ");
    storativityLineEdit = new QLineEdit();
    transmissivityLabel = new QLabel("Transmissivity: ");
    transmissivityLineEdit = new QLineEdit();
    hjMpOverKpLabel = new QLabel("<sup>Aquitard Thickness</sup>&frasl;<sub>Vertical Conductivity</sub>: ");
    hjMpOverKpLineEdit = new QLineEdit();

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok
                                     | QDialogButtonBox::Cancel);

    connect(buttonBox, &QDialogButtonBox::accepted,
            this, &QDialog::accept);

    connect(buttonBox, &QDialogButtonBox::rejected,
            this, &QDialog::reject);

    connect(methodComboBox, SIGNAL(currentIndexChanged(int)),
            this, SLOT(methodToggled()));
}

void AquiferDrawdownDlg::initLayout()
{
    QGridLayout *gridLayout = new QGridLayout();
    gridLayout->addWidget(methodLabel, 0, 0);
    gridLayout->addWidget(methodComboBox, 0, 1);
    gridLayout->addWidget(storativityLabel, 1, 0);
    gridLayout->addWidget(storativityLineEdit, 1, 1);
    gridLayout->addWidget(transmissivityLabel, 2, 0);
    gridLayout->addWidget(transmissivityLineEdit, 2, 1);
    gridLayout->addWidget(hjMpOverKpLabel, 3, 0);
    gridLayout->addWidget(hjMpOverKpLineEdit, 3, 1);

    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addLayout(gridLayout);
    mainLayout->addWidget(buttonBox);

    setLayout(mainLayout);
}

void AquiferDrawdownDlg::fillWidgetsFromModel(awfm::Model *model)
{
    awfm::AquiferDrawdownModel model_type = model->aquiferDrawdownModel()->modelType();
    if (model_type == awfm::THEIS) {
        awfm::Theis *theisModel = (awfm::Theis*) model->aquiferDrawdownModel();
        transmissivityLineEdit->setText(QString("%1").arg(theisModel->T()));
        storativityLineEdit->setText(QString("%1").arg(theisModel->S()));
    } // TODO model_type == awfm::HANTUSHJACOB
}

void AquiferDrawdownDlg::showTheisWidgets(bool b)
{
    storativityLabel->setVisible(b);
    storativityLineEdit->setVisible(b);
    transmissivityLabel->setVisible(b);
    transmissivityLineEdit->setVisible(b);
}

void AquiferDrawdownDlg::showHantushJacobWidgets(bool b)
{
    storativityLabel->setVisible(b);
    storativityLineEdit->setVisible(b);
    transmissivityLabel->setVisible(b);
    transmissivityLineEdit->setVisible(b);
    hjMpOverKpLabel->setVisible(b);
    hjMpOverKpLineEdit->setVisible(b);
}

bool AquiferDrawdownDlg::formCompleted()
{
    awfm::AquiferDrawdownModel model_type = aquiferDrawdownModel();
    bool form_completed = true;
    if (model_type == awfm::THEIS) {
        form_completed =
                !transmissivityLineEdit->text().isEmpty()
                && !storativityLineEdit->text().isEmpty();
    }

    if (model_type == awfm::HANTUSHJACOB) {
        form_completed =
                !transmissivityLineEdit->text().isEmpty()
                && !storativityLineEdit->text().isEmpty()
                && !hjMpOverKpLineEdit->text().isEmpty();
    }

    return form_completed;
}

void AquiferDrawdownDlg::accept()
{
    if (!formCompleted()) {
        QMessageBox::information(this, "Cannot Proceed",
            "You must define the required parameters for chosen model before proceeding.",
            QMessageBox::Ok);
        return;
    } else {
        QDialog::accept();
    }
}


