# ZoonomiaCG
## Requirements
- [ComparativeGenomicsToolkit (HAL)](https://github.com/ComparativeGenomicsToolkit/hal/blob/master/README.md)
- Linux-like shell terminal environment capable of running `Bash`
- Large storage capacity (see 804GB file below)
- Large RAM (examples here run on Amazon EC2 `tx3.2xlarge`, 32GB RAM and 8 vCPUs)
- Google Colab notebook environment (free/education tier is adequate)

## Source Data Files
#### Hal pan-genome alignment (241-mammalian-2020v2.hal) (not in repository)
- Download 804GB file here https://cglgenomics.ucsc.edu/data/cactus/ from Zoonomia Project
- Contains pan-genome alignment that includes 241 mammal species in specialized Hal format.

#### lnc.bed
- Comes from [LNCipedia High confidence set (putative protein coding genes are excluded)](https://lncipedia.org/download)
- Includes 107,039 lncRNAs, ~2,515,235,713 bp

#### utr.bed
- Comes from NCBI refseq gene track, table: UCSC refseq (refGene) (Download via Table [UCSC Table Browser](https://genome.ucsc.edu/cgi-bin/hgTables) )
- Includes 194,431 5'-UTR exons, ~39,387,727 bp

## Running the Analysis
The analysis is split into two phases. The first, sequence extraction, produces text files that contain long, aligned genomic sequences from `241-mammalian-2020v2.hal` for _Homo sapiens_ and one other mammal found in this alignment. One text file is produced containing the concatenated lncRNA sequences and one containing the concatenated 5'-UTR sequences. These two sequence files become the input for the second phase of the analsysis, sequence processing. This step produces two matrices, one corresponding to each of the input files (lncRNAs and 5'-UTR exons).

### Sequence Extraction

The main code for sequence extraction and preprocessing can be found in `script.sh`.

```bash
usage: ./script.sh <UTR or lnc> <batch name> <number of samples> <target genome>
eg: ./script.sh UTR batch101 101 Solenodon_paradoxus
```
This primarily uses `halSnps` from the toolkit above. The commands above should be run in a `bash` terminal in the same directory where the 804GB Hal alignment file is downloaded. The default alignment name `241-mammalian-2020v2.hal` should not be changed. The files `lnc.bed` and `utr.bed` should also be present in this directory to reproduce our results. Any valid BED files with these names can be substituted at this step for different analyses.

Note that this script will randomly select `<number of samples>` according to `bash`'s built-in `shuf` function. The `<target genome>` parameter must be a genome listed in `241-mammalian-2020v2.hal`; available genomes can be obtained by running `halStats 241-mammalian-2020v2.hal`. The target genome will be compared to the _Homo sapiens_ genome.
  
A small example:
  
```bash
  ./script.sh lnc batch101 101 Solenodon_paradoxus && ./script.sh UTR batch10000 10000 Solenodon_paradoxus
```
  
To create the lightweight example presented here and in the report, the run depicted above was stopped after only 20 lncRNA and 202 5'-UTR exons. Note that this is a relatively minimal example because it produces relatively small sequences for comparison and even smaller samples of lncRNA or 5'-UTR exons often produce no usable sequences at all. However, even this minimal example still takes significant time to run (up to an hour running both above commands in parallel on `t3.2xlarge` Amazon EC2 instance).
  
The output of the sequence extraction step is complex and is examined in greater detail at the end of this README. At a high-level, this step produces two text files containing the concatenated sequence of all aligned basepairs from all lncRNAs or 5'-UTR exons. The example run demonstrated above produces `UTR-batch10000-final_sequences.txt` and `lnc-batch101-final_sequences.txt` which are found in the folders `UTR_batch_10000` and `lncRNA_batch_101`, respectively. The details of these example files are also documented at the end of the README.

### Sequence Processing
The small example curated above allows the next step in the analysis to run in around seven minutes on Google Colab's free tier. Larger samples would require Google Colab Pro.
  
To run this phase of the analysis, place `sequence_processing.ipynb` in your own Google Colab environment. There, it is sufficient to simply run all the cells to reproduce our analysis because the sequence files produced by the sequence extraction example described above are automatically loaded from this repository without additional steps. To run the analysis on other sequences, it is necessary to provide the sequences as a text file to which your Colab environment has access. The sequences should be in the same format as a `*final_sequences.txt` file (see file descriptions below) and can be read in using `read_in_samples()` in the notebook. The output from this phase of the analysis is straightfoward: it produces two labeled matrices printed in the Colab environment output of the final cell.

The matrices produced by the example analysis given in this README are detailed in the report pdf and are viewable in `sequence_processing.ipynb`.

## Output of Sequence Extraction Step
  
### File Descriptions
  - `*-sample.txt` contains all the lncRNA or 5'-UTR exons that were chosen as part of the random sample along with their start positions and lengths (RefSeq). For the example described in this README, not all sequences in this list were actually used as we stopped the sequece extraction step early to create our lightweight example.
  - `*matchinfo.txt` contains the list of lncRNA or 5'-UTR exons that were successfully used in that analysis along with their alignment statistics. Columns: name of the lncRNA or 5'-UTR exon, chromosome, total sequence length alignable, number of SNPs found.
  - `*-out` this folder contains the same alignment information as found in `*final_sequences_with_gaps.txt` but separated into one file per lncRNA or 5'-UTR exon.
  - `*final_sequences_with_gaps.txt` contains the concatenated sequence of every _H. sapiens_ lncRNA (or 5'-UTR exon) in one column with the nucleotide at the aligned position in the target genome (eg. _S. paradoxus_) in the second column. Note that the second column will contain many gaps where the _H. sapiens_ sequence was not mapped to the target genome.
  - `*final_sequences.txt` contains the same sequences as `*final_sequences_with_gaps.txt` but the non-aligned regions have been removed. These are the sequences that should become the input of the sequence processing phase.

### Output From Sequence Extraction Example
The sequence data from the example referenced throughout this README (and used to create the final report) can be found in the folders `UTR_batch_10000` (5'-UTR exons) and `lncRNA_batch_101` (lncRNAs). These are the output of the small example described throughout this README. Note that it compares _Homo sapiens_ to _Solenodon paradoxus_.

#### lncRNA_batch_101

  ```
20 lncRNA (see which ones in *matchinfo.txt)
134,681 bp examined (count of lines in  *final_sequences_with_gaps.txt)
28,668 aligned (count of lines in  *final_sequences.txt)
  20,463 exact matches
  8,205 SNPs
```
  
#### UTR_batch_10000
```
202 5'-UTR exons (see which ones in *matchinfo.txt)
101,731 bp examined (count of lines in  *final_sequences_with_gaps.txt)
7,486 aligned (count of lines in  *final_sequences.txt)
  5,300 exact matches
  2,186 SNPs
```
  
#### Additional Batches
Additional runs of the sequence extraction process can be found in `additional_batches`. These were generally used in the testing process and to unofficially confirm that the example presented in this README and in the report is as representative as possible. Most of these batches also compare _Homo sapiens_ to _Solenodon paradoxus_ unless the batch name explicitly names another species, such as baboon or canerat. In that case, the scientific name of the target species can be found in the files themselves. Note that many of these runs produced no usable (aligned) sequences but are included here for the sake of completeness.
