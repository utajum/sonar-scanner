#!/bin/bash
#══════════════════════════════════════════════════════════════════════════════
#   ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
#   ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#   ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#   ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
#
#   [ S Y S T E M   I N S T A L L E R ]
#
#   Sonar-Scan System Integration Script
#   https://github.com/utajum/sonar-scanner
#══════════════════════════════════════════════════════════════════════════════

VERSION="1.0.0"
SCRIPT_NAME="sonar-scan"
INSTALL_DIR="/usr/local/bin"
USE_SUDO=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null || echo "/tmp")"
SOURCE_SCRIPT="$SCRIPT_DIR/sonar-scan.sh"
REMOTE_SCRIPT_URL="https://raw.githubusercontent.com/utajum/sonar-scanner/refs/heads/master/sonar-scan.sh"

# Detect if running from pipe (curl | bash)
# When piped, BASH_SOURCE[0] won't be a real file
IS_PIPED=false
if [[ ! -f "${BASH_SOURCE[0]}" ]]; then
    IS_PIPED=true
fi

# ══════════════════════════════════════════════════════════════════════════════
#  C O L O R   M A T R I X
# ══════════════════════════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

NEON_PINK='\033[38;5;198m'
NEON_BLUE='\033[38;5;51m'
NEON_GREEN='\033[38;5;46m'
NEON_PURPLE='\033[38;5;129m'
NEON_ORANGE='\033[38;5;208m'
NEON_YELLOW='\033[38;5;226m'

# ══════════════════════════════════════════════════════════════════════════════
#  A S C I I   A R T
# ══════════════════════════════════════════════════════════════════════════════
show_banner() {
    clear
    echo -e "${NEON_PURPLE}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄   ║
    ║                                                                               ║
    ║   ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗       ║
    ║   ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗      ║
    ║   ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝      ║
    ║   ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗      ║
    ║   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║      ║
    ║   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝      ║
    ║                                                                               ║
    ║   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀   ║
    ║                                                                               ║
EOF
    echo -e "${NEON_CYAN}    ║                     ${NEON_YELLOW}[ S Y S T E M   I N S T A L L E R ]${NEON_CYAN}                   ║${NC}"
    echo -e "${NEON_PURPLE}    ║                                                                               ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${DIM}Version ${VERSION} // System Integration Protocol // github.com/utajum/sonar-scanner${NC}"
    echo ""
}

# ══════════════════════════════════════════════════════════════════════════════
#  O U T P U T   F U N C T I O N S
# ══════════════════════════════════════════════════════════════════════════════
cyber_echo() {
    local type="$1"
    local msg="$2"
    local timestamp=$(date +%H:%M:%S)
    
    case "$type" in
        "INIT")   echo -e "${GRAY}[${timestamp}]${NC} ${NEON_BLUE}[INIT]${NC}    ${WHITE}▸${NC} $msg" ;;
        "CHECK")  echo -e "${GRAY}[${timestamp}]${NC} ${NEON_PURPLE}[CHECK]${NC}   ${WHITE}▸${NC} $msg" ;;
        "DEPLOY") echo -e "${GRAY}[${timestamp}]${NC} ${NEON_CYAN}[DEPLOY]${NC}  ${WHITE}▸${NC} $msg" ;;
        "REMOVE") echo -e "${GRAY}[${timestamp}]${NC} ${NEON_ORANGE}[REMOVE]${NC}  ${WHITE}▸${NC} $msg" ;;
        "DONE")   echo -e "${GRAY}[${timestamp}]${NC} ${NEON_GREEN}[${BOLD}DONE${NC}${NEON_GREEN}]${NC}    ${WHITE}▸${NC} ${GREEN}$msg${NC}" ;;
        "FAIL")   echo -e "${GRAY}[${timestamp}]${NC} ${RED}[${BOLD}FAIL${NC}${RED}]${NC}    ${WHITE}▸${NC} ${RED}$msg${NC}" ;;
        "WARN")   echo -e "${GRAY}[${timestamp}]${NC} ${YELLOW}[WARN]${NC}    ${WHITE}▸${NC} ${YELLOW}$msg${NC}" ;;
        "INFO")   echo -e "${GRAY}[${timestamp}]${NC} ${CYAN}[INFO]${NC}    ${WHITE}▸${NC} $msg" ;;
        "SKIP")   echo -e "${GRAY}[${timestamp}]${NC} ${GRAY}[SKIP]${NC}    ${WHITE}▸${NC} ${DIM}$msg${NC}" ;;
        *)        echo -e "${GRAY}[${timestamp}]${NC} ${WHITE}[????]${NC}    ${WHITE}▸${NC} $msg" ;;
    esac
}

