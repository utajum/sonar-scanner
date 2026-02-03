#!/bin/bash
#══════════════════════════════════════════════════════════════════════════════
#  ███████╗ ██████╗ ███╗   ██╗ █████╗ ██████╗       ███████╗ ██████╗ █████╗ ███╗   ██╗
#  ██╔════╝██╔═══██╗████╗  ██║██╔══██╗██╔══██╗      ██╔════╝██╔════╝██╔══██╗████╗  ██║
#  ███████╗██║   ██║██╔██╗ ██║███████║██████╔╝█████╗███████╗██║     ███████║██╔██╗ ██║
#  ╚════██║██║   ██║██║╚██╗██║██╔══██║██╔══██╗╚════╝╚════██║██║     ██╔══██║██║╚██╗██║
#  ███████║╚██████╔╝██║ ╚████║██║  ██║██║  ██║      ███████║╚██████╗██║  ██║██║ ╚████║
#  ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝
#                                                                    
#  [ C O D E   V U L N E R A B I L I T Y   H U N T E R ]
#  
#  Version: 1.0.0
#  Author:  https://github.com/utajum
#  License: MIT
#══════════════════════════════════════════════════════════════════════════════

VERSION="1.0.0"
SONAR_HOST="http://localhost:9000"
TARGET_DIR=""
ACTION=""
QUIET_MODE=false

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
BLINK='\033[5m'
NC='\033[0m' # No Color

# Neon colors for that cyberpunk feel
NEON_PINK='\033[38;5;198m'
NEON_BLUE='\033[38;5;51m'
NEON_GREEN='\033[38;5;46m'
NEON_PURPLE='\033[38;5;129m'
NEON_ORANGE='\033[38;5;208m'
NEON_YELLOW='\033[38;5;226m'

# ══════════════════════════════════════════════════════════════════════════════
#  A S C I I   A R T   &   B A N N E R S
# ══════════════════════════════════════════════════════════════════════════════
show_banner() {
    echo -e "${NEON_PURPLE}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄   ║
    ║                                                                               ║
    ║   ███████╗ ██████╗ ███╗   ██╗ █████╗ ██████╗       ███████╗ ██████╗ █████╗    ║
    ║   ██╔════╝██╔═══██╗████╗  ██║██╔══██╗██╔══██╗      ██╔════╝██╔════╝██╔══██╗   ║
    ║   ███████╗██║   ██║██╔██╗ ██║███████║██████╔╝█████╗███████╗██║     ███████║   ║
    ║   ╚════██║██║   ██║██║╚██╗██║██╔══██║██╔══██╗╚════╝╚════██║██║     ██╔══██║   ║
    ║   ███████║╚██████╔╝██║ ╚████║██║  ██║██║  ██║      ███████║╚██████╗██║  ██║   ║
    ║   ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚══════╝ ╚═════╝╚═╝  ╚═╝   ║
    ║                                                                               ║
    ║   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀   ║
    ║                                                                               ║
EOF
    echo -e "${NEON_CYAN}    ║            ${NEON_YELLOW}[ C O D E   V U L N E R A B I L I T Y   H U N T E R ]${NEON_CYAN}              ║${NC}"
    echo -e "${NEON_PURPLE}    ║                                                                               ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${DIM}Version ${VERSION} // github.com/utajum/sonar-scanner${NC}"
    echo ""
}

