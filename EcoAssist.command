#!/usr/bin/env bash

### OSX commands to open the EcoAssist application https://github.com/PetervanLunteren/EcoAssist
### Peter van Lunteren, 25 August 2022

# set var for ecoassist root
LOCATION_ECOASSIST_FILES="/Applications/EcoAssist_files"

# log output to logfiles
exec 1> $LOCATION_ECOASSIST_FILES/EcoAssist/logfiles/stdout.txt
exec 2> $LOCATION_ECOASSIST_FILES/EcoAssist/logfiles/stderr.txt

# timestamp and log the start
START_DATE=`date`
echo "This installation started at: $START_DATE"
echo ""

# log system information
UNAME_A=`uname -a`
MACHINE_INFO=`system_profiler SPSoftwareDataType SPHardwareDataType SPMemoryDataType SPStorageDataType`
FILE_SIZES_DEPTH_0=`du -sh $LOCATION_ECOASSIST_FILES`
FILE_SIZES_DEPTH_1=`du -sh $LOCATION_ECOASSIST_FILES/*`
FILE_SIZES_DEPTH_2=`du -sh $LOCATION_ECOASSIST_FILES/*/*`
echo "uname -a:"
echo ""
echo "$UNAME_A"
echo ""
echo "System information:"
echo ""
echo "$MACHINE_INFO"
echo ""
echo "File sizes with depth 0:"
echo ""
echo "$FILE_SIZES_DEPTH_0"
echo ""
echo "File sizes with depth 1:"
echo ""
echo "$FILE_SIZES_DEPTH_1"
echo ""
echo "File sizes with depth 2:"
echo ""
echo "$FILE_SIZES_DEPTH_2"
echo ""

# change directory
cd $LOCATION_ECOASSIST_FILES || { echo "Could not change directory to EcoAssist_files. Command could not be run. Did you change the name or folder structure since installing EcoAssist?"; exit 1; }

# path to conda installation
PATH2CONDA=`conda info | grep 'base environment' | cut -d ':' -f 2 | xargs | cut -d ' ' -f 1`
echo "Path to conda: $PATH2CONDA"
echo ""

# path to conda.sh
PATH2CONDA_SH="$PATH2CONDA/etc/profile.d/conda.sh"
echo "Path to conda.sh: $PATH2CONDA_SH"
echo ""

# path to python exe
PATH2PYTHON="$PATH2CONDA/envs/ecoassistcondaenv/bin/"
echo "Path to python: $PATH2PYTHON"
echo ""

# shellcheck source=src/conda.sh
source $PATH2CONDA_SH

# activate environment
conda activate ecoassistcondaenv

# add PYTHONPATH
export PYTHONPATH="$PYTHONPATH:$PATH2PYTHON:$PWD/cameratraps:$PWD/ai4eutils:$PWD/yolov5"
echo "PYHTONPATH=$PYTHONPATH"
echo ""

# add python exe to PATH
export PATH="$PATH2PYTHON:/usr/bin/:$PATH"
echo "PATH=$PATH"
echo ""

# version of python exe
PYVERSION=`python -V`
echo "python version: $PYVERSION"
echo ""

# location of python exe
PYLOCATION=`which python`
echo "python location: $PYLOCATION"
echo ""

# check tensorflow version and GPU availability
python EcoAssist/tf_check.py

# run script
python EcoAssist/EcoAssist_GUI.py

# timestamp and log the end
END_DATE=`date`
echo ""
echo "This installation ended at: $END_DATE"