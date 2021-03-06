arquivos <- list.files("dados_hex", full.names = TRUE)
dados <- lapply(arquivos, read.table, header = FALSE)
dados <- data.frame(dados)
names(dados) <- c("Casos", "X_c", "Y_c", "Pop")

#' Title llr.ksc
#'
#' @param dados: data-frame com quatro colunas: casos, X_c, Y_c e populacao
#'
#' @return Data Frame com relacao de zonas e respectivos logs. da razao de veros.
#' @export
#'
#' @examples
llr.ksc <- function(dados){
  pop_total <- sum(dados$Pop)
  casos_total <- sum(dados$Casos)
  
  # Matriz de distâncias
  
  mat_dist <- dist(dados[, 2:3])
  mat_dist <- as.matrix(mat_dist)
  
  diag(mat_dist) <- NA
  mat_dist_ind <- matrix(ncol = nrow(dados), nrow = nrow(dados) - 1)
  
  # Gerando a matriz de distancias ordenada por indices
  for (i in 1:nrow(dados)) {
    mat_dist_ind[, i] <- head(order(mat_dist[, i]), -1)
  }
  
  
  resultado <- data.frame()
  
  for(i in 1:ncol(mat_dist_ind)){
    zona <- i
    for(j in mat_dist_ind[,i]){
      zona <- append(zona,j)
      n_z <- sum(dados[zona, 4])
      if(n_z > pop_total/2){
        zona <- zona[1:length(zona)-1]
        next()
      }
      c_z <- sum(dados[zona, 1])
      mu_z <- casos_total * (n_z / pop_total)
      ifelse(c_z > mu_z,
             llr_z <-
               c_z * log(c_z / mu_z) +
               (casos_total - c_z) * log((casos_total - c_z) /                                              (casos_total - mu_z)),
             llr_z <- 0)
      resultado <- rbind(resultado, cbind(list(zona), llr_z))
      
    }
  }
  return(resultado)
}