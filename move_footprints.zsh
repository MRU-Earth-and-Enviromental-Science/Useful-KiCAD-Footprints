#!/bin/zsh

GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[1;31m'
CYAN=$'\033[1;36m'
RESET=$'\033[0m'

spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 $pid 2>/dev/null; do
    printf "\r${CYAN} 🔍 Searching for KiCad project... %c${RESET}" "$spinstr"
    spinstr=${spinstr#?}${spinstr%???}
    sleep $delay
  done
  printf "\r${GREEN}✅ Found KiCad project.           \n"
}

{ 
  project_path=$(find ~ -type f \( -name "*.kicad_pro" -o -name "*.kicad_pcb" \) 2>/dev/null | head -n 1)
} &
spinner $!

# Check result
if [[ -z "$project_path" ]]; then
  echo "${RED}❌ No KiCad project file found."
  exit 1
fi

# Directory setup
project_dir=$(dirname "$project_path")
footprint_dir="$project_dir/footprints"
mkdir -p "$footprint_dir"

# Move .kicad_mod files
echo "${YELLOW}📦 Moving .kicad_mod files to: $footprint_dir"
mv -- *.kicad_mod "$footprint_dir" 2>/dev/null

echo "{GREEN}✅ Done."
