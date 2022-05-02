# ZoonomiaCG
## code
Requirements: ComparativeGenomicsToolkit (HAL) https://github.com/ComparativeGenomicsToolkit/hal/blob/master/README.md 

The main code for sequence extraction and preprocessing can be found in `script.sh`. This primarily uses `halSnps` from the toolkit above.
```
usage: ./script.sh <UTR or lnc> <batch name> <number of samples> <target genome>
eg: ./script.sh UTR batch101 101 Solenodon_paradoxus
```

Note that this script will randomly select `<number of samples>` according to `bash`'s built-in `shuf` function.



## source files
### Hal alignment (not in repository)
- download 804GB file here https://cglgenomics.ucsc.edu/data/cactus/

### lnc.bed
-comes from https://lncipedia.org/download (High confidence set (putative protein coding genes are excluded))
-includes 107,039 lncRNAs, ~2,515,235,713 bp

### utr.bed
-comes from https://groups.google.com/a/soe.ucsc.edu/g/genome/c/7V5j51XYUBQ track NCBI refseq genes, table: UCSC refseq (refGene)
-includes 194,431 5'-UTR exons, ~39,387,727 bp

## analysis output
The data presented in the report is found in the folders `UTR_batch_10000` (5'-UTR exons) and `lncRNA_batch_101` (lncRNAs). These compare _Homo sapiens_ to _Solenodon paradoxus_.

### lncRNA_batch_101
```
20 lncRNA (see which ones in *matchinfo.txt)
134,681 bp examined (count of lines in  *final_sequences_with_gaps.txt)
28,668 aligned (count of lines in  *final_sequences.txt)
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

Additional batches can be found in `additional_batches`. These also compare _Homo sapiens_ to _Solenodon paradoxus_ unless the batch name explicitly names another species, such as baboon or canerat. Scientific names can be found in the files themselves.
