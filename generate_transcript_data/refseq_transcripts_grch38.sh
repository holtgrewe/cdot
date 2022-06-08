#!/bin/bash

set -e

BASE_DIR=$(dirname ${BASH_SOURCE[0]})
CDOT_VERSION=$(${BASE_DIR}/cdot_json.py --version)
GENOME_BUILD=grch38
UTA_VERSION=20210129

# Having troubles with corrupted files downloading via FTP from NCBI via IPv6, http works ok

merge_args=()

# All GRCh38 transcripts have alignments gaps, so use UTA first (and override with official releases)
uta_cdot_file="cdot.uta_${UTA_VERSION}.${GENOME_BUILD}.json.gz"
${BASE_DIR}/uta_transcripts.sh ${UTA_VERSION} ${GENOME_BUILD}
merge_args+=(${uta_cdot_file})


filename=ref_GRCh38_top_level.gff3.gz
url=http://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Homo_sapiens/ARCHIVE/ANNOTATION_RELEASE.106/GFF/${filename}
cdot_file=$(basename $filename .gz).json.gz

if [[ ! -e ${filename} ]]; then
  wget ${url}
fi
if [[ ! -e ${cdot_file} ]]; then
  ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
fi
merge_args+=(${cdot_file})


filename=ref_GRCh38.p2_top_level.gff3.gz
url=http://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Homo_sapiens/ARCHIVE/ANNOTATION_RELEASE.107/GFF/${filename}
cdot_file=$(basename $filename .gz).json.gz

if [[ ! -e ${filename} ]]; then
  wget ${url}
fi
if [[ ! -e ${cdot_file} ]]; then
  ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
fi
merge_args+=(${cdot_file})


filename=ref_GRCh38.p7_top_level.gff3.gz
url=http://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Homo_sapiens/ARCHIVE/ANNOTATION_RELEASE.108/GFF/${filename}
cdot_file=$(basename $filename .gz).json.gz

if [[ ! -e ${filename} ]]; then
  wget ${url}
fi
if [[ ! -e ${cdot_file} ]]; then
  ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
fi
merge_args+=(${cdot_file})


filename=ref_GRCh38.p12_top_level.gff3.gz
url=http://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Homo_sapiens/ARCHIVE/ANNOTATION_RELEASE.109/GFF/${filename}
cdot_file=$(basename $filename .gz).json.gz

if [[ ! -e ${filename} ]]; then
  wget ${url}
fi
if [[ ! -e ${cdot_file} ]]; then
  ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
fi
merge_args+=(${cdot_file})


filename=GCF_000001405.38_GRCh38.p12_genomic.gff.gz
url=http://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/annotation_releases/109/GCF_000001405.38_GRCh38.p12/${filename}
cdot_file=$(basename $filename .gz).json.gz

if [[ ! -e ${filename} ]]; then
  wget ${url}
fi
if [[ ! -e ${cdot_file} ]]; then
  ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
fi
merge_args+=(${cdot_file})


# 109.20211119 needs latest HTSeq (Feb 2022) or dies with quoting error
for release in 109.20190607 109.20190905 109.20191205 109.20200228 109.20200522 109.20200815 109.20201120 109.20210226 109.20210514 109.20211119; do
  # These all have the same name, so rename them based on release ID
  filename=GCF_000001405.39_GRCh38.p13_genomic.${release}.gff.gz
  url=http://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/annotation_releases/${release}/GCF_000001405.39_GRCh38.p13/GCF_000001405.39_GRCh38.p13_genomic.gff.gz
  cdot_file=$(basename $filename .gz).json.gz
  if [[ ! -e ${filename} ]]; then
    wget ${url} --output-document=${filename}
  fi
  if [[ ! -e ${cdot_file} ]]; then
    ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
  fi
  merge_args+=(${cdot_file})
done


filename=GCF_000001405.40_GRCh38.p14_genomic.gff.gz
url=https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/annotation_releases/110/GCF_000001405.40_GRCh38.p14/${filename}
cdot_file=$(basename $filename .gz).json.gz

if [[ ! -e ${filename} ]]; then
  wget ${url}
fi
if [[ ! -e ${cdot_file} ]]; then
  ${BASE_DIR}/cdot_json.py gff3_to_json "${filename}" --url "${url}" --genome-build=GRCh38 --output "${cdot_file}"
fi
merge_args+=(${cdot_file})


merged_file="cdot-${CDOT_VERSION}.refseq.grch38.json.gz"
if [[ ! -e ${merged_file} ]]; then
  echo "Creating ${merged_file}"
  ${BASE_DIR}/cdot_json.py merge_historical ${merge_args[@]} --genome-build=GRCh38 --output "${merged_file}"
fi
