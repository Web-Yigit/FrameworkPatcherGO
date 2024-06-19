# Function to get the latest framework patch URL
get_framework_patch_url() {
    FWPATCH_GH_URL="https://api.github.com/repos/changhuapeng/FrameworkPatch/releases/latest"
    FILE="classes.dex"
    regex="s#^[[:blank:]]*\"browser_download_url\":[[:blank:]]*\"(https.*$FILE)\"#\1#p"
    wget --no-check-certificate -qO- "$FWPATCH_GH_URL" | sed -nE "$regex"
}

# Function to convert smali path to dex file name
classes_path_to_dex() {
    local path="$1"
    local classes
    classes=$(echo "$path" | sed -nE 's@^.+\/(smali(_classes[[:digit:]]+)*)\/.*\.smali$@\1@p')

    if [ "$classes" == "smali" ]; then
        echo "classes.dex"
    else
        echo "$(echo "$classes" | cut -d'_' -f2).dex"
    fi
}

# Function to get the context value from code
get_context_val() {
    local code="$1"
    local context

    context=$(echo "$code" | grep -E "# Landroid/content/Context;|Landroid/content/Context;->|attach\(Landroid/content/Context;\)" | head -n1)

    if [ -n "$context" ]; then
        context=$(echo "$context" | sed -nE 's/^.*\{(.[[:digit:]]+)\}$/\1/p')
        [ -z "$context" ] && context=$(echo "$context" | cut -d',' -f1)
    fi

    echo "$context"
}
