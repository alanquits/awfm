#ifndef MEASURE_H
#define MEASURE_H

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

    void absolute();
    void scale(double s);
    void zeroBelow(double min_value);
};

#endif // MEASURE_H
