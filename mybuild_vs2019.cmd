REM @ECHO OFF
set "buildType=Release"
set "openCvSource=%CD%"

cd ..
set "openCVExtraModules=%CD%\opencv_contrib\modules"
set "openCvBuild=%CD%\build_vs2019_%buildType%"
set "outputFolder=%CD%\opencv451_vs2019_bin_%buildType%"

cd %openCvSource%
REM set "generator=MinGW Makefiles"
set "generator=Visual Studio 16 2019"

set CUDA_ARCH_PTX=6.1

REM https://sourceforge.net/projects/openblas/files/v0.3.13/
REM OpenBLAS_DIR is used for PATH only
set "OpenBLAS_DIR=D:/DevNow/OpenBLAS"
REM set "LAPACK_DIR=D:/DevNow/OpenBLAS"

REM https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
REM set "LAPACK_DIR=D:/DevNow/lapack-3.9.0"

REM GSTREAMER_ROOT_X86 is used for PATH only
SET "GSTREAMER_ROOT_X86=D:/gstreamer/1.0/msvc_x86_64"

REM Update PATH
set "ANACONDA=D:/anaconda3"
set PATH=%PATH%;%OpenBLAS_DIR%;%OpenBLAS_DIR%/include;%GSTREAMER_ROOT_X86%/bin;%GSTREAMER_ROOT_X86%/lib/gstreamer-1.0;%ANACONDA%;%ANACONDA%/Library/usr/bin;%ANACONDA%/Library/bin;%ANACONDA%/Scripts;%ANACONDA%/bin;%ANACONDA%/condabin

REM Env VTK_DIR is defined to support flag -DWITH_VTK=ON
set "VTK_DIR=D:/DevNow/VTK-9.0.1_Devx64"
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
-DBUILD_opencv_world=OFF -DINSTALL_CREATE_DISTRIB=ON ^
-DWITH_CUDA=ON -DCUDA_TOOLKIT_ROOT_DIR="%CUDA_PATH%" -DCUDA_FAST_MATH=ON -DWITH_CUBLAS=ON -DCUDA_ARCH_PTX=%CUDA_ARCH_PTX% -DWITH_NVCUVID=ON ^
-DWITH_CUDNN=ON ^
-DWITH_GSTREAMER=ON ^
-DWITH_MSMF=ON -DWITH_VFW=ON ^
-DBUILD_WITH_DEBUG_INFO=ON ^
-DBUILD_SHARED_LIBS=ON ^
-DINSTALL_CREATE_DISTRIB=ON ^
-DLAPACK_LIBRARIES=D:/DevNow/lapack-3.7.0/lib/LAPACK.lib ^
-DCMAKE_INSTALL_PREFIX=%outputFolder%

REM -DLAPACK_DIR=%LAPACK_DIR% ^
REM -DOPEN_BLAS_DIR=%OPEN_BLAS_DIR% ^


REM Run msbuild
cd %openCvBuild%
REM "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin/MSBuild.exe" ALL_BUILD.vcxproj /p:Configuration=%buildType% /p:Platform=x64 /p:VisualStudioVersion=16.0 -m:%NUMBER_OF_PROCESSORS% -lowPriority:False
"C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin/MSBuild.exe" INSTALL.vcxproj /p:Configuration=%buildType% /p:Platform=x64 /p:VisualStudioVersion=16.0 -m:%NUMBER_OF_PROCESSORS% -lowPriority:False
REM "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/MSBuild/Current/Bin/MSBuild.exe" OpenCV.sln /p:Configuration=%buildType% /p:Platform=x64 /p:VisualStudioVersion=16.0 -m:%NUMBER_OF_PROCESSORS% -lowPriority:False