show_mini_banner() {
    echo -e "${NEON_PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NC}  ${NEON_CYAN}◢◤${NC} ${BOLD}SONAR-SCAN${NC} ${NEON_CYAN}◢◤${NC}  ${DIM}// Code Vulnerability Hunter v${VERSION}${NC}  ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
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
        "SCAN")   echo -e "${GRAY}[${timestamp}]${NC} ${NEON_GREEN}[SCAN]${NC}    ${WHITE}▸${NC} $msg" ;;
        "AUTH")   echo -e "${GRAY}[${timestamp}]${NC} ${NEON_PURPLE}[AUTH]${NC}    ${WHITE}▸${NC} $msg" ;;
        "PURGE")  echo -e "${GRAY}[${timestamp}]${NC} ${NEON_ORANGE}[PURGE]${NC}   ${WHITE}▸${NC} $msg" ;;
        "DEPLOY") echo -e "${GRAY}[${timestamp}]${NC} ${NEON_CYAN}[DEPLOY]${NC}  ${WHITE}▸${NC} $msg" ;;
        "DATA")   echo -e "${GRAY}[${timestamp}]${NC} ${NEON_YELLOW}[DATA]${NC}    ${WHITE}▸${NC} $msg" ;;
        "DONE")   echo -e "${GRAY}[${timestamp}]${NC} ${NEON_GREEN}[${BOLD}DONE${NC}${NEON_GREEN}]${NC}    ${WHITE}▸${NC} ${GREEN}$msg${NC}" ;;
        "FAIL")   echo -e "${GRAY}[${timestamp}]${NC} ${RED}[${BOLD}FAIL${NC}${RED}]${NC}    ${WHITE}▸${NC} ${RED}$msg${NC}" ;;
        "WARN")   echo -e "${GRAY}[${timestamp}]${NC} ${YELLOW}[WARN]${NC}    ${WHITE}▸${NC} ${YELLOW}$msg${NC}" ;;
        "INFO")   echo -e "${GRAY}[${timestamp}]${NC} ${CYAN}[INFO]${NC}    ${WHITE}▸${NC} $msg" ;;
        *)        echo -e "${GRAY}[${timestamp}]${NC} ${WHITE}[????]${NC}    ${WHITE}▸${NC} $msg" ;;
    esac
}

show_progress() {
    local current=$1
    local total=$2
    local label=$3
    local percent=$((current * 100 / total))
    local filled=$((percent / 5))
    local empty=$((20 - filled))
    
    printf "\r    ${NEON_PURPLE}[${NC}"
    printf "${NEON_GREEN}%0.s█${NC}" $(seq 1 $filled) 2>/dev/null || true
    printf "${GRAY}%0.s░${NC}" $(seq 1 $empty) 2>/dev/null || true
    printf "${NEON_PURPLE}]${NC} ${WHITE}%3d%%${NC} ${DIM}%s${NC}" "$percent" "$label"
}

show_spinner() {
    local pid=$1
    local msg=$2
    local spinchars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r    ${NEON_CYAN}[${spinchars:$i:1}]${NC} ${DIM}%s${NC}" "$msg"
        i=$(( (i + 1) % ${#spinchars} ))
        sleep 0.1
    done
    printf "\r    ${NEON_GREEN}[✓]${NC} %s${NC}\n" "$msg"
}

# ══════════════════════════════════════════════════════════════════════════════
#  H E L P   &   V E R S I O N
# ══════════════════════════════════════════════════════════════════════════════
show_help() {
    show_banner
    echo -e "${NEON_CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NC}                         ${BOLD}C O M M A N D   M A T R I X${NC}                          ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}  ${NEON_GREEN}USAGE:${NC}                                                                     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    sonar-scan [OPTIONS]                                                     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    sonar-scan [OPTIONS] <target-directory>                                  ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}  ${NEON_GREEN}OPTIONS:${NC}                                                                   ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-s, --scan${NC}        Run vulnerability scan ${DIM}(default action)${NC}              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-d, --download${NC}    Download all issues to JSON file                      ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-t, --target${NC}      Specify target directory ${DIM}(default: current dir)${NC}     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}--delete-images${NC}   Remove SonarQube Docker images                        ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-q, --quiet${NC}       Minimal output mode                                   ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-h, --help${NC}        Display this help message                             ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}-v, --version${NC}     Display version information                           ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}  ${NEON_GREEN}EXAMPLES:${NC}                                                                  ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${DIM}# Scan current directory${NC}                                                 ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}sonar-scan${NC}                                                               ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${DIM}# Scan specific directory${NC}                                                ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}sonar-scan /path/to/project${NC}                                             ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${DIM}# Download issues for current project${NC}                                    ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}    ${WHITE}sonar-scan --download${NC}                                                   ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_version() {
    echo -e "${NEON_PURPLE}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_PURPLE}║${NC}  ${BOLD}SONAR-SCAN${NC} ${NEON_GREEN}v${VERSION}${NC}                              ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NC}  ${DIM}Code Vulnerability Hunter${NC}                        ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}║${NC}  ${DIM}https://github.com/utajum/sonar-scanner${NC}          ${NEON_PURPLE}║${NC}"
    echo -e "${NEON_PURPLE}╚════════════════════════════════════════════════════╝${NC}"
}

# ══════════════════════════════════════════════════════════════════════════════
#  M E N U   S Y S T E M
# ══════════════════════════════════════════════════════════════════════════════
show_menu() {
    echo ""
    echo -e "${NEON_CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_CYAN}║${NC}               ${BOLD}S E L E C T   O P E R A T I O N${NC}                 ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_GREEN}[1]${NC}  ${WHITE}▸▸▸${NC}  RUN CODE SCAN                                 ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Analyze code for bugs and vulnerabilities${NC}          ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_YELLOW}[2]${NC}  ${WHITE}▸▸▸${NC}  DOWNLOAD ALL ISSUES                          ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Export issues to JSON file${NC}                         ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${NEON_ORANGE}[3]${NC}  ${WHITE}▸▸▸${NC}  DELETE DOCKER IMAGES                         ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}        ${DIM}Remove SonarQube Docker images${NC}                     ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}   ${RED}[Q]${NC}  ${WHITE}▸▸▸${NC}  EXIT                                         ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}║${NC}                                                              ${NEON_CYAN}║${NC}"
    echo -e "${NEON_CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -ne "    ${NEON_PURPLE}◢◤${NC} ${WHITE}ENTER COMMAND CODE:${NC} "
    read -r MENU_CHOICE
    
    case "$MENU_CHOICE" in
        1) ACTION="scan" ;;
        2) ACTION="download" ;;
        3) ACTION="delete-images" ;;
        q|Q) 
            echo ""
            cyber_echo "INFO" "Exiting. Goodbye!"
            exit 0
            ;;
        *)
            cyber_echo "FAIL" "Invalid command code. Access denied."
            exit 1
            ;;
    esac
}

