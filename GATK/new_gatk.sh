#!/bin/bash

module purge
module load gatk
module load bwa

export TRIMMONATIC=/opt/trimmonatic/0.36/trimmomatic-0.36.jar
export PICARD=/opt/picard/2.25.6/build/libs/picard.jar

python new_gatk.py
