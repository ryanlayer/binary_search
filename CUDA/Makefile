CPP=g++
SDK_PATH=$(HOME)/NVIDIA_GPU_Computing_SDK
SDK_COMMON_INC=$(SDK_PATH)/C/common/inc
SDK_SHARED_INC=$(SDK_PATH)/C/shared/inc
CUDA_INCLUDE=/usr/local/cuda/include
NVCC=/usr/local/cuda/bin/nvcc
INCLUDE=-I. \
		-I$(CUDA_INCLUDE) \
		-I$(SDK_COMMON_INC) \
	   	-I$(SDK_SHARED_INC)
CFLAGS=
LFLAGS_A=-fPIC
LFLAGS_B=-L/usr/local/cuda/lib64 \
		-L$(SDK_PATH)/C/lib \
		-L$(SDK_PATH)/C/common/lib/linux \
		-L$(SDK_PATH)/shared/lib \
		-lcudart \
		-lcudpp_x86_64 

NVCC_OPTS=-DUNIX -O2

TIMER_FILE_OBJS=../lib/timer.o

OBJS= $(TIMER_FILE_OBJS)

TIMER_FILE_SRC=../lib/timer.c

SRC= $(TIMER_FILE_SRC)

EXECS=pre_gm_index_wbsearch_gm_cuda \
	  b_search \
	  i_gm_b_search \
	  i_sm_b_search \
	  t_gm_b_search \
	  t_sm_b_search

.SUFFIXES: .c .cpp .cu .o

pre_gm_index_wbsearch_gm_cuda: radixsort.cu.o \
			  radixsort.o \
			  random.cu.o \
			  pre_gm_index_wbsearch_gm_cuda.cu.o
	$(CPP) $(LFLAGS_A) -o $@ \
		$(SRC) \
		radixsort.cu.o \
		random.cu.o \
		radixsort.o \
		pre_gm_index_wbsearch_gm_cuda.cu.o \
		$(LFLAGS_B)

b_search: radixsort.cu.o \
			  radixsort.o \
			  random.cu.o \
			  b_search_lib.cu.o \
			  b_search.cu.o
	$(CPP) $(LFLAGS_A) -o $@ \
		$(SRC) \
		radixsort.cu.o \
		random.cu.o \
		radixsort.o \
		b_search.cu.o \
		b_search_lib.cu.o \
		$(LFLAGS_B)

i_gm_b_search: radixsort.cu.o \
			  radixsort.o \
			  random.cu.o \
			  b_search_lib.cu.o \
			  i_gm_b_search.cu.o
	$(CPP) $(LFLAGS_A) -o $@ \
		$(SRC) \
		radixsort.cu.o \
		random.cu.o \
		radixsort.o \
		i_gm_b_search.cu.o \
		b_search_lib.cu.o \
		$(LFLAGS_B)

i_sm_b_search: radixsort.cu.o \
			  radixsort.o \
			  random.cu.o \
			  b_search_lib.cu.o \
			  i_sm_b_search.cu.o
	$(CPP) $(LFLAGS_A) -o $@ \
		$(SRC) \
		radixsort.cu.o \
		random.cu.o \
		radixsort.o \
		i_sm_b_search.cu.o \
		b_search_lib.cu.o \
		$(LFLAGS_B)

t_gm_b_search: radixsort.cu.o \
			  radixsort.o \
			  random.cu.o \
			  b_search_lib.cu.o \
			  t_gm_b_search.cu.o
	$(CPP) $(LFLAGS_A) -o $@ \
		$(SRC) \
		radixsort.cu.o \
		random.cu.o \
		radixsort.o \
		t_gm_b_search.cu.o \
		b_search_lib.cu.o \
		$(LFLAGS_B)

t_sm_b_search: radixsort.cu.o \
			  radixsort.o \
			  random.cu.o \
			  b_search_lib.cu.o \
			  t_sm_b_search.cu.o
	$(CPP) $(LFLAGS_A) -o $@ \
		$(SRC) \
		radixsort.cu.o \
		random.cu.o \
		radixsort.o \
		t_sm_b_search.cu.o \
		b_search_lib.cu.o \
		$(LFLAGS_B)



%.cu.o: %.cu
	$(NVCC)  $(INCLUDE) -c $< -o $@

%.o: %.cpp
	$(CPP)  $(INCLUDE) -c $< -o $@

clean:
	rm -f $(EXECS) *.a *.o $(LIBS) $(OBJS)
