#!/usr/bin/env bash
# Premium TUI utilities for font management scripts
# Typography-themed interface with professional polish

# Animation and display utilities
SPINNER_PID=""
SPINNER_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
WAVE_FRAMES=('▁' '▂' '▃' '▄' '▅' '▆' '▇' '█' '▇' '▆' '▅' '▄' '▃' '▂')
DOTS_FRAMES=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
SPINNER_DELAY=0.08

# Extended color palette
if [[ -t 1 ]]; then
    # Text styles
    BOLD='\033[1m'
    DIM='\033[2m'
    ITALIC='\033[3m'
    UNDERLINE='\033[4m'
    BLINK='\033[5m'
    REVERSE='\033[7m'
    RESET='\033[0m'

    # Standard colors
    BLACK='\033[30m'
    RED='\033[31m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    MAGENTA='\033[35m'
    CYAN='\033[36m'
    WHITE='\033[37m'

    # Bright colors
    BRIGHT_BLACK='\033[90m'
    BRIGHT_RED='\033[91m'
    BRIGHT_GREEN='\033[92m'
    BRIGHT_YELLOW='\033[93m'
    BRIGHT_BLUE='\033[94m'
    BRIGHT_MAGENTA='\033[95m'
    BRIGHT_CYAN='\033[96m'
    BRIGHT_WHITE='\033[97m'

    # Background colors
    BG_BLACK='\033[40m'
    BG_RED='\033[41m'
    BG_GREEN='\033[42m'
    BG_YELLOW='\033[43m'
    BG_BLUE='\033[44m'
    BG_MAGENTA='\033[45m'
    BG_CYAN='\033[46m'
    BG_WHITE='\033[47m'
else
    BOLD='' DIM='' ITALIC='' UNDERLINE='' BLINK='' REVERSE='' RESET=''
    BLACK='' RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' CYAN='' WHITE=''
    BRIGHT_BLACK='' BRIGHT_RED='' BRIGHT_GREEN='' BRIGHT_YELLOW=''
    BRIGHT_BLUE='' BRIGHT_MAGENTA='' BRIGHT_CYAN='' BRIGHT_WHITE=''
    BG_BLACK='' BG_RED='' BG_GREEN='' BG_YELLOW='' BG_BLUE='' BG_MAGENTA='' BG_CYAN='' BG_WHITE=''
fi

# Box drawing characters - double line for headers
BOX_D_TL='╔'
BOX_D_TR='╗'
BOX_D_BL='╚'
BOX_D_BR='╝'
BOX_D_H='═'
BOX_D_V='║'
BOX_D_VR='╠'
BOX_D_VL='╣'
BOX_D_HU='╩'
BOX_D_HD='╦'
BOX_D_PLUS='╬'

# Single line for content
BOX_TL='┌'
BOX_TR='┐'
BOX_BL='└'
BOX_BR='┘'
BOX_H='─'
BOX_V='│'
BOX_VR='├'
BOX_VL='┤'
BOX_HU='┴'
BOX_HD='┬'
BOX_PLUS='┼'

# Tree characters
TREE_BRANCH='├─'
TREE_LAST='└─'
TREE_PIPE='│ '
TREE_SPACE='  '

# ═══════════════════════════════════════════════════════════════
# TYPOGRAPHY ASCII ART
# ═══════════════════════════════════════════════════════════════

print_font_art() {
    cat << 'EOF'
    ___                 _
   | __|___   _ _   | |_ ___
   | _/ _ \ | ' \ |  _(_-<
   |_|\___/ |_||_| \__/__/
EOF
}

print_font_art_big() {
    cat << 'EOF'
    ███████╗ ██████╗ ███╗   ██╗████████╗███████╗
    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔════╝
    █████╗  ██║   ██║██╔██╗ ██║   ██║   ███████╗
    ██╔══╝  ██║   ██║██║╚██╗██║   ██║   ╚════██║
    ██║     ╚██████╔╝██║ ╚████║   ██║   ███████║
    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝
EOF
}

print_typography_symbol() {
    local symbol="${1:-Aa}"
    case "$symbol" in
        "Aa")
            cat << 'EOF'
       █████╗  ▄▄▄
      ██╔══██╗██╔══██╗
      ███████║███████║
      ██╔══██║██╔══██║
      ██║  ██║██║  ██║
      ╚═╝  ╚═╝╚═╝  ╚═╝
EOF
            ;;
        "f")
            cat << 'EOF'
         ██╗
        ██╔╝
       ██╔╝
      ██╔╝
     ██╔╝
     ╚═╝
EOF
            ;;
        "@")
            cat << 'EOF'
       ▄▄▄▄▄
      █     █
     █ ▄▄█ █
     █▄█ █ █
      █▄▄▄█
EOF
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════
# BANNER FUNCTIONS
# ═══════════════════════════════════════════════════════════════

