#include "minpack.h"
#include <cmath>
#include <stdio.h>
#include <stdlib.h>

MinPackParameters::MinPackParameters(int m, int n) {
    set_m(m);
    set_n(n);
    set_ftol(1e-6);
    set_gtol(1e-6);
    set_xtol(1e-6);
    set_maxfev(2000);
    set_epsfcn(1e-6);
}

bool lmdif(void (*fcn) (int*, int*, double*, double*, int*),
        MinPackParameters *mp, std::string *message) {

    if (mp->n() > mp->m()) {
        message->assign("Number of fitting parameters cannot be larger than number of observed data");
        return false;
    }

    double *fvec = (double*) malloc(mp->m()*sizeof(double));
    double *diag = (double*) malloc(mp->n()*sizeof(double));
    double *fjac = (double*) malloc(mp->m()*mp->n()*sizeof(double));
    int *ipvt = (int*) malloc(mp->n()*sizeof(double));
    double *qtf = (double*) malloc(mp->n()*sizeof(double));
    double *wa1 = (double*) malloc(mp->n()*sizeof(double));
    double *wa2 = (double*) malloc(mp->n()*sizeof(double));
    double *wa3 = (double*) malloc(mp->n()*sizeof(double));
    double *wa4 = (double*) malloc(mp->m()*sizeof(double));

    int mode = 1;
    double factor = 100;
    int nprint = -1;

    int info;
    int nfev;

    int m = mp->m();
    int n = mp->n();
    double ftol = mp->ftol();
    double xtol = mp->xtol();
    double gtol = mp->gtol();
    int maxfev = mp->maxfev();
    double epsfcn = mp->epsfcn();

    lmdif_(fcn,
      &m, &n, mp->x(), fvec,
      &ftol, &xtol, &gtol,
      &maxfev, &epsfcn, diag,
      &mode, &factor, &nprint,
      &info, &nfev, fjac, &m,
      ipvt, qtf, wa1, wa2,
      wa3, wa4);

    // Free
    free(fvec);
    free(diag);
    free(fjac);
    free(ipvt);
    free(qtf);
    free(wa1);
    free(wa2);
    free(wa3);
    free(wa4);

    switch(info) {
    case 0:
        message->assign("Improper input parameters.");
        return false;
    case 1:
        message->assign("Both actual and predicted relative reductions "
                        "in the sum of squares at most ftol.");
        return true;
    case 2:
        message->assign("Relative error between two consecutive iterates "
                        "is at most xtol.");
        return true;
    case 3:
        message->assign("Both actual and predicted relative reductions "
                        "in the sum of squares at most ftol and "
                        "relative error between two consecutive iterates "
                        "is at most xtol.");
        return true;
    case 4:
        message->assign("The cosine of the angle between fvec and any "
                        "column of the jacobian is at most gtol in "
                        "absolute value.");
        return true;
    case 5:
        message->assign("Number of calls to fcn has reached or "
                        "exceeded maxfev.");
        return false;
    case 6:
        message->assign("ftol is too small. No further reduction in "
                        "the sum of squares is possible.");
        return false;
    case 7:
        message->assign("xtol is too small. No further improvement in "
                        "the approximate solution x is possible.");
        return false;
    case 8:
        message->assign("gtol is too small. fvec is orthogonal to the "
                        "columns of the jacobian to machine precision.");
        return false;
    }

    message->assign("<i>info</i> variable returned from <b>lmdif</b> function "
                    "in minpack does not make sense. Please submit a bug report.");
    return false;
}
