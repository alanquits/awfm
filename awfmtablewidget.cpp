#include "awfmtablewidget.h"

#include <QDebug>
#include <QHeaderView>
#include <QModelIndexList>
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

    QHeaderView *vertical_header = verticalHeader();
    vertical_header->setContextMenuPolicy(Qt::CustomContextMenu);
    connect(vertical_header, SIGNAL(customContextMenuRequested(QPoint)),
            this, SLOT(showVerticalHeaderContextmenu(QPoint)));

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

void AWFMTableWidget::showVerticalHeaderContextmenu(const QPoint &pos)
{
    QList<int> selected_rows;
    QModelIndexList selection = selectionModel()->selectedRows();
    for(int i=0; i< selection.count(); i++)
    {
        QModelIndex index = selection.at(i);
        selected_rows.push_back(index.row());
    }

    QPoint globalPos = mapToGlobal(pos);

    QMenu menu;
    menu.addAction("Insert Above");
    menu.addAction("Insert Below");
    menu.addAction("Delete");

    QAction* selectedItem = menu.exec(globalPos);
    if (selectedItem)
    {
        if (selectedItem->text() == "Insert Above") {
            emit insertAboveSelected(selected_rows);
        } else if (selectedItem->text() == "Insert Below") {
            emit insertBelowSelected(selected_rows);
        } else if (selectedItem->text() == "Delete") {
            emit deleteRowsSelected(selected_rows);
        }
    }
    else
    {
        // nothing was chosen
    }
}

void AWFMTableWidget::setColumnEditable(int column_idx, bool editable)
{
    QFont font;
    bool is_italic = editable ? false : true;
    font.setItalic(is_italic);

    QColor color = editable ? QColor(0, 0, 0)         // black
                            : QColor(230, 230, 230);  // light gray

    for (int row = 0; row < rowCount(); row++) {
        QTableWidgetItem *twi = item(row, column_idx);
        twi->setTextColor(color);
        twi->setFont(font);
        if (editable) {
            twi->setFlags(Qt::ItemIsSelectable|Qt::ItemIsEditable|Qt::ItemIsEnabled);
        } else {
            twi->setFlags(twi->flags() &  ~Qt::ItemIsEditable);
        }
    }
}