print_banner() {
    local title="$1"
    local subtitle="${2:-}"
    local width=68

    echo ""
    echo -e "${BRIGHT_CYAN}${BOX_D_TL}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_D_H}")${BOX_D_TR}${RESET}"

    # Center the title
    local title_len=${#title}
    local padding=$(( (width - title_len - 2) / 2 ))
    printf "${BRIGHT_CYAN}${BOX_D_V}${RESET}"
    printf "%*s" $padding ""
    echo -ne "${BOLD}${BRIGHT_MAGENTA}${title}${RESET}"
    printf "%*s" $((width - title_len - padding - 2)) ""
    echo -e "${BRIGHT_CYAN}${BOX_D_V}${RESET}"

    if [[ -n "$subtitle" ]]; then
        local sub_len=${#subtitle}
        local sub_padding=$(( (width - sub_len - 2) / 2 ))

        echo -e "${BRIGHT_CYAN}${BOX_D_VR}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_D_H}")${BOX_D_VL}${RESET}"

        printf "${BRIGHT_CYAN}${BOX_D_V}${RESET}"
        printf "%*s" $sub_padding ""
        echo -ne "${DIM}${CYAN}${subtitle}${RESET}"
        printf "%*s" $((width - sub_len - sub_padding - 2)) ""
        echo -e "${BRIGHT_CYAN}${BOX_D_V}${RESET}"
    fi

    echo -e "${BRIGHT_CYAN}${BOX_D_BL}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_D_H}")${BOX_D_BR}${RESET}"
    echo ""
}

print_banner_figlet() {
    local title="$1"
    local subtitle="${2:-}"

    if command -v figlet &>/dev/null; then
        echo ""
        echo -e "${BRIGHT_MAGENTA}"
        figlet -f small "$title" | sed 's/^/    /'
        echo -e "${RESET}"
        if [[ -n "$subtitle" ]]; then
            echo -e "    ${DIM}${CYAN}${subtitle}${RESET}"
            echo ""
        fi
    else
        print_banner "$title" "$subtitle"
    fi
}

# ═══════════════════════════════════════════════════════════════
# SPINNER & LOADING ANIMATIONS
# ═══════════════════════════════════════════════════════════════

