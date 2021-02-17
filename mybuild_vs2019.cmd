REM @ECHO OFF
set "openCvSource=%CD%"

cd ..
set "openCVExtraModules=%CD%\opencv_contrib\modules"
set "openCvBuild=%CD%\build_vs2019"

cd %openCvSource%
set "buildType=Release"
REM set "generator=MinGW Makefiles"
set "generator=Visual Studio 16 2019"

set CUDA_ARCH_PTX=6.1

REM https://sourceforge.net/projects/openblas/files/v0.3.13/
set "OPEN_BLAS=D:/DevNow/OpenBLAS 0.3.13/xianyi-OpenBLAS-d2b11c4"

REM https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
set "LAPACK=D:/DevNow/lapack-3.9.0"

REM Update PATH
set PATH=%PATH%;%OPEN_BLAS%;%LAPACK%;C:/Users/ThachLN/anaconda3;C:/Users/ThachLN/anaconda3/Library/usr/bin;C:/Users/ThachLN/anaconda3/Library/bin;C:/Users/ThachLN/anaconda3/Scripts;C:/Users/ThachLN/anaconda3/bin;C:/Users/ThachLN/anaconda3/condabin

REM Use / instead of \ for path separator
set "CUDA_PATH=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.2"

@ECHO CMake for %generator%
if exist "%openCvBuild%" (
    ECHO Deleting folder '%openCvBuild%' ...
    rmdir %openCvBuild% /s /q
)

@ECHO CMake for %generator%


REM Check folder path of cmake.exe is in environment variable PATH
REM Don't use cmake in C:/Users/ThachLN/anaconda3/Library/share/cmake-3.19
D:\RunNow\cmake-3.19.4-win64-x64\bin\cmake.exe -B"%openCvBuild%/" -H"%openCvSource%/" -G"%generator%" -DCMAKE_BUILD_TYPE=%buildType% -DOPENCV_EXTRA_MODULES_PATH="%openCVExtraModules%/" ^
-DWITH_LAPACK=ON ^
-DINSTALL_TESTS=OFF -DINSTALL_C_EXAMPLES=OFF -DBUILD_EXAMPLES=OFF ^
-DBUILD_opencv_world=ON ^
-DWITH_CUDA=ON -DCUDA_TOOLKIT_ROOT_DIR="%CUDA_PATH%" -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DCUDA_ARCH_PTX=%CUDA_ARCH_PTX% -DWITH_NVCUVID=ON ^
-DWITH_CUDNN=ON

REM -DWITH_IPP=OFF ^

@PAUSE