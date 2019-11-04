#!/usr/bin/env nextflow
/*
========================================================================================
                         lifebit-ai/bcl2fastq-nf
========================================================================================
 lifebit-ai/bcl2fastq-nf Nextflow pipeline to run bcl2fastq to convert BCL files to FASTQ
 #### Homepage / Documentation
 https://github.com/lifebit-ai/bcl2fastq-nf
----------------------------------------------------------------------------------------
*/

// Load file parameters
Channel
  .fromPath (params.input_dir)
  .ifEmpty { exit 1, "Input dir folder not found ${params.input_dir}" }
  .set { input_dir }
Channel
  .fromPath (params.runfolder_dir)
  .ifEmpty { exit 1, "Runfolder dir not found ${params.runfolder_dir}" }
  .set { runfolder_dir }
Channel
  .fromPath (params.intensities_dir)
  .ifEmpty { exit 1, "Intensities dir not found ${params.intensities_dir}" }
  .set { intensities_dir }

// Set value parameters

/*--------------------------------------------------
  Run bcl2fastq to convert BCL files to FASTQ
---------------------------------------------------*/

process bcl2fastq {
  publishDir params.outdir, mode: 'copy'

  input:
  file(input_dir) from input_dir
  file(runfolder_dir) from runfolder_dir
  file(intensities_dir) from intensities_dir

  output:
  file "*" into results

  script:
  input_dir_flag = params.input_dir.endsWith("no_input_dir.txt") ? '' : "--input-dir ${input_dir}"
  runfolder_dir = params.runfolder_dir.endsWith("no_runfolder_dir.txt") ? '' : "--runfolder-dir ${runfolder_dir}"
  intensities_dir = params.intensities_dir.endsWith("no_intensities_dir.txt") ? '' : "--intensities-dir ${intensities_dir}"
  """
  bcl2fastq ${input_dir_flag} ${runfolder_dir} ${intensities_dir}
  """
}