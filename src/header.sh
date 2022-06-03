# Show the logo if no commands are being called or a --help option is present

# header.sh doesnt have access to lib/helpers for some reason.
cli_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

source "$cli_path/src/support/colors.sh"
source "$cli_path/src/support/helpers.sh"

if [ "$#" -eq 0 ] || [[ "$*" == *--help* ]]; then
    export LOGO_TEXT=$(
        cat <<EOF

                █▄░█ █ █▀▀ █░█ ▀█▀ █░█░█ █ █▄░█ █▀▄
                █░▀█ █ █▄█ █▀█ ░█░ ▀▄▀▄▀ █ █░▀█ █▄▀

EOF
    )

    export LOGO_BOAT=$(
        cat <<EOF
    
*     .  *        *                    *           .     .  *        *                    *
    .         '       .        .     .        .         '       .        .     .
.  *           *                     *        .  *           *                     *
                .                                    .                .
*      *         '    *          .   *           .      *         '    *          .   *  
              .     .  *        *                    *
                               ___
                            ___)__)___
                            )__)__)__)
                           _____||_____
                            )_ )__)_)_)
                            __|_||_|____
                            \         /
$(blue "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
EOF
    )
    yellow "$LOGO_TEXT"
    bold "$LOGO_BOAT"
fi
