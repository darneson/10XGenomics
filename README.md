# 10XGenomics Cell Ranger Workflow

Contents: <br />
1. [LiveSync](https://github.com/darneson/10XGenomics#live-sync) <br />
2. [mkfastq](https://github.com/darneson/10XGenomics#mkfastq) <br />
3. [count](https://github.com/darneson/10XGenomics#count) <br />
4. [aggr](https://github.com/darneson/10XGenomics#aggr) <br />

The primary 10X Genomics Cell Ranger Workflow can be roughly divided into three steps:
<ol>
  <li>Obtain data from UCLA BSCRC Sequencing Core using Live Sync while the sequencer is running</li>
  <li>Convert from .bcl files to .fastq files (mkfastq)</li>
  <li>Generate Digitcal Gene Expression CellxGene Count Matrices from .fastq files for each library separately (count)</li>
  <li>Aggregate separate libraries into one matrix and downsample UMI counts to similar coverage (aggr)</li>
</ol>
The following 10X single cell dataset generated on a single HiSeq 4000 PE100 lane will be used as an example: <br />
`/u/nobackup/xyang123/darneson/10X_Single_Cell/LusisCollab/bcl-9-13-2017` <br />

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)

## Live Sync
```
.
├── Config
│   ├── HiSeqControlSoftware.Options.cfg
│   ├── hjv2fbbxx_2017-09-13 09-55-04_Effective.cfg
│   ├── hjv2fbbxx_2017-09-13 09-55-04_Override.cfg
│   ├── hjv2fbbxx_2017-09-13 09-55-05_SortedOverride.cfg
│   ├── RTAStart.log
│   └── Variability_HiSeq_E.bin
├── Data
│   └── Intensities
├── InterOp
│   ├── ColorMatrixMetricsOut.bin
│   ├── CorrectedIntMetricsOut.bin
│   ├── EmpiricalPhasingMetricsOut.bin
│   ├── ErrorMetricsOut.bin
│   ├── EventMetricsOut.bin
│   ├── ExtractionMetricsOut.bin
│   ├── FWHMGridMetricsOut.bin
│   ├── ImageMetricsOut.bin
│   ├── PFGridMetricsOut.bin
│   ├── QMetricsOut.bin
│   ├── RegistrationMetricsOut.bin
│   ├── StaticRunMetricsOut.bin
│   └── TileMetricsOut.bin
├── Logs
├── PeriodicSaveRates
│   └── Save All Thumbnails.xml
├── Recipe
│   └── HJV2FBBXX.xml
├── RTAComplete.txt
├── RTAConfiguration.xml
├── RTALogs
├── RTARead1Complete.txt
├── RTARead2Complete.txt
├── RTARead3Complete.txt
├── RTARead4Complete.txt
├── RunInfo.xml
├── runParameters.xml
├── SequencingComplete.txt
└── Thumbnail_Images
    └── L007
```

## Mkfastq

## Count

## Aggr
