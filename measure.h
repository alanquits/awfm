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

    double t() { return t(); }
    double v() { return v(); }
    MeasureState measureState() { return measureState_; }
};

#endif // MEASURE_H
