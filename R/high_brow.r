#' Browse highlighted fragments in your default browser.
#' 
#' @import whisker
#' @param input Input, usually output from a call to \code{\link[rplos]{highplos}}
#' @param output Path and file name for output file. If NULL, a temp file is used.
#' @param browse Browse file in your default browse immediately after file creation.
#'    If FALSE, the file is written, but not opened.
#' @export
#' @examples \dontrun{
#' out <- highplos(q='alcohol', hl.fl = 'abstract', limit=10)
#' high_brow(out)
#' 
#' out <- highplos(q='alcohol', hl.fl = 'abstract', limit=1200)
#' high_brow(out)
#' }

high_brow <- function(input=NULL, output=NULL, browse=TRUE)
{
  if(is.null(input))
    stop("Please supply some input")
  
  # replace length 0 lists with "no data"
  input <- lapply(input, function(x) ifelse(length(x)==0, "no data", x))
  
  tmp <- NULL
  outlist <- list()
  for(i in seq_along(input)){
    tmp$doi <- names(input[i])
    tmp$content <- input[[i]][[1]]
    outlist[[i]] <- tmp
  }
  
  template <-
    '<!DOCTYPE html>
      <head>
        <meta charset="utf-8">
      	<title>rplos - view highlighs</title>
      	<meta name="viewport" content="width=device-width, initial-scale=1.0">
      	<meta name="description" content="View highlights from rplos search">
      	<meta name="author" content="rplos">

      	<!-- Le styles -->
      	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css" rel="stylesheet">
      	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.css" rel="stylesheet">
      	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-responsive.css" rel="stylesheet">
      </head>

      <body>

      <div class="container">

      <center><h2>rplos - highlights</h2></center>

      <table class="table table-striped table-hover" align="center">
      	<thead>
      		<tr>
      			<th>DOI</th>
      			<th>Fragment</th>
      		</tr>
      	</thead>
      	<tbody>
        {{#outlist}}
          <tr><td><a href="http://dx.doi.org/{{doi}}">{{doi}}</a></td><td>{{content}}</td></tr>
        {{/outlist}}
        </tbody>
      </table>
      </div>

      <script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
      <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>

      </body>
      </html>'
        
  rendered <- whisker.render(template)
  rendered <- gsub("&lt;em&gt;", "<b>", rendered)
  rendered <- gsub("&lt;/em&gt;", "</b>", rendered)
  if(is.null(output))
    output <- tempfile(fileext=".html")
  write(rendered, file = output)
  if(browse) browseURL(output)
}