#include <complex>
#include <mlir/Support/LLVM.h>
#include <vector>
#include <mlir/Support/LogicalResult.h>
#include <Eigen/Dense>
#include <isq/Math.h>
using namespace Eigen;
namespace isq {
namespace ir {
namespace math {

struct Mat : public Fwd<Matrix<std::complex<double>, Dynamic, Dynamic>> {};

::mlir::Optional<size_t> checkDimensionality(InputMatrix &mat) {
    auto sz = mat.body->size();
    for (auto &row : *mat.body) {
        if (row.size() != sz)
            return {};
    }
    return sz;
}
void MatDel::operator()(Mat *m) { delete m; }
std::unique_ptr<Mat, MatDel> toEigenMatrix(InputMatrix &mat) {
    auto sz = checkDimensionality(mat);
    if (!sz.hasValue())
        return {};
    auto s = sz.getValue();
    Mat::Ty *m = new Mat::Ty(s, s);
    for (auto i = 0; i < s; i++) {
        for (auto j = 0; j < s; j++) {
            (*m)(i, j) = (*mat.body)[i][j];
        }
    }
    Mat *mm = new Mat;
    mm->body = std::unique_ptr<Mat::Ty>(m);
    MatDel del;
    return std::unique_ptr<Mat, MatDel>(mm, del);
}

bool isUnitary(Mat &mat, double eps) { return mat->isUnitary(eps); }

bool isHermitian(Mat &mat, double eps) {
    return mat->isApprox(mat->transpose().conjugate(), eps);
}
bool isSymmetric(Mat &mat, double eps) {
    return true; // TODO
}
bool isDiagonal(Mat &mat, double eps) { return mat->isDiagonal(eps); }
bool isAntiDiagonal(Mat &mat, double eps) {
    auto size = mat->diagonalSize();

    Mat::Ty antieye = Mat::Ty::Zero(size, size);
    for (auto i = 0; i < size; i++) {
        antieye(i, size - 1 - i) = 1;
    }
    auto filtered = mat->cwiseProduct(antieye);
    return mat->isApprox(filtered, eps);
}
} // namespace math
} // namespace ir
} // namespace isq