# ══════════════════════════════════════════════════════════════════════════════
#  C O R E   F U N C T I O N S
# ══════════════════════════════════════════════════════════════════════════════
check_docker() {
    cyber_echo "INIT" "Checking Docker connection..."
    
    if ! docker info > /dev/null 2>&1; then
        cyber_echo "FAIL" "Docker daemon unreachable. Boot sequence failed."
        echo ""
        echo -e "    ${RED}╔════════════════════════════════════════════════════════╗${NC}"
        echo -e "    ${RED}║${NC}  ${BOLD}ERROR:${NC} Docker is not running                          ${RED}║${NC}"
        echo -e "    ${RED}║${NC}  Please start Docker and try again                      ${RED}║${NC}"
        echo -e "    ${RED}╚════════════════════════════════════════════════════════╝${NC}"
        exit 1
    fi
    
    cyber_echo "DONE" "Docker is running"
}

check_sonarqube() {
    cyber_echo "INIT" "Scanning for SonarQube instance at ${NEON_CYAN}${SONAR_HOST}${NC}..."
    
    if ! curl -s "$SONAR_HOST/api/system/status" > /dev/null 2>&1; then
        cyber_echo "WARN" "SonarQube not detected. Initiating deployment sequence..."
        echo ""
        echo -e "    ${NEON_YELLOW}╔════════════════════════════════════════════════════════╗${NC}"
        echo -e "    ${NEON_YELLOW}║${NC}  ${BOLD}DEPLOYING SONARQUBE CONTAINER${NC}                         ${NEON_YELLOW}║${NC}"
        echo -e "    ${NEON_YELLOW}║${NC}  ${DIM}This may take 1-2 minutes on first run...${NC}              ${NEON_YELLOW}║${NC}"
        echo -e "    ${NEON_YELLOW}╚════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        docker run -d --name sonarqube -p 9000:9000 sonarqube:latest 2>/dev/null || true
        
        cyber_echo "DEPLOY" "Container launched. Awaiting system initialization..."
        
        local wait_time=0
        local max_wait=120
        while [ $wait_time -lt $max_wait ]; do
            if curl -s "$SONAR_HOST/api/system/status" 2>/dev/null | grep -q '"status":"UP"'; then
                break
            fi
            show_progress $wait_time $max_wait "Initializing SonarQube core systems..."
            sleep 2
            wait_time=$((wait_time + 2))
        done
        echo ""
        
        if ! curl -s "$SONAR_HOST/api/system/status" 2>/dev/null | grep -q '"status":"UP"'; then
            cyber_echo "FAIL" "SonarQube initialization timeout. Manual intervention required."
            exit 1
        fi
    fi
    
    cyber_echo "DONE" "SonarQube instance online and operational"
}