show_help() {
    show_banner
    echo -e "${NEON_CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NC}                       ${BOLD}I N S T A L L E R   C O M M A N D S${NC}                     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}  ${NEON_GREEN}USAGE:${NC}                                                                     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ./install.sh [OPTION]                                                    ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}  ${NEON_GREEN}OPTIONS:${NC}                                                                   ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-i, --install${NC}     Deploy sonar-scan to system                          ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-u, --update${NC}      Update existing installation                         ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-r, --remove${NC}      Purge sonar-scan from system                         ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-s, --status${NC}      Check installation status                            ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-h, --help${NC}        Display this help message                            ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}(no args)${NC}         Interactive mode                                     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}  ${NEON_GREEN}INSTALL LOCATION:${NC}                                                          ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${DIM}${INSTALL_DIR}/${SCRIPT_NAME}${NC}                                           ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_menu() {
    echo ""
    echo -e "${NEON_CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NC}             ${BOLD}S Y S T E M   I N T E G R A T I O N${NC}                  ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_GREEN}[1]${NC}  ${WHITE}▸▸▸${NC}  INSTALL                                       ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Install to /usr/local/bin${NC}                          ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_YELLOW}[2]${NC}  ${WHITE}▸▸▸${NC}  UPDATE                                        ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Upgrade existing installation${NC}                       ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_ORANGE}[3]${NC}  ${WHITE}▸▸▸${NC}  REMOVE                                        ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Purge implant from system${NC}                           ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_PURPLE}[4]${NC}  ${WHITE}▸▸▸${NC}  STATUS                                        ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Check current installation state${NC}                    ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${RED}[Q]${NC}  ${WHITE}▸▸▸${NC}  ABORT PROCEDURE                               ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -ne "    ${NEON_PURPLE}◢◤${NC} ${WHITE}SELECT OPERATION:${NC} "
    read -r MENU_CHOICE
    
    case "$MENU_CHOICE" in
        1) do_install ;;
        2) do_update ;;
        3) do_remove ;;
        4) do_status ;;
        q|Q) 
            echo ""
            cyber_echo "INFO" "Procedure aborted. Neural interface unchanged."
            exit 0
            ;;
        *)
            cyber_echo "FAIL" "Invalid selection. Access denied."
            exit 1
            ;;
    esac
}

# ══════════════════════════════════════════════════════════════════════════════
#  P R E F L I G H T   C H E C K S
# ══════════════════════════════════════════════════════════════════════════════
check_dependencies() {
    cyber_echo "CHECK" "Checking required dependencies..."
    
    local missing_deps=()
    
    # Check for bash (obviously we're running in bash, but check version)
    if [[ "${BASH_VERSION%%.*}" -lt 4 ]]; then
        cyber_echo "WARN" "Bash 4.0+ recommended (current: $BASH_VERSION)"
    fi
    
    # Check for docker
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
        cyber_echo "WARN" "Docker not detected - required for scanning operations"
    else
        cyber_echo "DONE" "Docker available"
    fi
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
        cyber_echo "FAIL" "curl not detected - required for API operations"
    else
        cyber_echo "DONE" "curl interface available"
    fi
    
    # Check for python3 (for JSON processing)
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
        cyber_echo "FAIL" "Python3 not detected - required for data processing"
    else
        cyber_echo "DONE" "Python3 processor available"
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo ""
        echo -e "    ${YELLOW}╔════════════════════════════════════════════════════════╗${NC}"
        echo -e "    ${YELLOW}║${NC}  ${BOLD}WARNING: Missing dependencies${NC}                         ${YELLOW}║${NC}"
        echo -e "    ${YELLOW}║${NC}  Install: ${missing_deps[*]}                                  ${YELLOW}║${NC}"
        echo -e "    ${YELLOW}╚════════════════════════════════════════════════════════╝${NC}"
        echo ""
        return 1
    fi
    
    return 0
}

