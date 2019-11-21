library(data.table)
library(dplyr)

s_g <- fread("../data/convert_SRR_GSM.txt", col.names = c("SRR", "GSM"))
g_l <- fread("../data/GSM_ID.tsv", col.names = c("GSM", "LSL"))
c_l <- fread("../data/GSE115214_CD34_scRNA_colonies_table.txt", col.names = c("LSL", "CL"))

mmdf <- merge(merge(s_g, g_l, by = "GSM"), c_l, by = "LSL")
df <- mmdf
df$donor <- substr(as.character(df$CL), 1, 6)
df$old_bam <- paste0("mito_bam/", df$SRR, ".mito.bam")
df$old_bai <- paste0("mito_bam/", df$SRR, ".mito.bam.bai")
df$new_bam <- paste0(df$donor, "mito/", df$CL, ".bam")
df$new_bai <- paste0(df$donor, "mito/", df$CL, ".bam.bai")

go_1 <- data.frame(
  x = paste0("mv ", df$old_bai, " ", df$new_bai)
)

write.table(go_1, file = "../../cp_bai.sh", sep = "", quote = FALSE, row.names = FALSE, col.names = FALSE)