authenticate() {
    cyber_echo "AUTH" "Authenticating with SonarQube..."
    
    local DEFAULT_PASSWORD="admin"
    local SECURE_PASSWORD="Sonarscanner1!"
    SONAR_TOKEN=""
    local TOKEN_NAME="scanner-token-$(date +%s)"
    local AUTH_SUCCESS=false
    
    # Try secure password first, then default
    for PASSWORD in "$SECURE_PASSWORD" "$DEFAULT_PASSWORD"; do
        cyber_echo "AUTH" "Trying credentials ${DIM}[${PASSWORD:0:3}***]${NC}"
        
        RESPONSE=$(curl -s -u "admin:$PASSWORD" "$SONAR_HOST/api/user_tokens/generate" -d "name=$TOKEN_NAME" 2>/dev/null)
        
        if echo "$RESPONSE" | grep -q '"token"'; then
            SONAR_TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
            AUTH_PASSWORD="$PASSWORD"
            AUTH_SUCCESS=true
            
            # If we logged in with default password, change it
            if [ "$PASSWORD" = "$DEFAULT_PASSWORD" ]; then
                cyber_echo "AUTH" "Default credentials detected. Updating password..."
                
                CHANGE_RESPONSE=$(curl -s -u "admin:$DEFAULT_PASSWORD" \
                    "$SONAR_HOST/api/users/change_password" \
                    -d "login=admin" \
                    -d "previousPassword=$DEFAULT_PASSWORD" \
                    -d "password=$SECURE_PASSWORD" 2>/dev/null)
                
                if [ -z "$CHANGE_RESPONSE" ] || echo "$CHANGE_RESPONSE" | grep -q "^$"; then
                    cyber_echo "DONE" "Password updated successfully"
                    AUTH_PASSWORD="$SECURE_PASSWORD"
                else
                    cyber_echo "WARN" "Password update failed. Proceeding with default credentials."
                fi
            fi
            break
        fi
    done
    
    if [ "$AUTH_SUCCESS" = false ]; then
        cyber_echo "FAIL" "Authentication failed. Access denied."
        echo ""
        echo -e "    ${RED}╔════════════════════════════════════════════════════════╗${NC}"
        echo -e "    ${RED}║${NC}  ${BOLD}AUTHENTICATION FAILED${NC}                                 ${RED}║${NC}"
        echo -e "    ${RED}║${NC}  Unable to authenticate with SonarQube                 ${RED}║${NC}"
        echo -e "    ${RED}║${NC}  Check your credentials and try again                  ${RED}║${NC}"
        echo -e "    ${RED}╚════════════════════════════════════════════════════════╝${NC}"
        exit 1
    fi
    
    cyber_echo "DONE" "Authentication successful. Token acquired."
}

purge_existing_project() {
    local project_key="$1"
    
    cyber_echo "PURGE" "Clearing previous scan data for ${NEON_CYAN}${project_key}${NC}..."
    
    # Check if project exists first
    local project_exists=$(curl -s -u "$SONAR_TOKEN:" "$SONAR_HOST/api/projects/search?projects=$project_key" 2>/dev/null | grep -c '"key"')
    
    if [ "$project_exists" -gt 0 ]; then
        # Delete the project
        local delete_response=$(curl -s -u "$SONAR_TOKEN:" -X POST "$SONAR_HOST/api/projects/delete?project=$project_key" 2>/dev/null)
        
        if [ -z "$delete_response" ]; then
            cyber_echo "DONE" "Previous project data cleared"
        else
            cyber_echo "WARN" "Clear may have encountered issues: ${delete_response}"
        fi
    else
        cyber_echo "INFO" "No previous scan data detected. Clean slate."
    fi
}