start_spinner() {
    local message="${1:-Working}"
    local style="${2:-dots}"  # dots, wave, classic

    {
        local i=0
        tput civis  # Hide cursor

        case "$style" in
            "wave")
                while true; do
                    printf "\r  ${WAVE_FRAMES[$i]} ${BRIGHT_CYAN}%s${RESET}" "$message"
                    i=$(( (i + 1) % ${#WAVE_FRAMES[@]} ))
                    sleep 0.1
                done
                ;;
            "dots")
                while true; do
                    printf "\r  ${BRIGHT_MAGENTA}${DOTS_FRAMES[$i]}${RESET} ${CYAN}%s${RESET}" "$message"
                    i=$(( (i + 1) % ${#DOTS_FRAMES[@]} ))
                    sleep $SPINNER_DELAY
                done
                ;;
            *)
                while true; do
                    printf "\r  ${BRIGHT_CYAN}${SPINNER_FRAMES[$i]}${RESET} ${CYAN}%s${RESET}" "$message"
                    i=$(( (i + 1) % ${#SPINNER_FRAMES[@]} ))
                    sleep $SPINNER_DELAY
                done
                ;;
        esac
    } &

    SPINNER_PID=$!
}

stop_spinner() {
    if [[ -n "$SPINNER_PID" ]]; then
        kill "$SPINNER_PID" 2>/dev/null
        wait "$SPINNER_PID" 2>/dev/null
        SPINNER_PID=""
        printf "\r%*s\r" 80 ""  # Clear line
        tput cnorm  # Show cursor
    fi
}

# ═══════════════════════════════════════════════════════════════
# PROGRESS BAR
# ═══════════════════════════════════════════════════════════════

print_progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))

    # Gradient effect
    local bar_color="${BRIGHT_GREEN}"
    if [[ $percentage -lt 30 ]]; then
        bar_color="${BRIGHT_RED}"
    elif [[ $percentage -lt 70 ]]; then
        bar_color="${BRIGHT_YELLOW}"
    fi

    printf "\r  ${BRIGHT_BLACK}${BOX_VR}${RESET}"
    printf "${bar_color}%*s${RESET}" $filled "" | tr ' ' '█'
    printf "${BRIGHT_BLACK}%*s${RESET}" $empty "" | tr ' ' '░'
    printf "${BRIGHT_BLACK}${BOX_VL}${RESET} ${BOLD}${bar_color}%3d%%${RESET} ${DIM}(%d/%d)${RESET}" $percentage $current $total
}

# Animated progress bar
animate_progress() {
    local total="${1:-100}"
    local delay="${2:-0.05}"

    for ((i=0; i<=total; i++)); do
        print_progress_bar $i $total
        sleep "$delay"
    done
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# STATUS ICONS & MESSAGES
# ═══════════════════════════════════════════════════════════════

# Premium icons
icon_success() { echo -e "${BRIGHT_GREEN}✓${RESET}"; }
icon_error() { echo -e "${BRIGHT_RED}✗${RESET}"; }
icon_warning() { echo -e "${BRIGHT_YELLOW}⚠${RESET}"; }
icon_info() { echo -e "${BRIGHT_BLUE}ℹ${RESET}"; }
icon_arrow() { echo -e "${BRIGHT_CYAN}➜${RESET}"; }
icon_bullet() { echo -e "${BRIGHT_MAGENTA}●${RESET}"; }
icon_link() { echo -e "${BRIGHT_BLUE}↗${RESET}"; }
icon_recycle() { echo -e "${BRIGHT_YELLOW}⟳${RESET}"; }
icon_skip() { echo -e "${DIM}⊘${RESET}"; }
icon_sparkle() { echo -e "${BRIGHT_YELLOW}✨${RESET}"; }
icon_fire() { echo -e "${BRIGHT_RED}🔥${RESET}"; }
icon_rocket() { echo -e "${BRIGHT_CYAN}🚀${RESET}"; }
icon_gem() { echo -e "${BRIGHT_MAGENTA}💎${RESET}"; }
icon_box() { echo -e "${BRIGHT_CYAN}📦${RESET}"; }
icon_art() { echo -e "${BRIGHT_MAGENTA}🎨${RESET}"; }
icon_check() { echo -e "${BRIGHT_GREEN}✔${RESET}"; }
icon_font() { echo -e "${BRIGHT_MAGENTA}Aa${RESET}"; }

# Status messages with icons
msg_success() { echo -e "  $(icon_success) ${GREEN}$1${RESET}"; }
msg_error() { echo -e "  $(icon_error) ${RED}$1${RESET}"; }
msg_warning() { echo -e "  $(icon_warning) ${YELLOW}$1${RESET}"; }
msg_info() { echo -e "  $(icon_info) ${CYAN}$1${RESET}"; }
msg_arrow() { echo -e "  $(icon_arrow) ${BOLD}$1${RESET}"; }
msg_bullet() { echo -e "  $(icon_bullet) $1"; }

# ═══════════════════════════════════════════════════════════════
# BOX DRAWING & TABLES
# ═══════════════════════════════════════════════════════════════

print_separator() {
    local width=${1:-68}
    echo -e "${BRIGHT_BLACK}$(printf '%*s' $width '' | tr ' ' '─')${RESET}"
}

print_thick_separator() {
    local width=${1:-68}
    echo -e "${BRIGHT_CYAN}$(printf '%*s' $width '' | tr ' ' '═')${RESET}"
}

# Double-line header box
print_header_box() {
    local width=${1:-68}
    echo -e "${BRIGHT_CYAN}${BOX_D_TL}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_D_H}")${BOX_D_TR}${RESET}"
}

print_header_separator() {
    local width=${1:-68}
    echo -e "${BRIGHT_CYAN}${BOX_D_VR}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_D_H}")${BOX_D_VL}${RESET}"
}

print_header_footer() {
    local width=${1:-68}
    echo -e "${BRIGHT_CYAN}${BOX_D_BL}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_D_H}")${BOX_D_BR}${RESET}"
}

print_header_row() {
    local content="$1"
    local width=${2:-68}
    local content_len=$(echo -e "$content" | sed 's/\x1b\[[0-9;]*m//g' | wc -c)
    local padding=$((width - content_len - 1))
    echo -e "${BRIGHT_CYAN}${BOX_D_V}${RESET} ${content}$(printf '%*s' $padding '')${BRIGHT_CYAN}${BOX_D_V}${RESET}"
}

# Single-line content box
print_box_top() {
    local width=${1:-68}
    echo -e "${BRIGHT_BLACK}${BOX_TL}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_H}")${BOX_TR}${RESET}"
}

print_box_separator() {
    local width=${1:-68}
    echo -e "${BRIGHT_BLACK}${BOX_VR}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_H}")${BOX_VL}${RESET}"
}

print_box_bottom() {
    local width=${1:-68}
    echo -e "${BRIGHT_BLACK}${BOX_BL}$(printf '%*s' $((width-2)) '' | tr ' ' "${BOX_H}")${BOX_BR}${RESET}"
}

print_box_row() {
    local content="$1"
    local width=${2:-68}
    local content_len=$(echo -e "$content" | sed 's/\x1b\[[0-9;]*m//g' | wc -c)
    local padding=$((width - content_len - 1))
    echo -e "${BRIGHT_BLACK}${BOX_V}${RESET} ${content}$(printf '%*s' $padding '')${BRIGHT_BLACK}${BOX_V}${RESET}"
}

