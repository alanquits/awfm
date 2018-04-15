#ifndef MINPACK_H
#define MINPACK_H

#include <cmath>
#include <string>

class MinPackParameters;

bool lmdif(void (*fcn) (int*, int*, double*, double*, int*),
        MinPackParameters *m, std::string *message);

extern "C" {
	void lmdif_(void (*fcn) (int*, int*, double*, double*, int*),
		    int *m, int *n, double *x, double *fvec,
		    double *ftol, double *xtol, double *gtol,
		    int *maxfev, double *epsfcn, double *diag,
		    int *mode, double *factor, int *nprint,
		    int *info, int *nfev, double *fjac, int *ldfjac,
		    int *ipvt, double *qtf, double *wa1, double *wa2,
		    double *wa3, double *wa4);
}

class MinPackParameters {
private:
    double ftol_;
    double xtol_;
    double gtol_;
    int info_;
    int maxfev_;
    int m_;
    int n_;
    double *x_; // initial guess at solution array
    int nfev_;
    double epsfcn_;

public:
    MinPackParameters(int m, int n);

    double ftol() { return ftol_; }
    double xtol() { return xtol_; }
    double gtol() { return gtol_; }
    int maxfev() { return maxfev_; }
    int m() { return m_; }
    int n() { return n_; }
    double* x() { return x_; }
    double epsfcn() { return epsfcn_; }

    void set_ftol(double ftol) { ftol_ = fabs(ftol); }
    void set_xtol(double xtol) { xtol_ = fabs(xtol); }
    void set_gtol(double gtol) { gtol_ = fabs(gtol); }
    void set_maxfev(int maxfev) { maxfev_ = abs(maxfev); }
    void set_m(int m) { m_ = m; }
    void set_n(int n) { n_ = n; }
    void set_epsfcn(double epsfcn) { epsfcn_ = epsfcn; }
    void set_x(double *x) { x_ = x; } // Note: please allocate before setting. Deallocate when finished.
};

#endif
