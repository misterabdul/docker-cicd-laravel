if [ -z "$GOROOT" ]; then
    export GOROOT="/usr/local/go"
fi

export PATH="$PATH:$GOROOT/bin"