# Tree-style list
print_tree_item() {
    local item="$1"
    local is_last="${2:-false}"

    if [[ "$is_last" == "true" ]]; then
        echo -e "  ${BRIGHT_BLACK}${TREE_LAST}${RESET} ${item}"
    else
        echo -e "  ${BRIGHT_BLACK}${TREE_BRANCH}${RESET} ${item}"
    fi
}

# ═══════════════════════════════════════════════════════════════
# SUMMARY & INFO BOXES
# ═══════════════════════════════════════════════════════════════

print_summary() {
    local title="$1"
    shift
    local width=68

    echo ""
    print_header_box $width
    print_header_row "$(icon_gem) ${BOLD}${title}${RESET}" $width
    print_header_separator $width

    for line in "$@"; do
        print_header_row "$line" $width
    done

    print_header_footer $width
}

print_info_box() {
    local title="$1"
    shift
    local width=68

    echo ""
    print_box_top $width
    print_box_row "${BOLD}${BRIGHT_CYAN}${title}${RESET}" $width
    print_box_separator $width

    for line in "$@"; do
        print_box_row "$line" $width
    done

    print_box_bottom $width
}

# ═══════════════════════════════════════════════════════════════
# CELEBRATION & EFFECTS
# ═══════════════════════════════════════════════════════════════

celebrate() {
    local frames=(
        "    $(icon_sparkle) ${BRIGHT_GREEN}${BOLD}Success!${RESET} $(icon_sparkle)    "
        "   $(icon_sparkle)  ${BRIGHT_GREEN}${BOLD}Success!${RESET}  $(icon_sparkle)   "
        "  $(icon_sparkle)   ${BRIGHT_GREEN}${BOLD}Success!${RESET}   $(icon_sparkle)  "
        "   $(icon_sparkle)  ${BRIGHT_GREEN}${BOLD}Success!${RESET}  $(icon_sparkle)   "
    )

    for frame in "${frames[@]}"; do
        printf "\r%s" "$frame"
        sleep 0.12
    done
    printf "\r%*s\r" 40 ""
    echo -e "    ${BRIGHT_GREEN}$(icon_check)${RESET} ${BOLD}${GREEN}Complete!${RESET}"
}

pulse_effect() {
    local text="$1"
    local colors=("${DIM}" "${RESET}" "${BOLD}" "${RESET}")

    for color in "${colors[@]}"; do
        printf "\r  %s%s%s" "$color" "$text" "${RESET}"
        sleep 0.15
    done
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# INTERACTIVE PROMPTS
# ═══════════════════════════════════════════════════════════════

confirm_prompt() {
    local prompt="$1"
    local default="${2:-n}"

    echo -ne "${BRIGHT_YELLOW}  ❓${RESET} ${BOLD}${prompt}${RESET} "

    if [[ "$default" == "y" ]]; then
        echo -n "${DIM}[${RESET}${BRIGHT_GREEN}Y${RESET}${DIM}/n]${RESET}: "
    else
        echo -n "${DIM}[y/${RESET}${BRIGHT_RED}N${RESET}${DIM}]${RESET}: "
    fi

    read -r response

    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        [nN][oO]|[nN])
            return 1
            ;;
        "")
            [[ "$default" == "y" ]] && return 0 || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════
# FOOTER & TIPS
# ═══════════════════════════════════════════════════════════════

print_footer() {
    local width=68
    echo ""
    echo -e "${DIM}${BRIGHT_BLACK}$(printf '%*s' $width '' | tr ' ' '─')${RESET}"
    echo -e "${DIM}  💡 Tip: Use ${CYAN}--help${RESET}${DIM} for more options${RESET}"
    echo -e "${DIM}${BRIGHT_BLACK}$(printf '%*s' $width '' | tr ' ' '─')${RESET}"
    echo ""
}

print_shortcuts() {
    echo ""
    echo -e "  ${BOLD}${BRIGHT_CYAN}Quick Commands:${RESET}"
    echo -e "     ${CYAN}font-activate <name>${RESET}     ${DIM}Activate fonts${RESET}"
    echo -e "     ${CYAN}font-deactivate <name>${RESET}   ${DIM}Remove fonts${RESET}"
    echo -e "     ${CYAN}font-list-active${RESET}         ${DIM}List activated fonts${RESET}"
    echo -e "     ${CYAN}font-refresh${RESET}             ${DIM}Rebuild cache${RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════
# CLEANUP
# ═══════════════════════════════════════════════════════════════

cleanup_spinner() {
    stop_spinner
    tput cnorm  # Ensure cursor is visible
}

trap cleanup_spinner EXIT INT TERM
