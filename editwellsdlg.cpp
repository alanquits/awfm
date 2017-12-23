#include "editwellsdlg.h"

#include <QStringList>
#include <QVBoxLayout>

EditWellsDlg::EditWellsDlg()
{
    setWindowTitle("Edit Wells");
    initTable();
    initLayout();
}

    void EditWellsDlg::initTable()
{
    table = new QTableWidget();
    table->setColumnCount(5);
    table->setRowCount(5);
    QStringList headers;
    headers << "Name" << "X" << "Y" << "rw" << "h0";
    table->setHorizontalHeaderLabels(headers);
}

void EditWellsDlg::initLayout()
{
    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addWidget(table);
    setLayout(mainLayout);
}
