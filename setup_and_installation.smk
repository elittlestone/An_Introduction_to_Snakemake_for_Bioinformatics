

rule all:
  input:
    "genome_accessions.txt",
    "all_genomes.zip",
    directory("genomes")

# Rule to prepare the genome accessions file
rule prepare_genome_accessions:
  input:
    config_file = "config.yaml"
  output:
    accessions = temp("genome_accessions.txt")
  shell:
    "yq -r '.genomes[]' {input.config_file} > {output.accessions}"

# Rule to download and unzip genomes
rule download_genomes:
  input:
    accessions = "genome_accessions.txt"
  output:
    zip_file = temp("all_genomes.zip"),
    genomes = protected(directory("genomes"))
  shell:
    """
    datasets download genome accession --inputfile {input} \
    --filename {output.zip_file} --no-progressbar --fast-zip-validation
    unzip {output.zip_file} -d {output.genomes}
    find genomes/ -name "*.fna" -exec mv {{}} genomes/ \\;"""


