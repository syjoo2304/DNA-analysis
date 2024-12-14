#!/bin/sh

# Variables
REFERENCE_GENOME="mm10.fa"
INPUT_BAM="$1"
sample_name=$(basename "$INPUT_BAM" | cut -d'_' -f1)
OUTPUT_DIR="[dir_to_output]/${sample_name}"
THREADS=8
MEMORY="64g"
MAX_JOBS=4  # Number of parallel jobs
output_filename="merged_${sample_name}.vcf"
sorted_output_filename="sorted_${sample_name}.vcf"

# Load required modules
module load gatk

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Function to run GATK HaplotypeCaller for a given chromosome
run_haplotypecaller() {

    local CHROMOSOME=$1
    local OUTPUT_VCF="${OUTPUT_DIR}/output_chr${CHROMOSOME}.vcf"
    
    echo "Processing chromosome: ${CHROMOSOME}"

    gatk --java-options "-Xmx${MEMORY}" HaplotypeCaller \
        -R "${REFERENCE_GENOME}" \
        -I "${INPUT_BAM}" \
        -O "${OUTPUT_VCF}" \
        -L "chr${CHROMOSOME}" \
        --native-pair-hmm-threads "${THREADS}" \
        -ERC GVCF --standard-min-confidence-threshold-for-calling 20

    if [ $? -eq 0 ]; then
        echo "Successfully finished chromosome: ${CHROMOSOME}"
    else
        echo "Error processing chromosome: ${CHROMOSOME}" >&2
    fi
}

export -f run_haplotypecaller  # Export function to be used in xargs
export REFERENCE_GENOME
export INPUT_BAM
export OUTPUT_DIR
export THREADS
export MEMORY

# List of chromosomes
CHROMOSOMES=$(seq 1 19)

## Run parallel jobs using xargs, limiting to MAX_JOBS at a time
echo ${CHROMOSOMES} X Y | tr ' ' '\n' | xargs -n 1 -P ${MAX_JOBS} -I {} bash -c 'run_haplotypecaller "$@"' _ {}

