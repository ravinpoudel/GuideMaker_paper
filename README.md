# GuideMaker_paper

Scripts to parse timelogs from slurm and generate performance graphics



```python

### Usage
python timeparser.py -i slurm_avx2_logs/ -o avx2_out.csv
python timeparser.py -i slurm_nonavx2_logs/ -o nonavx2_out.csv

```


Plotting the output from `timeparser.py`  in R. 

```R

Rscript Plot.R 

```

## Plot

# ![alt text](https://github.com/USDA-ARS-GBRU/GuideMaker_paper/blob/master/figures/AVX2_Performance_Graph.png)




```python
### Usage
python distparser.py -i dist_profile_logs/ -o dist_profile.csv

```

## Table
Table summarizing output with different values of `dist` parameter across three genomes.

|Genome                                             |threads|dist|total_PAM_sites|n_candidate_PAM|percent_PAM_consider|total_locus|target_locus|missed_locus|missed_locus%|target_coverage%|mean_target|std_target|median_target|min_target|max_target|n_agg|n_cgg|n_ggg|n_tgg|
|---------------------------------------------------|-------|----|---------------|---------------|--------------------|-----------|------------|------------|-------------|----------------|-----------|----------|-------------|----------|----------|-----|-----|-----|-----|
|Escherichia.coli_str_K-12_substr_MG1655.gbk        |32     |1   |542073         |36108          |6.66                |4357       |4302        |55          |1.26%        |98.74%          |8.39       |3.7       |8            |1         |29        |8776 |9437 |7111 |10784|
|Escherichia.coli_str_K-12_substr_MG1655.gbk        |32     |2   |542073         |36031          |6.65                |4357       |4301        |56          |1.29%        |98.71%          |8.38       |3.7       |8            |1         |29        |8758 |9411 |7094 |10768|
|Escherichia.coli_str_K-12_substr_MG1655.gbk        |32     |3   |542073         |35845          |6.61                |4357       |4295        |62          |1.42%        |98.58%          |8.35       |3.7       |8            |1         |28        |8710 |9367 |7047 |10721|
|Escherichia.coli_str_K-12_substr_MG1655.gbk        |32     |4   |542073         |34763          |6.41                |4357       |4294        |63          |1.45%        |98.55%          |8.1        |3.66      |8            |1         |26        |8466 |9067 |6828 |10402|
|Escherichia.coli_str_K-12_substr_MG1655.gbk        |32     |5   |542073         |26086          |4.81                |4357       |4251        |106         |2.43%        |97.57%          |6.14       |3.17      |6            |1         |23        |6377 |6729 |5224 |7756 |
|Pseudomonas_aeruginosa_PAO1_107.gbk                |32     |1   |1171800        |46158          |3.94                |5584       |5462        |122         |2.18%        |97.82%          |8.45       |4.62      |8            |1         |29        |9977 |15182|10858|10141|
|Pseudomonas_aeruginosa_PAO1_107.gbk                |32     |2   |1171800        |46110          |3.93                |5584       |5460        |124         |2.22%        |97.78%          |8.45       |4.62      |8            |1         |29        |9964 |15166|10851|10129|
|Pseudomonas_aeruginosa_PAO1_107.gbk                |32     |3   |1171800        |45720          |3.9                 |5584       |5452        |132         |2.36%        |97.64%          |8.39       |4.6       |8            |1         |29        |9881 |15033|10753|10053|
|Pseudomonas_aeruginosa_PAO1_107.gbk                |32     |4   |1171800        |41789          |3.57                |5584       |5387        |197         |3.53%        |96.47%          |7.76       |4.44      |7            |1         |26        |9006 |13653|9958 |9172 |
|Pseudomonas_aeruginosa_PAO1_107.gbk                |32     |5   |1171800        |24736          |2.11                |5584       |4869        |715         |12.8%        |87.2%           |5.08       |3.36      |4            |1         |20        |5322 |7952 |6018 |5444 |
|Burkholderia_thailandensis_E264_ATCC_700388_133.gbk|32     |1   |923226         |36346          |3.94                |5633       |5323        |310         |5.5%         |94.5%           |6.83       |4.13      |6            |1         |34        |6019 |16403|7230 |6694 |
|Burkholderia_thailandensis_E264_ATCC_700388_133.gbk|32     |2   |923226         |36279          |3.93                |5633       |5322        |311         |5.52%        |94.48%          |6.82       |4.13      |6            |1         |34        |6006 |16375|7219 |6679 |
|Burkholderia_thailandensis_E264_ATCC_700388_133.gbk|32     |3   |923226         |35882          |3.89                |5633       |5309        |324         |5.75%        |94.25%          |6.76       |4.11      |6            |1         |34        |5955 |16142|7154 |6631 |
|Burkholderia_thailandensis_E264_ATCC_700388_133.gbk|32     |4   |923226         |32349          |3.5                 |5633       |5207        |426         |7.56%        |92.44%          |6.21       |3.94      |6            |1         |31        |5449 |14354|6445 |6101 |
|Burkholderia_thailandensis_E264_ATCC_700388_133.gbk|32     |5   |923226         |19886          |2.15                |5633       |4584        |1049        |18.62%       |81.38%          |4.34       |3.15      |4            |1         |29        |3601 |8376 |3989 |3920 |





### Note
Following parameters are used for analyzing performace of `GuideMaker`. Only the test paramters have been modified accordingly while other paramter remains the same. For instance, while profiling the output as a function of different `-dist ` [1, 2, 3, 4, 5] values, dist value was modified. Similarly, we profiled performace of `Guidemaker` with different `threads` values [1, 2, 4, 8, 16, and 32] on three genomes:
  - Escherichia.coli_str_K-12_substr_MG1655.gbk
  - Pseudomonas_aeruginosa_PAO1_107.gbk
  - Burkholderia_thailandensis_E264_ATCC_700388_133.gbk

```bash

guidemaker -i $inputgenome \
  --pamseq NGG  --outdir TEST --pam_orientation 5prime \
  --guidelength 20 --strand both --lcp 10 --dist 3 --before 100 \
  --into  100 --knum 10 --controls 10  --log $logfile --threads $THREADS


```










