#pragma once
#include <cstddef>
#include <memory>

namespace MatrixProf {

// align to cache line
constexpr size_t CACHE_LINE_SIZE = 64;

class AlignedMatrix {
private:
	std::unique_ptr<float[], void(*)(void*)> data_;
	size_t cols_, rows_;
	size_t padded_cols_; // align for vector operation

public:
	AlignedMatrix(size_t cols_, size_t rows_);
	AlignedMatrix(const AlignedMatrix& other);
	AlignedMatrix(AlignedMatrix&& other) noexcept;

	//base operations
	float& operator()(size_t i, size_t j) noexcept;
	const float& operator()(size_t i, size_t j) const noexcept;

	// professional methods
	void clear() noexcept;
	void identity() noexcept;
	void randomize(float min = 0.0f , float max = 1.0f) noexcept;

	float* data() noexcept { return data_.get(); }
	const float* data() const noexcept { return data_.get(); }
	size_t cols() const noexcept { return cols_; }
	size_t rows() const noexcept { return rows_; }
	size_t stride() const noexcept { return padded_cols_; }

	// optimized operations
	void multiply(const AlignedMatrix& A, const AlignedMatrix& B);
	void add(const AlignedMatrix& A, const AlignedMatrix& B);
	void transpose(const AlignedMatrix& A);

	// SIMD versions
	void multiply_sse(const AlignedMatrix& A, const AlignedMatrix& B);
	void multiply_avx(const AlignedMatrix& A, const  AlignedMatrix& B);
	void multiply_avx512(const AlignedMatrix& A, const AlignedMatrix& B);

};

// low-level functions
extern "C" {
	void matrix_multiply_sse_asm(const float* A, const float* B, float* C, size_t rows_A, size_t colsA, size_t colsB);
	void matrix_multiply_avx_asm(const float* A, const float* B, float* C, size_t rows_A, size_t colsA, size_t colsB);
	void matrix_transpose_sse_asm(const float* src, const float* dst, size_t rows, size_t cols);
}
} // namespace MatrixProf
