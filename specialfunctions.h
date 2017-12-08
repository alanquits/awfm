#ifndef SPECIALFUNCTIONS_H
#define SPECIALFUNCTIONS_H

#include <cmath>

#ifdef __cplusplus
extern "C" {
#endif
    double dfac_(int*);
    double dbesk0_(double*);
    double de1_(double*);
#ifdef __cplusplus
}
#endif

double Factorial(int n);
double K0(double x);
double W(double u);

#endif // SPECIALFUNCTIONS_H
