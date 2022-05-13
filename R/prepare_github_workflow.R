prepare_github_workflow <- function() {
  old_wd <- getwd()
  on.exit(setwd(old_wd))

  setwd(dir_support("github_actions/"))

  ret <- yaml::yaml.load_file("build_and_release.yaml")

  walk_tree <- function(node, parent_node){

    if("parochial_merge" %in% names(node)){
      new_node <- node

      for (j in seq_along(node$parochial_merge)) {
        to_be_merged <- yaml::yaml.load_file(paste0(node$parochial_merge[[j]], ".yaml"))
        new_node <- c(node, to_be_merged)
      }

      new_node$parochial_merge <- NULL

      return(walk_tree(new_node, parent_node))
    }

    for (i in seq_along(node)) {
      child_node <- node[[i]]

      if(inherits(child_node, 'character')){
        node[[i]] <- child_node %>%
          stringr::str_replace_all("<%(.+?)%>", function(x){ eval(parse(text=str_sub(x, 3,-3))) })
      }

      if("parochial_replace_with" %in% names(child_node)){
        replacement <- yaml::yaml.load_file(paste0(child_node$parochial_replace_with, ".yaml"))

        child_node$parochial_replace_with <- NULL

        for(j in seq_along(replacement)){
          replacement[[j]] <- c(replacement[[j]], child_node)
        }

        new_node <- c(node[0:(i-1)], replacement)

        if(i+1 <= length(node)){
          new_node <- c(new_node, node[(i+1):length(node)])
        }

        new_node <- as.list(new_node)
        return(walk_tree(new_node, parent_node))
      }

      if(inherits(child_node, 'list')){
        node[[i]] <- walk_tree(child_node, node)
      }

    }

    return(node)
  }

  ret <- walk_tree(ret)

  setwd(old_wd)

  dest_path <- ".github/workflows/build-and-release.yaml"

  ret %>%
    yaml::as.yaml() %>%
    writeChar(dest_path, eos=NULL)

  return(".github/workflows/build-and-release.yaml")
}