run_scan() {
    local target_dir="$1"
    local project_key=$(basename "$target_dir")
    
    echo ""
    echo -e "${NEON_GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_GREEN}║${NC}            ${BOLD}I N I T I A T I N G   S C A N   S E Q U E N C E${NC}        ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}TARGET:${NC}     ${NEON_CYAN}${project_key}${NC}"
    printf "${NEON_GREEN}║${NC}  ${WHITE}DIRECTORY:${NC}  ${DIM}%-43s${NC}  ${NEON_GREEN}║${NC}\n" "$target_dir"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}HOST:${NC}       ${NEON_PURPLE}${SONAR_HOST}${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}MODE:${NC}       ${NEON_YELLOW}FULL CODE ANALYSIS${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Purge existing project for fresh scan
    purge_existing_project "$project_key"
    
    cyber_echo "DEPLOY" "Starting scanner..."
    echo ""
    
    docker run --rm \
        --network host \
        -v "$target_dir:/usr/src" \
        sonarsource/sonar-scanner-cli \
        -Dsonar.projectKey="$project_key" \
        -Dsonar.sources=. \
        -Dsonar.host.url="$SONAR_HOST" \
        -Dsonar.token="$SONAR_TOKEN" \
        -Dsonar.exclusions="**/.git/**,**/node_modules/**,**/build/**,**/dist/**,**/vendor/**,**/*.min.js,**/*.min.css"
    
    local scan_exit_code=$?
    
    echo ""
    if [ $scan_exit_code -eq 0 ]; then
        echo -e "${NEON_GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}    █████╗  ██████╗ ██████╗███████╗███████╗███████╗          ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝          ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ███████║██║     ██║     █████╗  ███████╗███████╗          ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ██╔══██║██║     ██║     ██╔══╝  ╚════██║╚════██║          ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ██║  ██║╚██████╗╚██████╗███████╗███████║███████║          ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝          ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${BOLD}SCAN COMPLETE${NC}                                             ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}View results:${NC}                                             ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${NEON_CYAN}${SONAR_HOST}/dashboard?id=${project_key}${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}Login:${NC}     ${NEON_YELLOW}admin${NC}"
        echo -e "${NEON_GREEN}║${NC}  ${WHITE}Password:${NC}  ${NEON_YELLOW}Sonarscanner1!${NC}"
        echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
        echo -e "${NEON_GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    else
        echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC}                                                              ${RED}║${NC}"
        echo -e "${RED}║${NC}   ███████╗ █████╗ ██╗██╗     ███████╗██████╗                ${RED}║${NC}"
        echo -e "${RED}║${NC}   ██╔════╝██╔══██╗██║██║     ██╔════╝██╔══██╗               ${RED}║${NC}"
        echo -e "${RED}║${NC}   █████╗  ███████║██║██║     █████╗  ██║  ██║               ${RED}║${NC}"
        echo -e "${RED}║${NC}   ██╔══╝  ██╔══██║██║██║     ██╔══╝  ██║  ██║               ${RED}║${NC}"
        echo -e "${RED}║${NC}   ██║     ██║  ██║██║███████╗███████╗██████╔╝               ${RED}║${NC}"
        echo -e "${RED}║${NC}   ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚═════╝                ${RED}║${NC}"
        echo -e "${RED}║${NC}                                                              ${RED}║${NC}"
        echo -e "${RED}║${NC}  ${BOLD}SCAN FAILED${NC}                                                ${RED}║${NC}"
        echo -e "${RED}║${NC}  Exit code: ${scan_exit_code}                                               ${RED}║${NC}"
        echo -e "${RED}║${NC}                                                              ${RED}║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
        exit $scan_exit_code
    fi
}

