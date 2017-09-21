# 10XGenomics Cell Ranger Workflow

Contents: <br />
1. [mkfastq](https://github.com/darneson/10XGenomics#mkfastq) <br />
2. [count](https://github.com/darneson/10XGenomics#count) <br />
3. [aggr](https://github.com/darneson/10XGenomics#aggr) <br />

The primary 10X Genomics Cell Ranger Workflow can be roughly divided into three steps:
<ol>
  <li>Convert from .bcl files to .fastq files (mkfastq)</li>
  <li>Generate Digitcal Gene Expression CellxGene Count Matrices from .fastq files for each library separately (count)</li>
  <li>Aggregate separate libraries into one matrix and downsample UMI counts to similar coverage (aggr)</li>
</ol>
The following 10X single cell dataset generated on a single HiSeq 4000 PE100 lane will be used as an example: <br />
`/u/nobackup/xyang123/zhaoyuqi/RNA-seq/Yu_project/Sample_HLZ_14 -- Sample_HLZ_25` <br />

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)

## Mkfastq

## Count

## Aggr
