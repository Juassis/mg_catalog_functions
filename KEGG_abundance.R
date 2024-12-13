# Load necessary libraries
library(dplyr)
library(tidyr)
library(readr)

# Read KEGG data
kegg <- read.delim("01_KEGG_Modules", 
                   sep = "\t", 
                   row.names = NULL, 
                   stringsAsFactors = FALSE)

# Read Counts data
counts <- read.delim("/Users/jasge/Documents/01_Gene_Catalog/R_analysis/Share_Results_AllGenes/New/File_D.tsv", sep = "\t", stringsAsFactors = FALSE)
colnames(counts)[1] <- "gene"  # Ensure the first column is named 'gene'

# Reshape KEGG data to a long format (one module per row)
kegg_long <- kegg %>%
  pivot_longer(cols = starts_with("KEGG_Module"), names_to = "Module_Type", values_to = "KEGG_Module") %>%
  filter(KEGG_Module != "")  # Remove empty rows

# Reshape Counts data to a long format for M01 to M30
counts_long <- counts %>%
  pivot_longer(cols = starts_with("M"), names_to = "Sample", values_to = "Abundance")

# Join the KEGG and Counts data
merged_data <- kegg_long %>%
  left_join(counts_long, by = "gene", relationship = "many-to-many")

# Group by KEGG_Module and Sample, then sum the abundances
result <- merged_data %>%
  group_by(KEGG_Module, Sample) %>%
  summarize(Count = sum(Abundance, na.rm = TRUE), .groups = "drop")

# Pivot the result to wide format with KEGG_Module as rows and Samples as columns
final_output <- result %>%
  pivot_wider(names_from = Sample, values_from = Count, values_fill = list(Count = 0))

# Print the final output
print(final_output)

# Optionally write to a file
write.table(final_output, "KEGG_Counts_Output.txt", sep = "\t", row.names = FALSE, quote = FALSE)
