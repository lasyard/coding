#!/usr/bin/env sh

# Download `plantuml.jar` from
# https://plantuml.com/zh/download

java -jar "${HOME}/bin/plantuml.jar" -tpng "$1"