check_source_script() {
    cyber_echo "CHECK" "Locating source script..."
    
    if [ ! -f "$SOURCE_SCRIPT" ]; then
        cyber_echo "INFO" "Source script not found locally, downloading from GitHub..."
        
        # Create temp file for download
        SOURCE_SCRIPT=$(mktemp)
        
        if ! curl -fsSL "$REMOTE_SCRIPT_URL" -o "$SOURCE_SCRIPT" 2>/dev/null; then
            cyber_echo "FAIL" "Failed to download sonar-scan.sh from GitHub"
            rm -f "$SOURCE_SCRIPT"
            exit 1
        fi
        
        cyber_echo "DONE" "Downloaded sonar-scan.sh from GitHub"
        return
    fi
    
    cyber_echo "DONE" "Source implant located: ${DIM}${SOURCE_SCRIPT}${NC}"
}

check_permissions() {
    cyber_echo "CHECK" "Verifying access permissions for ${INSTALL_DIR}..."
    
    if [ ! -d "$INSTALL_DIR" ]; then
        cyber_echo "WARN" "Install directory does not exist: $INSTALL_DIR"
        return 1
    fi
    
    if [ ! -w "$INSTALL_DIR" ]; then
        cyber_echo "WARN" "Write permission denied for $INSTALL_DIR"
        # Check if we can use sudo
        if command -v sudo &>/dev/null; then
            cyber_echo "INFO" "Elevating with sudo..."
            USE_SUDO=true
            return 0
        else
            cyber_echo "INFO" "Root access may be required (try: sudo ./install.sh)"
            return 1
        fi
    fi
    
    cyber_echo "DONE" "Write access confirmed"
    return 0
}

# Helper to run commands with sudo if needed
run_privileged() {
    if [ "$USE_SUDO" = true ]; then
        sudo "$@"
    else
        "$@"
    fi
}

is_installed() {
    [ -f "$INSTALL_DIR/$SCRIPT_NAME" ] || [ -L "$INSTALL_DIR/$SCRIPT_NAME" ]
}