download_issues() {
    local target_dir="$1"
    local project_key=$(basename "$target_dir")
    
    echo ""
    echo -e "${NEON_YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_YELLOW}║${NC}          ${BOLD}D A T A   E X T R A C T I O N   M O D E${NC}               ${NEON_YELLOW}║${NC}"
    echo -e "${NEON_YELLOW}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_YELLOW}║${NC}                                                              ${NEON_YELLOW}║${NC}"
    echo -e "${NEON_YELLOW}║${NC}  ${WHITE}PROJECT:${NC}  ${NEON_CYAN}${project_key}${NC}"
    echo -e "${NEON_YELLOW}║${NC}  ${WHITE}MODE:${NC}     ${NEON_PURPLE}EXPORT ALL ISSUES${NC}"
    echo -e "${NEON_YELLOW}║${NC}                                                              ${NEON_YELLOW}║${NC}"
    echo -e "${NEON_YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    local OUTPUT_FILE="${target_dir}/sonar-issues-${project_key}.json"
    local TEMP_FILE=$(mktemp)
    
    local PAGE=1
    local PAGE_SIZE=500
    local TOTAL_FETCHED=0
    
    echo "[]" > "$TEMP_FILE"
    
    cyber_echo "DATA" "Fetching issues from SonarQube..."
    
    while true; do
        cyber_echo "DATA" "Fetching page ${PAGE}..."
        
        RESPONSE=$(curl -s -u "$SONAR_TOKEN:" \
            "$SONAR_HOST/api/issues/search?componentKeys=$project_key&ps=$PAGE_SIZE&p=$PAGE")
        
        if echo "$RESPONSE" | grep -q '"errors"'; then
            cyber_echo "FAIL" "Data extraction failed"
            echo "$RESPONSE" | grep -o '"msg":"[^"]*"' | cut -d'"' -f4
            rm -f "$TEMP_FILE"
            exit 1
        fi
        
        RESULT=$(echo "$RESPONSE" | python3 -c "
import sys, json

data = json.load(sys.stdin)
issues = data.get('issues', [])
total = data.get('total', 0)

with open('$TEMP_FILE', 'r') as f:
    existing = json.load(f)

existing.extend(issues)
with open('$TEMP_FILE', 'w') as f:
    json.dump(existing, f)

print(f'{len(issues)}|{total}')
" 2>/dev/null)
        
        PAGE_ISSUE_COUNT=$(echo "$RESULT" | cut -d'|' -f1)
        TOTAL=$(echo "$RESULT" | cut -d'|' -f2)
        
        if [ -z "$PAGE_ISSUE_COUNT" ] || [ "$PAGE_ISSUE_COUNT" -eq 0 ]; then
            break
        fi
        
        TOTAL_FETCHED=$((TOTAL_FETCHED + PAGE_ISSUE_COUNT))
        
        show_progress $TOTAL_FETCHED $TOTAL "Downloading issues..."
        
        if [ "$TOTAL_FETCHED" -ge "$TOTAL" ]; then
            break
        fi
        
        PAGE=$((PAGE + 1))
    done
    
    echo ""
    
    # Create final JSON
    python3 -c "
import json
from datetime import datetime

with open('$TEMP_FILE', 'r') as f:
    issues = json.load(f)

output = {
    'project': '$project_key',
    'exportDate': datetime.now().isoformat(),
    'totalIssues': len(issues),
    'issues': issues
}

with open('$OUTPUT_FILE', 'w') as f:
    json.dump(output, f, indent=2)
"
    
    rm -f "$TEMP_FILE"
    
    echo ""
    echo -e "${NEON_GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${BOLD}DATA EXTRACTION COMPLETE${NC}                                  ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}Total Issues:${NC}  ${NEON_YELLOW}${TOTAL_FETCHED}${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${WHITE}Output File:${NC}   ${DIM}${OUTPUT_FILE}${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
}

delete_docker_images() {
    echo ""
    echo -e "${NEON_ORANGE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_ORANGE}║${NC}            ${BOLD}D O C K E R   I M A G E   C L E A N U P${NC}             ${NEON_ORANGE}║${NC}"
    echo -e "${NEON_ORANGE}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${NEON_ORANGE}║${NC}                                                              ${NEON_ORANGE}║${NC}"
    echo -e "${NEON_ORANGE}║${NC}  ${WHITE}MODE:${NC}  ${NEON_PURPLE}REMOVE SONARQUBE DOCKER IMAGES${NC}"
    echo -e "${NEON_ORANGE}║${NC}                                                              ${NEON_ORANGE}║${NC}"
    echo -e "${NEON_ORANGE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Stop and remove sonarqube container if running
    cyber_echo "PURGE" "Checking for running SonarQube container..."
    if docker ps -a --format '{{.Names}}' | grep -q '^sonarqube$'; then
        cyber_echo "PURGE" "Stopping and removing sonarqube container..."
        docker rm -f sonarqube >/dev/null 2>&1 && \
            cyber_echo "DONE" "Removed sonarqube container" || \
            cyber_echo "WARN" "Failed to remove sonarqube container"
    else
        cyber_echo "INFO" "No sonarqube container found"
    fi
    
    # Remove sonarqube image
    cyber_echo "PURGE" "Checking for sonarqube:latest image..."
    if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q '^sonarqube:latest$'; then
        cyber_echo "PURGE" "Removing sonarqube:latest image..."
        docker rmi sonarqube:latest >/dev/null 2>&1 && \
            cyber_echo "DONE" "Removed sonarqube:latest image" || \
            cyber_echo "WARN" "Failed to remove sonarqube:latest image"
    else
        cyber_echo "INFO" "sonarqube:latest image not found"
    fi
    
    # Remove sonar-scanner-cli image
    cyber_echo "PURGE" "Checking for sonar-scanner-cli image..."
    if docker images --format '{{.Repository}}' | grep -q '^sonarsource/sonar-scanner-cli$'; then
        cyber_echo "PURGE" "Removing sonarsource/sonar-scanner-cli image..."
        docker rmi sonarsource/sonar-scanner-cli >/dev/null 2>&1 && \
            cyber_echo "DONE" "Removed sonarsource/sonar-scanner-cli image" || \
            cyber_echo "WARN" "Failed to remove sonar-scanner-cli image"
    else
        cyber_echo "INFO" "sonar-scanner-cli image not found"
    fi
    
    echo ""
    echo -e "${NEON_GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}  ${BOLD}DOCKER CLEANUP COMPLETE${NC}                                   ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}║${NC}                                                              ${NEON_GREEN}║${NC}"
    echo -e "${NEON_GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
}

# ══════════════════════════════════════════════════════════════════════════════
#  A R G U M E N T   P A R S I N G
# ══════════════════════════════════════════════════════════════════════════════
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--scan)
                ACTION="scan"
                shift
                ;;
            -d|--download)
                ACTION="download"
                shift
                ;;
            -t|--target)
                TARGET_DIR="$2"
                shift 2
                ;;
            -q|--quiet)
                QUIET_MODE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            --delete-images|--cleanup)
                ACTION="delete-images"
                shift
                ;;
            -*)
                cyber_echo "FAIL" "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
            *)
                # Assume it's a target directory
                TARGET_DIR="$1"
                shift
                ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
#  M A I N   E N T R Y   P O I N T
# ══════════════════════════════════════════════════════════════════════════════
main() {
    parse_args "$@"
    
    # Set default target directory
    if [ -z "$TARGET_DIR" ]; then
        TARGET_DIR="$(pwd)"
    fi
    
    # Resolve to absolute path
    TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
        cyber_echo "FAIL" "Invalid target directory: $TARGET_DIR"
        exit 1
    }
    
    # Show banner
    if [ "$QUIET_MODE" = false ]; then
        show_banner
    else
        show_mini_banner
    fi
    
    # Show menu if no action specified
    if [ -z "$ACTION" ]; then
        show_menu
    fi
    
    echo ""
    cyber_echo "INIT" "Starting up..."
    
    # Run checks
    check_docker
    
    # Skip SonarQube checks for delete-images action
    if [ "$ACTION" != "delete-images" ]; then
        check_sonarqube
        authenticate
    fi
    
    # Execute action
    case "$ACTION" in
        scan)
            run_scan "$TARGET_DIR"
            ;;
        download)
            download_issues "$TARGET_DIR"
            ;;
        delete-images)
            delete_docker_images
            ;;
        *)
            cyber_echo "FAIL" "Unknown action: $ACTION"
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
