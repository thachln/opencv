REM @ECHO OFF
set "openCvSource=%CD%"

cd ..
set "openCVExtraModules=%CD%\opencv_contrib\modules"
set "openCvBuild=%CD%\build_vs2019"

cd %openCvSource%
set "buildType=Release"

set "generator=MinGW Makefiles"
REM set "generator=Visual Studio 16 2019"
REM set "CUDA_PATH=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.2"

REM set "PYTHON3_EXECUTABLE=C:\Users\ThachLN\anaconda3\python.exe"
REM set "PYTHON3_INCLUDE_DIR=C:\Users\ThachLN\anaconda3\Library\include"
REM set "PYTHON3_LIBRARY=C:\Users\ThachLN\anaconda3\libs\python38.lib"
REM set "PYTHON3_NUMPY_INCLUDE_DIRS=C:\Users\ThachLN\anaconda3\Lib\site-packages\numpy\core\include"
REM set "PYTHON3_PACKAGES_PATH=C:\Users\ThachLN\anaconda3\Lib\site-packages"

REM https://sourceforge.net/projects/openblas/files/v0.3.13/
set "OPEN_BLAS=D:\DevNow\OpenBLAS 0.3.13\xianyi-OpenBLAS-d2b11c4"

REM https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
set "LAPACK=D:\DevNow\lapack-3.9.0"

set "make=C:/Program Files/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/mingw32-make.exe"
set "cxx=C:/Program Files/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/x86_64-w64-mingw32-c++.exe"
set "gcc=C:/Program Files/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/x86_64-w64-mingw32-gcc.exe"


@ECHO CMake for %generator%
if exist "%openCvBuild%" (
    ECHO Deleting folder '%openCvBuild%' ...
    rmdir %openCvBuild% /s /q
)

REM set "Open_BLAS_INCLUDE_SEARCH_PATHS=D:/DevNow/OpenBLAS/include/openblas"
REM set "Open_BLAS_LIB_SEARCH_PATHS=D:/DevNow/OpenBLAS/lib"
set CUDA_ARCH_PTX=6.1

REM Update PATH
set "PATH=%PATH%;%OPEN_BLAS%;%LAPACK%"
REM Check folder path of cmake.exe is in environment variable PATH
D:\RunNow\cmake-3.19.4-win64-x64\bin\cmake.exe -B"%openCvBuild%/" -H"%openCvSource%/" -G"%generator%" -DCMAKE_BUILD_TYPE=%buildType% -DOPENCV_EXTRA_MODULES_PATH="%openCVExtraModules%/" ^
-DCMAKE_MAKE_PROGRAM="%make%" -DCMAKE_CXX_COMPILER="%cxx%" -DCMAKE_C_COMPILER="%gcc%" -DWITH_IPP=OFF ^
-DOPENCV_ALLOCATOR_STATS_COUNTER_TYPE=int64_t ^
-DINSTALL_TESTS=OFF -DINSTALL_C_EXAMPLES=OFF -DBUILD_EXAMPLES=OFF ^
-DBUILD_opencv_world=ON ^
-DWITH_LAPACK=ON ^
-DWITH_CUDA=ON -DCUDA_TOOLKIT_ROOT_DIR="%CUDA_PATH%" -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DCUDA_ARCH_PTX=%CUDA_ARCH_PTX% -DWITH_NVCUVID=ON ^
-DWITH_CUDNN=ON

PAUSE