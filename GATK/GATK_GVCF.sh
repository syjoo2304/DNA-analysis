#!/bin/sh

# Variables
REFERENCE_GENOME="mm10.fa"
INPUT_BAM="$1"
sample_name=$(basename "$INPUT_BAM" | cut -d'_' -f1)
OUTPUT_DIR="/home/syjoo/test/do/${sample_name}_v3"
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


## Generate the list of input VCF files (chr1 to chr19, chrX, chrY)
ls ${OUTPUT_DIR}/output_chr{1..19}.vcf ${OUTPUT_DIR}/output_chrX.vcf ${OUTPUT_DIR}/output_chrY.vcf > ${OUTPUT_DIR}/${sample_name}.sample_list.txt

## Run the GATK MergeVcfs command
gatk --java-options "-Xmx${MEMORY}" \
    MergeVcfs \
    --INPUT ${OUTPUT_DIR}/${sample_name}.sample_list.txt \
    --OUTPUT ${OUTPUT_DIR}/${output_filename}

## Step 2: Sort the merged VCF file by chromosome
gatk --java-options "-Xmx${MEMORY}" \
    SortVcf \
    --INPUT ${OUTPUT_DIR}/${output_filename} \
    --OUTPUT ${OUTPUT_DIR}/${sorted_output_filename}
