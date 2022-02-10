library("fields")


color.som.by.property <- function(som, property, center = 0, scale = 0, ...) {
		colors <- colorRampPalette(c("darkblue", "blue", "cyan", "lightgreen", "yellow", "red"))
		nr <- som$grid$ydim
		nc <- som$grid$xdim
		m <- matrix(som$codes[,property], nr, nc, byrow = F)
		if (scale != 0) {
			m <- m * scale + center
		}
		
		image.plot(
			c(1:nr),
			c(1:nc),
			m,
			xaxt = "n",
			yaxt = "n",
			breaks = quantile(m, probs = seq(0, 1, 0.02)),
			col = colors(length(seq(0, 1, 0.02)) - 1),
			...)
		
			abline(
				h = c(1:nc) + 0.5,
				v = c(1:nr) + 0.5,
				col = "white",
				lwd = 0.5,
				xpd = F)
	
			abline(
				h = seq(0, nr, 10) + 0.5,
				v = seq(0, nc, 10) + 0.5,
				col = "black",
				lwd = 1,
				xpd = F)
	}


project.matrix.on.som <- function(som, matrix.to.be.mapped) {
	
		# Prepare SOM
		i <- as.character(dim(som$codes))
		i <- append(i, as.character(som$codes))
		
		# Prepare matrix
		i <- append(i, as.character(dim(matrix.to.be.mapped)))
		i <- append(i, as.character(matrix.to.be.mapped))
		if (dim(som$codes)[2] != dim(matrix.to.be.mapped)[2]) {
			stop("SOM and matrix don't have equal number of columns!")
		}
		
		# Run command - modify the actual location of som-it if needed
		r <- system("/usr/local/bin/som-it", intern=T, input=i)
		
		# Format return value
		n <- c(1, dim(som$codes)[1])
		length(n) <- 6
		n[3] <- n[2] + 1
		n[4] <- n[3] + dim(matrix.to.be.mapped)[1] - 1
		n[5] <- n[4] + 1
		n[6] <- n[5] + dim(matrix.to.be.mapped)[1] - 1
		l <- list(
			counts = matrix(as.integer(r[n[1]:n[2]]), sqrt(n[2]), sqrt(n[2]), byrow = F), 
			mappings = as.integer(r[n[3]:n[4]]),
			distances = as.double(r[n[5]:n[6]]))
		l
	}


plot.matrix.as.heatmap <- function(m, ...) {
		colors <- colorRampPalette(c("green", "white", "red", "orange"))
		nr <- dim(m)[1]
		nc <- dim(m)[2]
		avg <- mean(as.vector(m))
		std <- sd(as.vector(m))
		minimum <- 0
		if (avg - 4 * std > 0) { minimum <- avg - 4 * std }
		maximum <- avg + 4 * std
		if (max(m) < maximum) { maximum <- max(m) }
		breaks1 <- seq(minimum, avg, (avg - minimum) / 10)
		breaks2 <- seq(avg, maximum, (maximum - avg) / 20)
		breaks <- c(breaks1, breaks2[-1])
		ncolors <- length(breaks) - 1
		m[m > maximum] <- maximum

		image(
			c(1:nr),
			c(1:nc),
			m,
			breaks = breaks,
			col = colors(ncolors),
			xaxt = "n",
			yaxt = "n",
			...)

		abline(
			h = c(1:nc) + 0.5,
			v = c(1:nr) + 0.5,
			col = "white",
			lwd = 0.5,
			xpd = F)
		
		abline(
			h = seq(0, nr, 10) + 0.5,
			v = seq(0, nc, 10) + 0.5,
			col = "black",
			lwd = 1,
			xpd = F)

	}
