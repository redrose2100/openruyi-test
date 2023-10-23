#!/usr/bin/bash
# shellcheck disable=SC1091
. /usr/share/beakerlib/beakerlib.sh

rlJournalStart
    rlPhaseStartTest
        rlAssertRpm "setup"
        rlAssertExists "/etc/passwd"
        rlAssertGrep "root" "/etc/passwd"
    rlPhaseEnd
rlJournalEnd