get_installed_version() {
    if is_installed; then
        grep -m1 '^VERSION=' "$INSTALL_DIR/$SCRIPT_NAME" 2>/dev/null | cut -d'"' -f2
    else
        echo "not installed"
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
#  I N S T A L L   O P E R A T I O N
# ══════════════════════════════════════════════════════════════════════════════
do_install() {
    echo ""
    cyber_echo "INIT" "Starting installation..."
    echo ""
    
    check_source_script
    check_dependencies || true
    
    if ! check_permissions; then
        cyber_echo "FAIL" "Insufficient permissions. Attempting elevation..."
        echo ""
        echo -e "    ${YELLOW}Run with: ${WHITE}sudo ./install.sh --install${NC}"
        echo ""
        exit 1
    fi
    
    if is_installed; then
        local installed_ver=$(get_installed_version)
        cyber_echo "WARN" "Existing installation detected (v${installed_ver})"
        if [ "$IS_PIPED" = true ]; then
            cyber_echo "INFO" "Overwriting existing installation (piped mode)..."
        else
            echo -ne "    ${NEON_PURPLE}◢◤${NC} ${WHITE}Overwrite existing installation? [y/N]:${NC} "
            read -r confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                cyber_echo "INFO" "Installation aborted by user"
                exit 0
            fi
        fi
    fi
    
    cyber_echo "DEPLOY" "Installing to ${NEON_CYAN}${INSTALL_DIR}${NC}..."
    
    # Copy the script (not symlink - for portability)
    run_privileged cp "$SOURCE_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"
    run_privileged chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    if is_installed; then
        echo ""
        echo -e "${NEON_GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗  ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝  ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗  ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║  ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║  ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝  ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${BOLD}INSTALLATION COMPLETE${NC}                                     ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}Location:${NC}  ${NEON_CYAN}${INSTALL_DIR}/${SCRIPT_NAME}${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}Version:${NC}   ${NEON_YELLOW}${VERSION}${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}Execute with:${NC}  ${NEON_GREEN}sonar-scan${NC}                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}Get help:${NC}      ${NEON_GREEN}sonar-scan --help${NC}                       ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    else
        cyber_echo "FAIL" "Installation failed - unknown error"
        exit 1
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
#  U P D A T E   O P E R A T I O N
# ══════════════════════════════════════════════════════════════════════════════
do_update() {
    echo ""
    cyber_echo "INIT" "Starting upgrade..."
    echo ""
    
    check_source_script
    
    if ! is_installed; then
        cyber_echo "WARN" "No existing installation found"
        cyber_echo "INFO" "Running fresh installation instead..."
        do_install
        return
    fi
    
    if ! check_permissions; then
        cyber_echo "FAIL" "Insufficient permissions. Attempting elevation..."
        echo ""
        echo -e "    ${YELLOW}Run with: ${WHITE}sudo ./install.sh --update${NC}"
        echo ""
        exit 1
    fi
    
    local installed_ver=$(get_installed_version)
    local source_ver=$(grep -m1 '^VERSION=' "$SOURCE_SCRIPT" 2>/dev/null | cut -d'"' -f2)
    
    cyber_echo "INFO" "Installed version: ${NEON_YELLOW}${installed_ver}${NC}"
    cyber_echo "INFO" "Source version:    ${NEON_GREEN}${source_ver}${NC}"
    
    if [ "$installed_ver" = "$source_ver" ]; then
        cyber_echo "SKIP" "Versions identical - forcing update anyway..."
    fi
    
    cyber_echo "DEPLOY" "Upgrading installation..."
    
    # Backup old version (just in case)
    run_privileged cp "$INSTALL_DIR/$SCRIPT_NAME" "$INSTALL_DIR/${SCRIPT_NAME}.backup" 2>/dev/null || true
    
    # Deploy new version
    run_privileged cp "$SOURCE_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"
    run_privileged chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    # Remove backup on success
    run_privileged rm -f "$INSTALL_DIR/${SCRIPT_NAME}.backup" 2>/dev/null || true
    
    echo ""
    echo -e "${NEON_GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${BOLD}UPGRADE COMPLETE${NC}                                          ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}Previous:${NC}  ${DIM}${installed_ver}${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}Current:${NC}   ${NEON_YELLOW}${source_ver}${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# ══════════════════════════════════════════════════════════════════════════════
#  R E M O V E   O P E R A T I O N
# ══════════════════════════════════════════════════════════════════════════════
do_remove() {
    echo ""
    cyber_echo "INIT" "Starting removal..."
    echo ""
    
    if ! is_installed; then
        cyber_echo "SKIP" "No installation detected. Nothing to remove."
        return
    fi
    
    if ! check_permissions; then
        cyber_echo "FAIL" "Insufficient permissions. Attempting elevation..."
        echo ""
        echo -e "    ${YELLOW}Run with: ${WHITE}sudo ./install.sh --remove${NC}"
        echo ""
        exit 1
    fi
    
    local installed_ver=$(get_installed_version)
    
    cyber_echo "WARN" "This will remove sonar-scan v${installed_ver} from your system"
    echo -ne "    ${NEON_PURPLE}◢◤${NC} ${WHITE}Confirm removal? [y/N]:${NC} "
    read -r confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        cyber_echo "INFO" "Removal aborted by user"
        exit 0
    fi
    
    cyber_echo "REMOVE" "Removing sonar-scan..."
    
    run_privileged rm -f "$INSTALL_DIR/$SCRIPT_NAME"
    
    if ! is_installed; then
        echo ""
        echo -e "${NEON_ORANGE}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_ORANGE}║${NC}                                                              ${NEON_ORANGE}║${NC}"
        echo -e "${NEON_ORANGE}║${NC}  ${BOLD}UNINSTALL COMPLETE${NC}                                        ${NEON_ORANGE}║${NC}"
        echo -e "${NEON_ORANGE}║${NC}                                                              ${NEON_ORANGE}║${NC}"
        echo -e "${NEON_ORANGE}║${NC}  ${DIM}sonar-scan has been purged from your system${NC}                ${NEON_ORANGE}║${NC}"
        echo -e "${NEON_ORANGE}║${NC}  ${DIM}Run ./install.sh to reinstall${NC}                              ${NEON_ORANGE}║${NC}"
        echo -e "${NEON_ORANGE}║${NC}                                                              ${NEON_ORANGE}║${NC}"
        echo -e "${NEON_ORANGE}╚══════════════════════════════════════════════════════════════╝${NC}"
    else
        cyber_echo "FAIL" "Removal failed - unknown error"
        exit 1
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
#  S T A T U S   O P E R A T I O N
# ══════════════════════════════════════════════════════════════════════════════
do_status() {
    echo ""
    cyber_echo "CHECK" "Checking installation status..."
    echo ""
    
    local installed_ver=$(get_installed_version)
    local source_ver=$(grep -m1 '^VERSION=' "$SOURCE_SCRIPT" 2>/dev/null | cut -d'"' -f2 || echo "unknown")
    
    echo -e "${NEON_CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NC}               ${BOLD}S Y S T E M   S T A T U S${NC}                        ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    
    if is_installed; then
        echo -e "${NEON_CYAN}║${NC}  ${WHITE}Installation:${NC}  ${NEON_GREEN}▸▸ ACTIVE ◂◂${NC}                           ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}║${NC}  ${WHITE}Location:${NC}      ${DIM}${INSTALL_DIR}/${SCRIPT_NAME}${NC}"
        echo -e "${NEON_CYAN}║${NC}  ${WHITE}Installed Ver:${NC} ${NEON_YELLOW}${installed_ver}${NC}"
        echo -e "${NEON_CYAN}║${NC}  ${WHITE}Source Ver:${NC}    ${NEON_GREEN}${source_ver}${NC}"
        
        if [ "$installed_ver" != "$source_ver" ] && [ "$source_ver" != "unknown" ]; then
            echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
            echo -e "${NEON_CYAN}║${NC}  ${YELLOW}⚠ Update available! Run: ./install.sh --update${NC}           ${NEON_CYAN}║${NC}"
        fi
    else
        echo -e "${NEON_CYAN}║${NC}  ${WHITE}Installation:${NC}  ${RED}▸▸ NOT INSTALLED ◂◂${NC}                    ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}║${NC}  ${WHITE}Source Ver:${NC}    ${NEON_GREEN}${source_ver}${NC}"
        echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
        echo -e "${NEON_CYAN}║${NC}  ${DIM}Run: ./install.sh --install${NC}                                ${NEON_CYAN}║${NC}"
    fi
    
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    
    # Check dependencies
    echo ""
    cyber_echo "CHECK" "Dependency matrix scan..."
    echo ""
    
    echo -e "    ${WHITE}Docker:${NC}   $(command -v docker &>/dev/null && echo -e "${NEON_GREEN}✓ ONLINE${NC}" || echo -e "${RED}✗ OFFLINE${NC}")"
    echo -e "    ${WHITE}curl:${NC}     $(command -v curl &>/dev/null && echo -e "${NEON_GREEN}✓ ONLINE${NC}" || echo -e "${RED}✗ OFFLINE${NC}")"
    echo -e "    ${WHITE}Python3:${NC}  $(command -v python3 &>/dev/null && echo -e "${NEON_GREEN}✓ ONLINE${NC}" || echo -e "${RED}✗ OFFLINE${NC}")"
    echo ""
}

# ══════════════════════════════════════════════════════════════════════════════
#  M A I N   E N T R Y   P O I N T
# ══════════════════════════════════════════════════════════════════════════════
main() {
    case "${1:-}" in
        -i|--install)
            show_banner
            do_install
            ;;
        -u|--update)
            show_banner
            do_update
            ;;
        -r|--remove|--uninstall)
            show_banner
            do_remove
            ;;
        -s|--status)
            show_banner
            do_status
            ;;
        -h|--help)
            show_help
            ;;
        "")
            # Auto-install when piped (curl | bash), otherwise show menu
            if [ "$IS_PIPED" = true ]; then
                show_banner
                do_install
            else
                show_banner
                show_menu
            fi
            ;;
        *)
            cyber_echo "FAIL" "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${DIM}    ═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${DIM}    DONE // github.com/utajum/sonar-scanner${NC}"
    echo -e "${DIM}    ═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# ══════════════════════════════════════════════════════════════════════════════
#  E X E C U T E
# ══════════════════════════════════════════════════════════════════════════════
main "$@"
