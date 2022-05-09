# ZoonomiaCG
## Requirements
Requirements: ComparativeGenomicsToolkit (HAL) https://github.com/ComparativeGenomicsToolkit/hal/blob/master/README.md 

## Source Files
### Hal alignment (not in repository)
- Download 804GB file here https://cglgenomics.ucsc.edu/data/cactus/

### lnc.bed
-Comes from https://lncipedia.org/download (High confidence set (putative protein coding genes are excluded))
-Includes 107,039 lncRNAs, ~2,515,235,713 bp

### utr.bed
-Comes from NCBI refseq gene track, table: UCSC refseq (refGene) (Download via Table UCSC Table Browser)
-Includes 194,431 5'-UTR exons, ~39,387,727 bp

## Running the Analysis
### Sequence Extraction

The main code for sequence extraction and preprocessing can be found in `script.sh`. This primarily uses `halSnps` from the toolkit above. The following commands should be run in a bash terminal in the same directory where the 804GB Hal alignment file is downloaded. The alignment file should be named `241-mammalian-2020v2.hal` which is the default name when you download it. The files 'lnc.bed' and 'utr.bed' should also be present in this directory.

```bash
usage: ./script.sh <UTR or lnc> <batch name> <number of samples> <target genome>
eg: ./script.sh UTR batch101 101 Solenodon_paradoxus
```

Note that this script will randomly select `<number of samples>` according to `bash`'s built-in `shuf` function. The '<target genome>' parameter must be a genome listed in `241-mammalian-2020v2.hal`; available genomes can be obtained by running `halStats 241-mammalian-2020v2.hal`. The target genome will be compared to the _Homo sapiens_ genome.
  
A small example:
  
```bash
  ./script.sh lnc batch101 101 Solenodon_paradoxus && ./script.sh UTR batch10000 10000 Solenodon_paradoxus
```
  
Note that this is a relatively minimal example but still takes significant time to run (up to an hour running both above commands in parallel on `t3.2xlarge` Amazon EC2 instance). It is considered relatively minimal because, despite their runtime, they produce relatively small sequences and smaller sampling of lncRNA and or 5'-UTR exons often produce no usable sequences at all. Note that while the number of random samples selected is specified above as 101 and 10000 many of these will contain no aligned sequences between the two species.

### Sequence Processing

## Example Output
The data presented in the report is found in the folders `UTR_batch_10000` (5'-UTR exons) and `lncRNA_batch_101` (lncRNAs). These are the output of the small example described in the preceding section. This analysis compares compare _Homo sapiens_ to _Solenodon paradoxus_.
  
Note that a description of every output file appears after these statistics.

### lncRNA_batch_101

  ```
20 lncRNA
134,681 bp examined
28,668 aligned
  20,463 exact matches
  8,205 SNPs
```
  
### UTR_batch_10000
```
202 5'-UTR exons (see which ones in *matchinfo.txt)
101,731 bp examined (count of lines in  *final_sequences_with_gaps.txt)
7,486 aligned (count of lines in  *final_sequences.txt)
  5,300 exact matches
  2,186 SNPs
```
  
### File Explanations
  - *matchinfo.txt contains the list of lncRNA or 5'-UTR exons that were used in that sample
  - *final_sequences_with_gaps.txt contains the concatenated sequence of every H. sapiens lncRNA (or 5'-UTR exon) in one column with the aligned nucleotide of S. paradoxus in the second column; this contains many gaps where the H. sapiens sequence was not mapped to S. paradoxus
  -*final_sequences.txt contains the same sequences as *final_sequences_with_gaps.txt but the non-aligned regions have been removed; these sequences are used in the final analysis


Additional batches can be found in `additional_batches`. These also compare _Homo sapiens_ to _Solenodon paradoxus_ unless the batch name explicitly names another species, such as baboon or canerat. Scientific names can be found in the files themselves.
