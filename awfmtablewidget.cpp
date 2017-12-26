#include "awfmtablewidget.h"

#include <QDebug>
#include <QMouseEvent>

AWFMTableWidget::AWFMTableWidget(int nrows, int ncols, QStringList headers)
{
    headers_ = headers;
    setRowCount(nrows);
    setColumnCount(ncols);
    setHorizontalHeaderLabels(headers);
    setContextMenuPolicy(Qt::CustomContextMenu);
    connect(this, SIGNAL(customContextMenuRequested(const QPoint&)),
        this, SLOT(showContextMenu(const QPoint&)));

}

void AWFMTableWidget::showContextMenu(const QPoint &pos)
{
    QPoint globalPos = mapToGlobal(pos);

    QMenu menu;
    menu.addAction("Import");
    menu.addAction("Export");


    QAction* selectedItem = menu.exec(globalPos);
    if (selectedItem)
    {
        if (selectedItem->text() == "Import") {
            emit importSelected();
        } else if (selectedItem->text() == "Export") {
            emit exportSelected();
        }
    }
    else
    {
        // nothing was chosen
    }
}

