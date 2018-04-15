#include "minpacksettingsdlg.h"
#include "minpack.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>

void MinPackSettingsDlg::initWidgets()
{
    ftolLabel = new QLabel("ftol: ");
    gtolLabel = new QLabel("gtol: ");
    xtolLabel = new QLabel("xtol: ");
    maxfevLabel = new QLabel("maxfev: ");
    epsfcnLabel = new QLabel("epsfcn: ");

    ftolLineEdit = new QLineEdit();
    ftolLineEdit->setText(QString::number(mp_->ftol()));
    ftolLineEdit->setToolTip("<b>ftol</b> is a nonnegative input variable. termination occurs when "
                              "both the actual and predicted relative reductions in "
                              "the sum of squares are at most ftol. Therefore, ftol "
                              "measures the relative error desired in the sum of squares.");
    gtolLineEdit = new QLineEdit();
    gtolLineEdit->setText(QString::number(mp_->gtol()));
    gtolLineEdit->setToolTip("<b>gtol</b> is a nonnegative input variable. termination occurs when the "
                             "cosine of the angle between fvec and any column of the jacobian "
                             "is at most gtol in absolute value. therefore, gtol measures the "
                             "orthogonality desired between the function vector and the columns "
                             "of the jacobian.");
    xtolLineEdit = new QLineEdit();
    xtolLineEdit->setText(QString::number(mp_->xtol()));
    xtolLineEdit->setToolTip("<b>xtol</b> is a nonnegative input variable. termination occurs when the "
                             "relative error between two consecutive iterates is at most xtol. therefore, "
                             "xtol measures the relative error desired in the approximate solution.");
    maxfevLineEdit = new QLineEdit();
    maxfevLineEdit->setText(QString::number(mp_->maxfev()));
    maxfevLineEdit->setToolTip("<b>maxfev</b> is a positive integer input variable. termination occurs when "
                               "the number of calls to fcn is at least maxfev by the end of an iteration.");
    epsfcnLineEdit = new QLineEdit();
    epsfcnLineEdit->setText(QString::number(mp_->epsfcn()));
    epsfcnLineEdit->setToolTip("<b>epsfcn</b> is an input variable used in determining a suitable step length "
                               "for the forward-difference approximation. this approximation assumes that the "
                               "relative errors in the functions are of the order of epsfcn. if epsfcn is less "
                               "than the machine precision, it is assumed that the relative errors in the "
                               "functions are of the order of the machine precision.");

    buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel);
    connect(buttonBox, &QDialogButtonBox::accepted, this, &MinPackSettingsDlg::accept);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &QDialog::reject);
}

void MinPackSettingsDlg::initLayout()
{
    QGridLayout *optionsBox = new QGridLayout();
    optionsBox->addWidget(ftolLabel, 0, 0);
    optionsBox->addWidget(ftolLineEdit, 0, 1);
    optionsBox->addWidget(gtolLabel, 1, 0);
    optionsBox->addWidget(gtolLineEdit, 1, 1);
    optionsBox->addWidget(xtolLabel, 2, 0);
    optionsBox->addWidget(xtolLineEdit, 2, 1);
    optionsBox->addWidget(maxfevLabel, 3, 0);
    optionsBox->addWidget(maxfevLineEdit, 3, 1);
    optionsBox->addWidget(epsfcnLabel, 4, 0);
    optionsBox->addWidget(epsfcnLineEdit, 4, 1);

    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addLayout(optionsBox);
    mainLayout->addWidget(buttonBox);

    setLayout(mainLayout);
}

MinPackSettingsDlg::MinPackSettingsDlg(MinPackParameters *mp)
{
    mp_ = mp;
    initWidgets();
    initLayout();
}

void MinPackSettingsDlg::accept()
{
    mp_->set_ftol(ftolLineEdit->text().toDouble());
    mp_->set_gtol(gtolLineEdit->text().toDouble());
    mp_->set_xtol(xtolLineEdit->text().toDouble());
    mp_->set_maxfev(maxfevLineEdit->text().toInt());
    mp_->set_epsfcn(epsfcnLineEdit->text().toDouble());
    QDialog::accept();
}
