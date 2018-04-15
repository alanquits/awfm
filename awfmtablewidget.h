#ifndef AWFMTABLEWIDGET_H
#define AWFMTABLEWIDGET_H

#include <QMenu>
#include <QPoint>
#include <QTableWidget>
#include <QStringList>

class AWFMTableWidget: public QTableWidget {

    Q_OBJECT

private:
    QStringList headers_;

public:
    AWFMTableWidget(int nrows, int ncols, QStringList headers);

public slots:
    void showContextMenu(const QPoint &p);
    void showVerticalHeaderContextmenu(const QPoint &p);
    void setColumnEditable(int column_idx, bool editable);
    virtual void exportTable();

signals:
    void importSelected();
    void exportSelected();
    void insertAboveSelected(QList<int>);
    void insertBelowSelected(QList<int>);
    void deleteRowsSelected(QList<int>);



};



#endif
