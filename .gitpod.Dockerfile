FROM gitpod/workspace-full

RUN brew install R pandoc

RUN sudo apt-get -q update && 
      sudo apt-get install -yq libcurl4-openssl-dev libgit2-dev &&
      sudo apt install libharfbuzz-dev libfribidi-dev

# Prepare
RUN Rscript -e "if (!requireNamespace('remotes')) install.packages('remotes', type = 'source')"
RUN Rscript -e "if (getRversion() < '3.2' && !requireNamespace('curl')) install.packages('curl', type = 'source')"
RUN while read -r cmd; do eval sudo $cmd; done < <(Rscript -e 'writeLines(remotes::system_requirements("ubuntu", "20.04"))')

RUN Rscript -e "remotes::install_github('ropensci/tic')" -e "print(tic::dsl_load())" -e "tic::prepare_all_stages()" -e "tic::before_install()" -e "tic::install()"
RUN Rscript -e 'tic::script()'
RUN Rscript -e 'tic::script()'
