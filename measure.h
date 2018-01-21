#ifndef MEASURE_H
#define MEASURE_H

namespace awfm {
    typedef enum {
        VALUE, NOVALUE
    } MeasureState;

    class Measure
    {
    private:
        double t_;
        double v_;
        MeasureState measureState_;

    public:
        Measure(double t, double v);
        Measure(double t);

        double t() { return t_; }
        double v() { return v_; }
        MeasureState measureState() { return measureState_; }

        double setV(double v);

        void absolute();
        void scale(double s);
        void scaleT(double s);
        void scaleV(double s);
        void translateT(double dt);
        void translateV(double dv);
        void zeroBelow(double min_value);
    };
}

#endif // MEASURE_H
