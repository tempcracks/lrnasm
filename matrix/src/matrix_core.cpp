#include <matrix.h>
#include <immintrin.h>
#include <cstdlib>
#include <cstring>
#include <random>

namespace MatrixProf {
	// professional allocator  with align
	static void* aligned_malloc(size_t size, size_t alignment){
		void* ptr;
		if(posix_memalign(&ptr, alignment, size) != 0){
			throw std::bad_alloc();
		}
		return ptr;
	}
	static void aligned_free(void* ptr){
		free(ptr);
	}
	AlignedMatrix::AlignedMatrix(size_t rows, size_t cols)
		: data_(nullptr, aligned_free),
			rows_(rows),
			cols_(cols)
		{
			// align cols for vector operations
			padded_cols_ = (cols + 7) & ~7; //align to 8 elements
			size_t total_size = rows * padded_cols_ * sizeof(float);
			void* raw_ptr = aligned_malloc( total_size, CACHE_LINE_SIZE);
			data_.reset(static_cast<float*>(raw_ptr));

			//initialization null
			clear();
		}

	void AlignedMatrix::clear() noexcept{
		std::memset(data_.get(), 0 , rows_ * padded_cols_ * sizeof(float));
	}
	
	// multiply on avx2 with immintrin
	void AlignedMatrix::multiply_avx(const AlignedMatrix& A, const AlignedMatrix& B){
		if (A.cols() != B.rows() || rows_ != A.rows() || cols_ != B.cols()) {
			throw std::invalid_argument("matrix dimensions mismatch");
		}
		const size_t block_size = 64;

		for (size_t i_block = 0; i_block < A.rows(); i_block += block_size){
			for (size_t j_block = 0 ; j_block < B.cols(); j_block += block_size){
				for ( size_t k_block = 0 ; k_block < A.cols(); k_block += block_size){

					for (size_t i = i_block ; i < std::min(i_block + block_size, A.rows()); ++i){
						for (size_t j = j_block ; j < std::min(j_block + block_size, B.cols()); j += 8){
							__m256 acc = _mm256_setzero_ps();
							for (size_t k = k_block; k < std::min(k_block + block_size,  A.cols());  ++k){
								__m256 a_vec = _mm256_set1_ps(A(i,k));
								__m256 b_vec = _mm256_load_ps(&B(k,j));
								acc = _mm256_fmadd_ps(a_vec, b_vec, acc);
							}

							// accumulation result
							__m256  existing = _mm256_load_ps(&(*this)(i,j));
							existing  = _mm256_add_ps(existing, acc);
							_mm256_store_ps(&(*this)(i,j), existing);
						}
					}
				}
			}
		}
	}
} // namespace MatrixProf
