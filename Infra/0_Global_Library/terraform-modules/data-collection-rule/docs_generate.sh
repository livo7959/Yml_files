#!/bin/bash

terraform-docs.exe  markdown table --output-file README.md --output-mode inject .
npx prettier README.md --write
