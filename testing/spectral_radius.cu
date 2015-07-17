#include <unittest/unittest.h>

#include <cusp/ell_matrix.h>
#include <cusp/coo_matrix.h>
#include <cusp/csr_matrix.h>
#include <cusp/dia_matrix.h>
#include <cusp/hyb_matrix.h>

#include <cusp/array2d.h>

#include <cusp/eigen/spectral_radius.h>
#include <cusp/eigen/arnoldi.h>

#include <cusp/gallery/poisson.h>

template <class SparseMatrix>
void TestEstimateSpectralRadius(void)
{
    typedef typename SparseMatrix::value_type   ValueType;
    typedef typename SparseMatrix::memory_space MemorySpace;

    // 2x2 diagonal matrix
    {
        cusp::csr_matrix<int,ValueType,cusp::host_memory> A(2,2,2);
        A.row_offsets[0] = 0;
        A.row_offsets[1] = 1;
        A.row_offsets[2] = 2;
        A.column_indices[0] = 0;
        A.column_indices[1] = 1;
        A.values[0] = -5;
        A.values[1] =  2;

        float rho = 5.0;

        SparseMatrix B(A);
        ASSERT_EQUAL((std::abs(cusp::eigen::estimate_spectral_radius(B) - rho) / rho) < 0.1f, true);
        ASSERT_EQUAL((std::abs(cusp::eigen::ritz_spectral_radius(B) - rho) / rho) < 0.1f, true);
        ASSERT_EQUAL((std::abs(cusp::eigen::ritz_spectral_radius(B,10,true) - rho) / rho) < 0.1f, true);
        /* ASSERT_EQUAL((std::abs(cusp::eigen::disks_spectral_radius(B) - rho) / rho) < 0.1f, true); */
    }

    // 2x2 Poisson problem
    {
        SparseMatrix A;
        cusp::gallery::poisson5pt(A, 2, 2);

        float rho = 6.0;

        ASSERT_EQUAL((std::abs(cusp::eigen::estimate_spectral_radius(A) - rho) / rho) < 0.1f, true);
        ASSERT_EQUAL((std::abs(cusp::eigen::ritz_spectral_radius(A) - rho) / rho) < 0.1f, true);
        ASSERT_EQUAL((std::abs(cusp::eigen::ritz_spectral_radius(A,10,true) - rho) / rho) < 0.1f, true);
        /* ASSERT_EQUAL((std::abs(cusp::eigen::disks_spectral_radius(A) - rho) / rho) < 0.1f, true); */
    }

    // 4x4 Poisson problem
    {
        SparseMatrix A;
        cusp::gallery::poisson5pt(A, 4, 4);

        float rho = 7.2360679774997871;

        ASSERT_EQUAL((std::abs(cusp::eigen::estimate_spectral_radius(A) - rho) / rho) < 0.1f, true);
        ASSERT_EQUAL((std::abs(cusp::eigen::ritz_spectral_radius(A) - rho) / rho) < 0.1f, true);
        ASSERT_EQUAL((std::abs(cusp::eigen::ritz_spectral_radius(A,10,true) - rho) / rho) < 0.1f, true);
        /* ASSERT_EQUAL((std::abs(cusp::eigen::disks_spectral_radius(A) - rho) / rho) < 0.11f, true); */
    }

    // TODO test larger sizes and non-symmetric matrices
}
DECLARE_SPARSE_MATRIX_UNITTEST(TestEstimateSpectralRadius);

