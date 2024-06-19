get_framework_patch_url() {
    FWPATCH_GH_URL="https://api.github.com/repos/changhuapeng/FrameworkPatch/releases/latest"
    FILE="classes.dex"
    regex="s#^[[:blank:]]*\"browser_download_url\":[[:blank:]]*\"(https.*$FILE)\"#\1#p"
    wget --no-check-certificate -qO- "$FWPATCH_GH_URL" | sed -nE "$regex"
}

classes_path_to_dex() {
    path="$1"
    regex='s@^.+\/(smali(_classes[[:digit:]]+)*)\/.*\.smali$@\1@p'
    classes="$(echo "$path" | sed -nE "$regex")"
    case "$classes" in
        "smali" )
            echo "classes.dex"
            ;;
        *)
            echo "${classes#*_}.dex"
            ;;
    esac
}

get_context_val() {
    code="$1"
    context="$(echo "$code" | grep -E "# Landroid/content/Context;|Landroid/content/Context;->|attach\(Landroid/content/Context;\)" | head -n1)"
    if [ -n "$context" ]; then
        context="$(echo "$context" | sed -nE 's/^.*\{(.[[:digit:]]+)\}$/\1/p')"
        [ -z "$context" ] && context="$(echo "$context" | cut -d',' -f1)"
    fi
    echo "$context"
}
