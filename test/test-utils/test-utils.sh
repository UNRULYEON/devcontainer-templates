#!/bin/bash

FAILED=()

echoStderr()
{
    echo "$@" 1>&2
}

check() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if "$@"; then 
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

checkExtension() {
    # Happens asynchronously, so keep retrying 10 times with an increasing delay
    EXTN_ID="$1"
    TIMEOUT_SECONDS="${2:-10}"
    RETRY_COUNT=0
    echo -e -n "\n🧪 Looking for extension $1 for maximum of ${TIMEOUT_SECONDS}s"
    until [ "${RETRY_COUNT}" -eq "${TIMEOUT_SECONDS}" ] || \
        [ ! -e $HOME/.vscode-server/extensions/${EXTN_ID}* ] || \
        [ ! -e $HOME/.vscode-server-insiders/extensions/${EXTN_ID}* ] || \
        [ ! -e $HOME/.vscode-test-server/extensions/${EXTN_ID}* ] || \
        [ ! -e $HOME/.vscode-remote/extensions/${EXTN_ID}* ]
    do
        sleep 1s
        (( RETRY_COUNT++ ))
        echo -n "."
    done

    if [ ${RETRY_COUNT} -lt ${TIMEOUT_SECONDS} ]; then
        echo -e "\n✅ Passed!"
        return 0
    else
        echoStderr -e "\n❌ Extension $EXTN_ID not found."
        FAILED+=("$LABEL")
        return 1
    fi
}

reportResults() {
    if [ ${#FAILED[@]} -ne 0 ]; then
        echoStderr -e "\n💥  Failed tests: ${FAILED[@]}"
        exit 1
    else 
        echo -e "\n💯  All passed!"
        exit 0
    fi
}
