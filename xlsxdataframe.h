#include "abstractdataframe.h"
#include "xlnt/xlnt.hpp"

namespace awfm {
    class XlsxDataFrame : public AbstractDataFrame {

    private:
        xlnt::workbook wb_;
        xlnt::worksheet ws_;
        int currentRow_;

    public:
        XlsxDataFrame(QString db_path);
        ~XlsxDataFrame();

        virtual QStringList tables();
        virtual void setTable(QString table_name);
        virtual int columnIndex(QString);
        virtual void windUp();
        virtual bool nextRow();
        virtual QString getString(int column_idx);
        virtual int getInt(int column_idx);
        virtual double getDouble(int column_idx);
        virtual bool isNull(int column_idx);
        virtual void collectFieldNames();
    };
}
