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

root/ # entry comments can be inline after a '#'
      # or on their own line, also after a '#'

  readme.md # a child of, 'root/', it's indented
            # under its parent.

  usage.md  # indented syntax is nice for small projects
            # and short comments.

  src/          # directories MUST be identified with a '/'
    fileOne.txt # files don't need any notation
    fileTwo*    # '*' can identify executables
    fileThree@  # '@' can identify symlinks

## Mkfastq

## Count

## Aggr
