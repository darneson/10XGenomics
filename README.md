# 10XGenomics Cell Ranger Workflow

Contents: <br />
1. [LiveSync](https://github.com/darneson/10XGenomics#live-sync) <br />
2. [mkfastq](https://github.com/darneson/10XGenomics#mkfastq) <br />
3. [count](https://github.com/darneson/10XGenomics#count) <br />
4. [aggr](https://github.com/darneson/10XGenomics#aggr) <br />

The primary 10X Genomics Cell Ranger Workflow can be roughly divided into four steps: <br />
1. Obtain data from UCLA BSCRC Sequencing Core using [LiveSync](https://github.com/darneson/10XGenomics#live-sync) while the sequencer is running <br />
2. Convert from .bcl files to .fastq files ([mkfastq](https://github.com/darneson/10XGenomics#mkfastq)) <br />
3. Generate Digitcal Gene Expression CellxGene Count Matrices from .fastq files for each library separately ([count](https://github.com/darneson/10XGenomics#count)) <br />
4. Aggregate separate libraries into one matrix and downsample UMI counts to similar coverage ([aggr](https://github.com/darneson/10XGenomics#aggr)) <br />

The following 10X single cell dataset generated on a single HiSeq 4000 PE100 lane will be used as an example:

```
/u/nobackup/xyang123/darneson/10X_Single_Cell/LusisCollab/bcl-9-13-2017
```

### 10X Genomics documentation and tutorials on the tools discussed here can be accessed from this [webpage](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger)

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)

## Live Sync

1. For 10X single cell analysis, we need raw files directly from the sequencer ([.bcl files](http://genomics-bcftbx.readthedocs.io/en/latest/protocols/prep_illumina.html)) <br />
    * We also need all of the files off the sequencer which describe the flow cell settings <br />
2. These files can be obtained directly from the sequencer while it is running using LiveSync (additional instructions [here](https://github.com/darneson/10XGenomics/blob/master/LiveSyncInstructions.txt)) <br />
    * LiveSync uses the [rsync](https://wiki.archlinux.org/index.php/rsync) unix command <br />
3. The following command can be used to obtain the files: <br />
```
rsync --recursive --times --verbose --stats --progress --itemize-changes rsync://<lane_credentials>@pan.pellegrini.mcdb.ucla.edu/<lane_credentials>/ <Path/To/Output/Folder/Location>/<Output_Folder_Name>/
```
4. You will be prompted for a password to download the data <br />
    * This will be supplied with your lane credentials in the format: <**lane_credentials**>:<**password**> <br />
5. You can start downloading the ([.bcl files](http://genomics-bcftbx.readthedocs.io/en/latest/protocols/prep_illumina.html)) via LiveSync as soon as you receive the lane credentials. <br />
    * **NOTE:** You must finish downloading the LiveSync data within **24 hours** of the sequencing completion <br />
    * Email Suhua (sfeng [at] mcdb [dot] ucla [dot] edu) and Shawn (Cokus [at] ucla [dot] edu) upon completion of LiveSync so that they can convert the .bcl files to .qseq files for the other lanes <br />
6. Likely, your LiveSync download will catch up to the sequencing before the sequencing completes, this is ok <br />
    * You can keep running LiveSync incrementally until you see the file **RTAComplete.txt** in your main <Output_Directory> <br />
    * See below for an example of what a directory structure looks like upon completion of LiveSync (note the location of the **RTAComplete.txt** file <br />

7. After LiveSync, directory structure should look something like below: 
    * **NOTE:** we need all these other extra files (they tell [Cell Ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/what-is-cell-ranger) how the flow cell in sequencer was set up -- we can't just use the .bcl files).
    * The .bcl files are located under the following directory <**./Data/Intesities/BaseCalls/L007**> <br />
    * In this case our .bcl files were located in the directory <**L007**> indicating that our data was sequenced on **Lane 7** in the flow cell. <br />
### LiveSync Directory Structure:
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
│       └── BaseCalls
|           └── L007
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

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)

## Mkfastq
### 10X Genomics documentation and tutorials on the mkfastq software is available [here](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/mkfastq) <br />

This step demultiplexes raw sequencing data based on supplied sample indexes and generates **.fastq** files from **.bcl** files by wrapping Illumina's [bcl2fastq](https://support.illumina.com/content/dam/illumina-support/documents/documentation/software_documentation/bcl2fastq/bcl2fastq2_guide_15051736_v2.pdf) software <br />

1. First, we need to generate a samplesheet (**.csv**) files which describes each of our samples <br />
    * Example samplesheet [here](https://github.com/darneson/10XGenomics/blob/master/cellranger-LiverAorta-bcl-samplesheet.csv) <br />
    * The [**Header**] subsection contains metadata about the sequencing and experiment which can be modified/updated as desired <br />
    * The read length in the [**Reads**] subsection can be obtained from the <**runParameters.xml**> file obtained from LiveSync see [directory structure](https://github.com/darneson/10XGenomics/#livesync-directory-structure) for where to find this file <br />
    * The [**Data**] subsection defines your samples and their multiplex indexes <br />
        * Entries for the |**Lane**| column can be obtained from the output of your LiveSync under the <**./Data/Intensities/BaseCalls/**> directory (see [directory structure](https://github.com/darneson/10XGenomics/#livesync-directory-structure)). Although you should already know which lanes you sequenced and which samples are in each lane <br />
        * If you sequenced multiple lanes but only want to analyze a subset of those lanes, you can specify which lanes you want to use here <br />
        * Here, we sequenced in lane 7 as indicated in the |**Lane**| column of our [samplesheet](https://github.com/darneson/10XGenomics/blob/master/cellranger-LiverAorta-bcl-samplesheet.csv) and as seen in the [directory structure](https://github.com/darneson/10XGenomics/#livesync-directory-structure) <br />
        * For each sample there are four multiplex indexes which are added during the library preparation <br />
        * You can get your sample index information from whomever prepared the library, an example from one of our libraries is [here](https://github.com/darneson/10XGenomics/blob/master/SampleIndexes.txt), where you can see we have four samples using the following sets of indexes: <**A1**>, <**B1**>, <**C1**>, <**D1**> <br />
        * From the [Sample Index Plate](https://github.com/darneson/10XGenomics/blob/master/chromium-shared-sample-indexes-plate.csv), we can see that each set of indexes corresponds to four unique **Barcodes** <br />
        * For example, Index Set **SI-GA-A1** (we call this "**A1**") has the following four barcodes: [**GGTTTACT**], [**CTAAACGG**], [**TCGGCGTC**], [**AACCGTAA**] <br />
        * In the [**Data**] subsection our [samplesheet](https://github.com/darneson/10XGenomics/blob/master/cellranger-LiverAorta-bcl-samplesheet.csv), each sample (which was run in a different channel of the 10X Chromium device) will occupy four rows <br />
        * For each sample, each of these rows corresponds to one of the four **Barcodes** of an **Index Set** <br />
        * We define the |**Sample_ID**| column as the **Index Set** with an underscore for which **Barcode** is identified in this row (e.g. a |**Sample_ID**| of <**SI-GA-A1_3**> comes from Index Set **SI-GA-A1** and Barcode [**3**]) <br />
        * The |**Sample_Name**| column corresponds to a unique string that will be used to identify each of your samples. This |**Sample_Name**| should be the same for each of the four **Barcode** rows that correspond to that sample. **Note:** This string is important and will be used in later steps <br />
        
|Lane|Sample_ID|Sample_Name|index|Sample_Project|
|--|--|--|--|--|
|7|SI-GA-A1_1|Aorta1|GGTTTACT|Chromium_20170913|
|7|SI-GA-A1_2|Aorta1|CTAAACGG|Chromium_20170913|
|7|SI-GA-A1_3|Aorta1|TCGGCGTC|Chromium_20170913|
|7|SI-GA-A1_4|Aorta1|AACCGTAA|Chromium_20170913|
|7|SI-GA-B1_1|Aorta2|GTAATCTT|Chromium_20170913|
|7|SI-GA-B1_2|Aorta2|TCCGGAAG|Chromium_20170913|
|7|SI-GA-B1_3|Aorta2|AGTTCGGC|Chromium_20170913|
|7|SI-GA-B1_4|Aorta2|CAGCATCA|Chromium_20170913|
|7|SI-GA-C1_1|LiverControl|CCACTTAT|Chromium_20170913|
|7|SI-GA-C1_2|LiverControl|AACTGGCG|Chromium_20170913|
|7|SI-GA-C1_3|LiverControl|TTGGCATA|Chromium_20170913|
|7|SI-GA-C1_4|LiverControl|GGTAACGC|Chromium_20170913|
|7|SI-GA-D1_1|LiverFibrosis|CACTCGGA|Chromium_20170913|
|7|SI-GA-D1_2|LiverFibrosis|GCTGAATT|Chromium_20170913|
|7|SI-GA-D1_3|LiverFibrosis|TGAAGTAC|Chromium_20170913|
|7|SI-GA-D1_4|LiverFibrosis|ATGCTCCG|Chromium_20170913|

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)

## Count
### 10X Genomics documentation and tutorials on the count software is available [here](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/count)

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)

## Aggr
### 10X Genomics documentation and tutorials on the aggr software is available [here](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/aggregate)

[Return to Contents](https://github.com/darneson/10XGenomics/#10xgenomics-cell-ranger-workflow)
