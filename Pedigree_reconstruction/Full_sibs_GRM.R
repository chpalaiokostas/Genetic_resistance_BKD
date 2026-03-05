library(dplyr)
library(tidyr)
library(igraph)
library(ggraph)

grm_long <- read.table(file = "G_Orig.txt",
                       header = T,
                       sep = " ",
                       stringsAsFactors = F)

# Remove any rows where either ID contains "yc2021"
grm_filtered <- grm_long %>%
  filter(!grepl("yc2021", id1) & !grepl("yc2021", id2))

# Extract diagonals from the filtered set
diagonals <- grm_filtered %>%
  filter(id1 == id2) %>%
  select(id = id1, g_diag = g_value)

grm_norm <- grm_filtered %>%
  left_join(diagonals, by = c("id1" = "id")) %>%
  left_join(diagonals, by = c("id2" = "id")) %>%
  # Relationship / sqrt(Self_A * Self_B)
  mutate(g_corr = g_value / sqrt(g_diag.x * g_diag.y)) %>%
  filter(id1 != id2) # Remove diagonal after calculation

# pmin/pmax to ensure A-B and B-A are treated as the same edge
edges_clean <- grm_norm %>%
  filter(g_corr >= 0.45) %>%
  mutate(
    nodeA = pmin(as.character(id1), as.character(id2)),
    nodeB = pmax(as.character(id1), as.character(id2))
  ) %>%
  distinct(nodeA, nodeB, .keep_all = TRUE) %>%
  select(nodeA, nodeB, weight = g_corr)

# network construction
net <- graph_from_data_frame(d = edges_clean, directed = FALSE)
net <- simplify(net) # Safety check for multi-edges

# Fast Greedy works well, but Louvain is often better for mixed cohorts
clusters <- cluster_louvain(net) 

# family assignment
family_assignments <- data.frame(
  Individual = V(net)$name,
  FamilyID = clusters$membership
)

table(family_assignments$FamilyID)

# Visualize graph
ggraph(net, layout = "fr") + # Fruchterman-Reingold layout pulls clusters together
  geom_edge_link(alpha = 0.2, color = "gray") + 
  geom_node_point(aes(color = as.factor(clusters$membership)),alpha = 0.4, size = 2) +
  theme_void() +
  labs(title = "Reconstructed Pedigree Network",
       color = "Family ID") 
