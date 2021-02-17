REM @ECHO OFF
set "openCvSource=%CD%"

cd ..
set "openCVExtraModules=%CD%\opencv_contrib\modules"
set "openCvBuild=%CD%\build_vs2019"
set "outputFolder=%CD%\build_vs2019_bin"

cd %openCvSource%
set "buildType=Release"
REM set "generator=MinGW Makefiles"
set "generator=Visual Studio 16 2019"

set CUDA_ARCH_PTX=6.1

REM https://sourceforge.net/projects/openblas/files/v0.3.13/
set "OPEN_BLAS=D:/DevNow/xianyi-OpenBLAS-d2b11c4"

REM https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
set "LAPACK=D:/DevNow/lapack-3.9.0"

REM Update PATH
set ANACONDA=D:/anaconda3
set PATH=%PATH%;%OPEN_BLAS%;%LAPACK%;%ANACONDA%;%ANACONDA%/Library/usr/bin;%ANACONDA%/Library/bin;%ANACONDA%/Scripts;%ANACONDA%/bin;%ANACONDA%/condabin

REM Use / instead of \ for path separator
set "CUDA_PATH=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0"

@ECHO CMake for %generator%
if exist "%openCvBuild%" (
    ECHO Deleting folder '%openCvBuild%' ...
    rmdir %openCvBuild% /s /q
)

if exist "%outputFolder%" (
    ECHO Deleting folder '%outputFolder%' ...
    rmdir %outputFolder% /s /q
)

@ECHO CMake for %generator%


REM Check folder path of cmake.exe is in environment variable PATH
REM Don't use cmake in %ANACONDA%/Library/share/cmake-3.19
D:\RunNow\cmake-3.19.4-win64-x64\bin\cmake.exe -B"%openCvBuild%/" -Ax64 -H"%openCvSource%/" -G"%generator%" -DCMAKE_BUILD_TYPE=%buildType% -DOPENCV_EXTRA_MODULES_PATH="%openCVExtraModules%/" ^
-DWITH_LAPACK=ON ^
-DINSTALL_TESTS=OFF -DINSTALL_C_EXAMPLES=OFF -DBUILD_EXAMPLES=OFF ^
-DBUILD_opencv_world=ON ^
-DWITH_CUDA=ON -DCUDA_TOOLKIT_ROOT_DIR="%CUDA_PATH%" -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DCUDA_ARCH_PTX=%CUDA_ARCH_PTX% -DWITH_NVCUVID=ON ^
-DWITH_CUDNN=ON ^
-DCMAKE_INSTALL_PREFIX=%outputFolder%

REM Run msbuild
cd %openCvBuild%
"C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin/MSBuild.exe" INSTALL.vcxproj /p:Configuration=Release /p:Platform=x64 /p:VisualStudioVersion=16.0 -m:%NUMBER_OF_PROCESSORS% -lowPriority:False

@PAUSE